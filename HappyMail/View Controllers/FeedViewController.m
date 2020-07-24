//
//  FeedViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FeedViewController.h"
#import "PostCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "PostDetailsViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "Constants.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filteredPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;
@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic) FilterOption selectedFilter;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation FeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dropDownTableView.delegate = self;
    self.dropDownTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    // Currently has to be manually updated with typedef
    self.filterOptions = @[@"Offers",@"Requests",@"Within last week",@"Within last day"];
    self.selectedFilter = None;
    self.isMoreDataLoading = NO;
    
    // Initialize/clear out arrays
    self.filteredPosts = [[NSMutableArray alloc] init];
    
    // Set height for drop-down table view based on array data
    CGFloat height = self.dropDownTableView.rowHeight;
    height *= self.filterOptions.count;
    
    CGRect tableFrame = self.dropDownTableView.frame;
    tableFrame.size.height = height;
    self.dropDownTableView.frame = tableFrame;
    
    // Deselects any previously selected rows
    if ([self.tableView indexPathForSelectedRow]) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    
    [self fetchPosts];
    
    // Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor systemIndigoColor]];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

#pragma mark - Data fetching

- (void)fetchPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"respondees"];
    
    switch (self.selectedFilter) {
        case AllOffers:
            [postQuery whereKey:@"type" equalTo: [NSNumber numberWithInt:Offer]];
            break;
        case AllRequests:
            [postQuery whereKey:@"type" equalTo: [NSNumber numberWithInt:Request]];
            break;
        case LastWeek:{
            NSDate *sevenDaysAgo = [[NSDate date] dateByAddingDays:-7];
            [postQuery whereKey:@"createdAt" greaterThanOrEqualTo:sevenDaysAgo];
            break;
        }
        case LastDay:{
            NSDate *oneDayAgo = [[NSDate date] dateByAddingDays:-1];
            [postQuery whereKey:@"createdAt" greaterThanOrEqualTo:oneDayAgo];
            break;
        }
        case None:{
            break;
        }
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
    }
    if (self.isMoreDataLoading) {
        NSLog(@"%lu", self.filteredPosts.count);
        postQuery.skip = self.filteredPosts.count;
    }
    postQuery.limit = 20;
    
    // Fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *error) {
        if (posts != nil) {
            if (self.isMoreDataLoading) {
                self.isMoreDataLoading = NO;
                [self.filteredPosts addObjectsFromArray:posts];
            } else {
                self.filteredPosts = (NSMutableArray *) posts;
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting posts: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - Actions

- (IBAction)didPressFilter:(id)sender {
    self.dropDownTableView.hidden = !self.dropDownTableView.hidden;
}

#pragma mark - ComposeViewControllerDelegate

- (void)didPost:(Post *)post {
    // If the new post matches the current filter, show it immediately
    if (post.type == (NSInteger) self.selectedFilter || self.selectedFilter == None) {
        [self.filteredPosts insertObject:post atIndex:0];
    }
    // New post will show when results are un-filtered if it doesn't match current filter
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Differentiate between drop down and regular table view
    if ([tableView isEqual:self.tableView]) {
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        Post *post = self.filteredPosts[indexPath.row];
        
        // Load the cell with current post
        [cell refreshPost:post];
        return cell;
    } else {
        static NSString *filterCellIdentifier = @"FilterCellItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:filterCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filterCellIdentifier];
        }
        
        cell.textLabel.text = self.filterOptions[indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.filteredPosts.count;
    } else {
        return self.filterOptions.count;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dealing with drop-down table view filter options
    if ([tableView isEqual:self.dropDownTableView]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // If a different filter was previously selected
        // and user is selecting a new filter
        if (self.selectedFilter != indexPath.row) {
            
            // Unselect previously selected cell
            NSIndexPath *previousCellIndexPath = [NSIndexPath indexPathForRow:self.selectedFilter inSection:0];
            UITableViewCell *previousCell = [tableView cellForRowAtIndexPath: previousCellIndexPath];
            previousCell.accessoryType = UITableViewCellAccessoryNone;
            
            // When user taps a cell, display check mark for that cell
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self selectNewFilter:indexPath.row];
            
        } else {  // Unselect previously selected filter
            
            // Unshow check mark
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self selectNewFilter:None];
        }
    }
}

#pragma mark - Filtering helper

/**
 *  Update posts, filtering by selected filter
 */
- (void)selectNewFilter:(FilterOption)selectedFilter {
    self.selectedFilter = selectedFilter;
    [self fetchPosts];
}

#pragma mark - UISearchBarDelegate

/**
 * Filter posts based on title
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Post *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.title localizedStandardContainsString:searchText];
        }];
        self.filteredPosts = (NSMutableArray *)[self.filteredPosts filteredArrayUsingPredicate:predicate];
    } else {
        [self fetchPosts];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

/**
 * Clear the search bar and re-set the posts if user cancels search
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self fetchPosts];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshhold = scrollViewContentHeight - self.tableView.bounds.size.height;

        // When the user scrolls past the threshold, start requesting
        if (scrollView.contentOffset.y > scrollOffsetThreshhold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            [self fetchPosts];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostDetailsSegue"]) {
        PostDetailsViewController *detailsViewController = [segue destinationViewController];
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *specificPost = self.filteredPosts[indexPath.row];
        detailsViewController.post = specificPost;
    } else if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        
        // Grab post from cell where user tapped username
        PostCell *cell = (PostCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Post *post = self.filteredPosts[indexPath.row];
        
        // If viewing another user's profile
        if (![post.author.username isEqualToString:[User currentUser].username]) {
            profileViewController.user = post.author;
        }
    } else if ([segue.identifier isEqualToString:@"ComposeViewSegue"]) {
        
        // Designate this VC as delegate so we can
        // Load in new posts immediately
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeViewController = (ComposeViewController *)navigationController.topViewController;
        composeViewController.delegate = self;
    }
}

@end
