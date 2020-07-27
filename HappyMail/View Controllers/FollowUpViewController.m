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
#import "BBBadgeBarButtonItem.h"
#import "Utils.h"

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource, FollowUpCellDelegate>
@property (nonatomic, strong) NSMutableArray *followUps;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FollowUpViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchFollowUps];
    
    // Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor systemIndigoColor]];
    [self.refreshControl addTarget:self action:@selector(fetchFollowUps) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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

#pragma mark - Init

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

#pragma mark - FollowUpCellDelegate

/**
 * Allows completed follow-ups to be immediately removed without user refreshing
 */
- (void)didChangeFollowUp:(FollowUp *)followUp {
    [self.followUps removeObject:followUp];
    NSString *followUpCount = [NSString stringWithFormat:@"%lu", self.followUps.count];
    self.navigationController.tabBarItem.badgeValue = followUpCount;
    [self.tableView reloadData];
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
    [query includeKey:@"originalPost"];
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
    [query includeKey:@"originalPost"];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        
        // Grab post from cell where user tapped username
        FollowUpCell *cell = (FollowUpCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        FollowUp *followUp = self.followUps[indexPath.row];
        
        // If viewing another user's profile
        if (![followUp.receivingUser.username isEqualToString:[User currentUser].username]) {
            profileViewController.user = followUp.receivingUser;
        }
    }
}

@end
