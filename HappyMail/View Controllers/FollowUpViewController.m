//
//  FollowUpViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpViewController.h"
#import "FollowUpCell.h"
#import "FollowUp.h"
#import "Post.h"
#import "User.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "InfoRequestsViewController.h"
#import "PostDetailsViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "ChameleonFramework/Chameleon.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Utils.h"

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource, FollowUpCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *followUps;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FollowUpViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self fetchFollowUps];
    
    // Add refresh control
    self.refreshControl = [Utils createRefreshControlInView:self.tableView withSelector:@selector(fetchFollowUps) withColor:FlatBlack fromController:self];
    
    // Auto-refresh
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fetchFollowUps) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self infoRequestsButtonInit];
}

#pragma mark - Parse network calls

/**
 * Fetch the user's follow-ups from Parse, without completion
 */
- (void)fetchFollowUps {
    PFQuery *query = [PFQuery queryWithClassName:@"FollowUp"];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"receivingUser"];
    [query includeKey:@"sendingUser"];
    [query includeKey:@"originalPost.author"];
    [query includeKey:@"originalPost.respondees"];
    [query whereKey:@"sendingUser" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable followUps, NSError * _Nullable error) {
        if (!error) {
            self.followUps = (NSMutableArray *) followUps;
            NSString *followUpCount = [NSString stringWithFormat:@"%lu", self.followUps.count];
            self.navigationController.tabBarItem.badgeValue = followUpCount;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error fetching follow-ups: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)fetchFollowUpsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"FollowUp"];
    [query includeKey:@"receivingUser"];
    [query includeKey:@"sendingUser"];
    [query includeKey:@"originalPost.author"];
    [query includeKey:@"originalPost.respondees"];
    [query whereKey:@"sendingUser" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable followUps, NSError * _Nullable error) {
        if (!error) {
            self.followUps = (NSMutableArray *) followUps;
            [self.tableView reloadData];
            completion(followUps, nil);
        } else {
            NSLog(@"Error fetching follow-ups: %@", error.localizedDescription);
            completion(nil, error);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Init

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // Do not display insets when table view is empty
    self.tableView.tableFooterView = [UIView new];
}

/**
 * Create a custom bar button item that supports a badge
 * To show the number of unresolved info requests a user has
 */
- (void)infoRequestsButtonInit {
    // Set custom button
    UIButton *customButton = [[UIButton alloc] init];
    CGSize navBarIconSize = CGSizeMake(30, 30);
    UIImage *resizedImage = [Utils resizeImage:[UIImage imageNamed:@"infoRequestIcon"] withSize:navBarIconSize];
    [customButton setImage:resizedImage forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(infoRequestButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    // Init bar button
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeOriginX = 20;
    barButton.badgeOriginY = -10;
    
    InfoRequestsViewController *infoRequestsController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoRequestsController"];
    [infoRequestsController fetchInfoRequestsWithCompletion:^(NSArray *infoRequests, NSError *error) {
        if (infoRequests) {
            barButton.badgeValue = [NSString stringWithFormat:@"%lu", infoRequests.count];
        } else {
            NSLog(@"Error fetching info requests: %@", error.localizedDescription);
        }
    }];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

#pragma mark - Actions

- (void)infoRequestButtonPressed:(UIButton *)sender {
    // Show info requests view controller
    [self performSegueWithIdentifier:@"InfoRequestsSegue" sender:self];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUpCell"];
    cell.delegate = self;
    
    // Populate cells with user's personal follow-ups
    FollowUp *followUp = self.followUps[indexPath.row];
    [cell refreshFollowUp:followUp];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followUps.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell showButtons];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell hideButtons];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowUpCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIContextualAction *completeAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Mark as complete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self userMarkedAsComplete:cell];
    }];
    completeAction.backgroundColor = FlatGreen;
    
    UIContextualAction *incompleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Mark as unable to complete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self userMarkedAsIncomplete:cell];
    }];
    
    NSArray *actions = @[incompleteAction, completeAction];
    UISwipeActionsConfiguration *newSwipeAction = [UISwipeActionsConfiguration configurationWithActions:actions];
    
    return newSwipeAction;
}

#pragma mark - Completion helpers

- (void)userMarkedAsComplete:(FollowUpCell *)cell {
    // Put alert here if necessary
    [cell markAsComplete];
}

- (void)userMarkedAsIncomplete:(FollowUpCell *)cell {
    // Put alert here if necessary
    [cell markAsIncomplete];
}

#pragma mark - FollowUpCellDelegate

/**
 * Allows completed follow-ups to be immediately removed without user refreshing
 */
- (void)didChangeFollowUp:(FollowUp *)followUp {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.followUps indexOfObject:followUp] inSection:0];
    [self.followUps removeObject:followUp];
    NSString *followUpCount = [NSString stringWithFormat:@"%lu", self.followUps.count];
    self.navigationController.tabBarItem.badgeValue = followUpCount;
    
    // Fade out row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)showPostDetailView:(id)sender {
    [self performSegueWithIdentifier:@"PostDetailsSegue" sender:sender];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"mailboxplaceholder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No follow-ups found";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"These are created when someone responds to one of your offers or you respond to a request. Create an offer or respond to a request in order to make some!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - Navigation segue helpers

- (void)prepareForProfileViewSegue:(ProfileViewController *)profileViewController sender:(id)sender {
    // Grab post from cell where user tapped username
    FollowUpCell *cell = (FollowUpCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FollowUp *followUp = self.followUps[indexPath.row];
    
    // If viewing another user's profile
    if (![followUp.receivingUser.username isEqualToString:[User currentUser].username]) {
        profileViewController.user = followUp.receivingUser;
    }
}

- (void)prepareForPostDetailsSegue:(PostDetailsViewController *)detailsViewController sender:(id)sender {
    FollowUpCell *tappedCell = (FollowUpCell *) sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    FollowUp *followUp = self.followUps[indexPath.row];
    detailsViewController.post = followUp.originalPost;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        [self prepareForProfileViewSegue:[segue destinationViewController] sender:sender];
    } else if ([segue.identifier isEqualToString:@"PostDetailsSegue"]) {
        [self prepareForPostDetailsSegue:[segue destinationViewController] sender:sender];
    }
}

@end
