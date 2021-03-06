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
#import "Utils.h"
#import "FollowUpViewController.h"
#import "MBProgressHUD.h"
#import <ChameleonFramework/Chameleon.h>

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate, PostDetailsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filteredPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;
@property (nonatomic) FilterOption selectedFilter;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) BOOL userIsSearching;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) MBProgressHUD *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownTableViewHeightConstraint;

@end

@implementation FeedViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show progress indicator
    self.activityIndicator = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.activityIndicator.label.text = @"Loading...";
    
    self.searchBar.delegate = self;
    
    // Initialize tableviews
    [self initTableViewUI];
    [self initDropDownTableViewUI];
    
    // Initialize variables
    self.selectedFilter = None;
    self.isMoreDataLoading = NO;
    self.filteredPosts = [[NSMutableArray alloc] init];
    
    // Populate table view
    [self fetchPosts];
    
    // Show follow-up notifications
    [self loadFollowUpBadgeIcon];
    
    // Add refresh control
    self.refreshControl = [Utils createRefreshControlInView:self.tableView withSelector:@selector(fetchPosts) withColor:[UIColor whiteColor] fromController:self];
}

#pragma mark - Init

- (void)initTableViewUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Deselects any previously selected rows
    if ([self.tableView indexPathForSelectedRow]) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    
    // Remove edge insets for separator
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // Do not display insets when table view is empty
    self.tableView.tableFooterView = [UIView new];
}

- (void)initDropDownTableViewUI {
    self.dropDownTableView.delegate = self;
    self.dropDownTableView.dataSource = self;
    
    // Set height of table view based on number of rows.
    self.dropDownTableViewHeightConstraint.constant = self.dropDownTableView.rowHeight * FILTER_ARRAY.count;
    
    self.dropDownTableView.layoutMargins = UIEdgeInsetsZero;
    self.dropDownTableView.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - Data fetching

- (void)fetchPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"respondees"];
    
    if (self.userIsSearching) {
        [postQuery whereKey:@"title" matchesRegex:self.searchText modifiers:@"i"];
    }
    
    switch (self.selectedFilter) {
        case AllOffers:
            [postQuery whereKey:@"type" equalTo: [NSNumber numberWithInt:Offer]];
            break;
        case AllRequests:
            [postQuery whereKey:@"type" equalTo: [NSNumber numberWithInt:Request]];
            break;
        case AllThankYous:
            [postQuery whereKey:@"type" equalTo: [NSNumber numberWithInt:ThankYou]];
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
        case None:
            break;
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
        [self.activityIndicator hideAnimated:YES];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Actions

/**
 * Hide and unhide the drop down table view with filter options
 */
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

#pragma mark - PostDetailsViewControllerDelegate

/**
 * Show updated response count immediately after new response
 */
- (void)didRespond {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Differentiate between drop down and regular table view
    if ([tableView isEqual:self.tableView]) {
        return [self setPostCellWithIndexPath:indexPath forTableView:tableView];
    } else {
        return [self setDropDownCellWithIndexPath:indexPath forTableView:tableView];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.filteredPosts.count;
    } else {
        return FILTER_ARRAY.count;
    }
}

#pragma mark - Table view cell setters

- (PostCell *)setPostCellWithIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.filteredPosts[indexPath.row];
    
    // Remove separator inset from cells
    cell.layoutMargins = UIEdgeInsetsZero;
    
    // Load the cell with current post
    [cell refreshPost:post];
    return cell;
}

- (UITableViewCell *)setDropDownCellWithIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
    static NSString *filterCellIdentifier = @"FilterCellItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:filterCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filterCellIdentifier];
    }
    cell.backgroundColor = FlatWhite;
    cell.textLabel.text = FILTER_ARRAY[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Do not display if selected filter is "None"
    if (self.selectedFilter < FILTER_ARRAY.count) {
        return [NSString stringWithFormat:@"Filter: %@",FILTER_ARRAY[self.selectedFilter]];
    }
    return @"";
}

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
 * If text is erased, un-filter posts
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0) {
        self.userIsSearching = NO;
        
        // Hide the keyboard
        [self.searchBar resignFirstResponder];
        
        // Re-fetch posts without search query
        [self fetchPosts];
    }
}

/**
 * Make new query with search criteria upon search button clicked
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.searchTextField.text;
    if (searchText.length != 0) {
        self.userIsSearching = YES;
        self.searchText = searchText;
    }
    [self.searchBar resignFirstResponder];
    [self fetchPosts];
}

#pragma mark - UIScrollViewDelegate

/**
 * Load in more posts when user scrolls to bottom of current set of posts
 */
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

#pragma mark - Tab bar badges init

- (void)loadFollowUpBadgeIcon {
    FollowUpViewController *followUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowUpViewController"];;
    [followUpViewController fetchFollowUpsWithCompletion:^(NSArray *followUps, NSError *error) {
        if (followUps) {
            // Must use the same reference in order to update badge value properly
            [self.tabBarController.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%lu", followUps.count];
        } else {
            NSLog(@"Error fetching follow-ups: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation segue helpers

- (void)prepareForPostDetailsSegue:(PostDetailsViewController *)detailsViewController sender:(id)sender {
    PostCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Post *specificPost = self.filteredPosts[indexPath.row];
    detailsViewController.post = specificPost;
    detailsViewController.posts = self.filteredPosts;
    detailsViewController.delegate = self;
}

- (void)prepareForProfileViewSegue:(ProfileViewController *)profileViewController sender:(id)sender {
    // Grab post from cell where user tapped username
    PostCell *cell = (PostCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Post *post = self.filteredPosts[indexPath.row];
    
    // If viewing another user's profile
    if (![post.author.username isEqualToString:[User currentUser].username]) {
        profileViewController.user = post.author;
    }
}

- (void)prepareForComposeViewSegue:(UINavigationController *)navigationController {
    // Designate this VC as delegate so we can
    // Load in new posts immediately
    ComposeViewController *composeViewController = (ComposeViewController *)navigationController.topViewController;
    composeViewController.delegate = self;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostDetailsSegue"]) {
        [self prepareForPostDetailsSegue:[segue destinationViewController] sender:sender];
    } else if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        [self prepareForProfileViewSegue:[segue destinationViewController] sender:sender];
    } else if ([segue.identifier isEqualToString:@"ComposeViewSegue"]) {
        [self prepareForComposeViewSegue:[segue destinationViewController]];
    }
}

@end
