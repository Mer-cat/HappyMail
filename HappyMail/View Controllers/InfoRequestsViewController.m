//
//  InfoRequestsViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequestsViewController.h"
#import "InfoRequestCell.h"
#import "InfoRequest.h"
#import "PostDetailsViewController.h"
#import "ProfileViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ChameleonFramework/Chameleon.h"
#import "Utils.h"

@interface InfoRequestsViewController () <UITableViewDelegate, UITableViewDataSource, InfoRequestCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoRequests;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation InfoRequestsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchInfoRequests];
    [self initTableView];
    
    // Add refresh control
    self.refreshControl = [Utils createRefreshControlInView:self.tableView withSelector:@selector(fetchInfoRequests) withColor:FlatBlack fromController:self];
    
    // Auto-refresh
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fetchInfoRequests) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoRequests.count;
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

#pragma mark - Parse query

- (void)fetchInfoRequests {
    PFQuery *infoQuery = [PFQuery queryWithClassName:@"InfoRequest"];
    [infoQuery whereKey:@"requestedUser" equalTo:[User currentUser]];
    [infoQuery includeKey:@"requestedUser.address"];
    [infoQuery includeKey:@"requestingUser"];
    [infoQuery includeKey:@"associatedPost.author"];
    [infoQuery includeKey:@"associatedPost.respondees"];
    [infoQuery orderByAscending:@"createdAt"];
    
    // Fetch data asynchronously
    [infoQuery findObjectsInBackgroundWithBlock:^(NSArray<InfoRequest *> *infoRequests, NSError *error) {
        if (infoRequests != nil) {
            self.infoRequests = (NSMutableArray *) infoRequests;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting info requests: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)fetchInfoRequestsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    PFQuery *infoQuery = [InfoRequest query];
    [infoQuery whereKey:@"requestedUser" equalTo:[User currentUser]];
    [infoQuery includeKey:@"requestedUser"];
    [infoQuery includeKey:@"requestingUser"];
    [infoQuery includeKey:@"associatedPost.author"];
    [infoQuery includeKey:@"associatedPost.respondees"];
    [infoQuery orderByAscending:@"createdAt"];
    
    // Fetch data asynchronously
    [infoQuery findObjectsInBackgroundWithBlock:^(NSArray<InfoRequest *> *infoRequests, NSError *error) {
        if (infoRequests != nil) {
            self.infoRequests = (NSMutableArray *) infoRequests;
            [self.tableView reloadData];
            completion(infoRequests, nil);
        } else {
            NSLog(@"Error getting info requests: %@", error.localizedDescription);
            completion(nil, error);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoRequestCell *infoRequestCell = [self.tableView dequeueReusableCellWithIdentifier:@"InfoRequestCell"];
    InfoRequest *infoRequest = self.infoRequests[indexPath.row];
    infoRequestCell.delegate = self;
    [infoRequestCell refreshInfoRequestCell:infoRequest];
    
    return infoRequestCell;
}

#pragma mark - UITableViewDelegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoRequestCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIContextualAction *approveAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Approve" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self userApproved:cell];
    }];
    approveAction.backgroundColor = FlatGreen;
    
    UIContextualAction *denyAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Deny" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self userDenied:cell];
    }];
    
    NSArray *actions = @[denyAction, approveAction];
    UISwipeActionsConfiguration *newSwipeAction = [UISwipeActionsConfiguration configurationWithActions:actions];
    
    return newSwipeAction;
}

#pragma mark - Completion helpers

- (void)userApproved:(InfoRequestCell *)cell {
    // Put alert here if necessary
    [cell markAsApproved];
}

- (void)userDenied:(InfoRequestCell *)cell {
    // Put alert here if necessary
    [cell markAsDenied];
}

#pragma mark - InfoRequestCellDelegate

- (void)didChangeInfoRequest:(InfoRequest *)infoRequest {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.infoRequests indexOfObject:infoRequest] inSection:0];
    [self.infoRequests removeObject:infoRequest];

    // Fade out row
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)showRequestDetailView:(id)sender {
    [self performSegueWithIdentifier:@"RequestDetailsSegue" sender:sender];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"questionmark"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No info-requests found";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"These are created when a user would like your information to send you a card. Make a request to get some!";
    
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

- (void)prepareForRequestDetailsSegue:(PostDetailsViewController *)detailsViewController sender:(id)sender {
    InfoRequestCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    InfoRequest *infoRequest = self.infoRequests[indexPath.row];
    detailsViewController.post = infoRequest.associatedPost;
}

- (void)prepareForProfileViewSegue:(ProfileViewController *)profileViewController sender:(id)sender {
    // Grab post from cell where user tapped username
     InfoRequestCell *cell = (InfoRequestCell *)[[sender superview] superview];
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     InfoRequest *infoRequest = self.infoRequests[indexPath.row];
     
     if (![infoRequest.requestingUser.username isEqualToString:[User currentUser].username]) {
         profileViewController.user = infoRequest.requestingUser;
     }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RequestDetailsSegue"]) {
        [self prepareForRequestDetailsSegue:[segue destinationViewController] sender:sender];
    } else if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        [self prepareForProfileViewSegue:[segue destinationViewController] sender:sender];
    }
}

@end
