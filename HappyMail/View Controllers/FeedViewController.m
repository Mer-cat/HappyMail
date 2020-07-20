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
#import "DateTools.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSArray *filteredPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;
@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic, strong) NSArray *previousFilteredPosts;
@property (nonatomic) FilterOption selectedFilter;

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

#pragma mark - Parse queries

- (void)fetchPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"respondees"];
    postQuery.limit = 20;
    
    // Fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            NSLog(@"Query being called");
            if (self.selectedFilter == None) {
                self.filteredPosts = posts;
                self.previousFilteredPosts = posts;
            } else {
                [self selectNewFilter:self.selectedFilter];
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

- (void)didPost:(Post *) post {
    [self.posts insertObject:post atIndex:0];
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
            
            // Unfilter posts before applying new filter
            self.filteredPosts = self.posts;
            
            // When user taps a cell, display check mark for that cell
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self selectNewFilter:indexPath.row];
            [self.tableView reloadData];

        } else {  // Unselect previously selected filter
            
            // Unshow check mark
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.selectedFilter = None;
            
            // Unfilter posts
            self.filteredPosts = self.posts;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Filtering helper

/**
 *  Chooses predicate based on filter selection and updates filtered posts
 */
- (void)selectNewFilter:(FilterOption)selectedFilter {
    self.selectedFilter = selectedFilter;
    NSDate *currentDate = [NSDate date];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Post *evaluatedObject, NSDictionary *bindings) {
        switch(self.selectedFilter) {
            case AllOffers:
                return (evaluatedObject.type == Offer);
            case AllRequests:
                return (evaluatedObject.type == Request);
            case LastWeek:{
                DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:evaluatedObject.createdAt endDate:currentDate];
                double timeSincePostingInWeeks = [timePeriod durationInWeeks];
                return (timeSincePostingInWeeks <= 1);
            }
            case LastDay:{
                DTTimePeriod *timePeriod = [[DTTimePeriod alloc] initWithStartDate:evaluatedObject.createdAt endDate:currentDate];
                double timeSincePostingInDays = [timePeriod durationInDays];
                return (timeSincePostingInDays <= 1);
            }
            default:
                return evaluatedObject;
                // [NSException raise:NSGenericException format:@"Unexpected FilterOption"];
        }
    }];
    
    // Stores the posts before new filter is applied
    // so that we can revert if needed
    self.previousFilteredPosts = self.filteredPosts;
    self.filteredPosts = [self.filteredPosts filteredArrayUsingPredicate:predicate];
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
        self.filteredPosts = [self.filteredPosts filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredPosts = self.previousFilteredPosts;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.previousFilteredPosts = self.filteredPosts;
    self.searchBar.showsCancelButton = YES;
}

/**
 * Clear the search bar and re-set the posts if user cancels search
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredPosts = self.previousFilteredPosts;
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
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
