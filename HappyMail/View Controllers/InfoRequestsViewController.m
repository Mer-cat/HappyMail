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

/**
 * View controller for viewing a user's InfoRequests
 */
@interface InfoRequestsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *infoRequests;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation InfoRequestsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchInfoRequests];
    
    // Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor systemIndigoColor]];
    [self.refreshControl addTarget:self action:@selector(fetchInfoRequests) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoRequestCell *infoRequestCell = [self.tableView dequeueReusableCellWithIdentifier:@"InfoRequestCell"];
    InfoRequest *infoRequest = self.infoRequests[indexPath.row];
    [infoRequestCell refreshInfoRequestCell:infoRequest];
    
    return infoRequestCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoRequests.count;
}

#pragma mark - Parse query

- (void)fetchInfoRequests {
    PFQuery *infoQuery = [PFQuery queryWithClassName:@"InfoRequest"];
    [infoQuery whereKey:@"requestedUser" equalTo:[User currentUser]];
    [infoQuery orderByAscending:@"createdAt"];
    
    // Fetch data asynchronously
    [infoQuery findObjectsInBackgroundWithBlock:^(NSArray<InfoRequest *> *infoRequests, NSError *error) {
        if (infoRequests != nil) {
            self.infoRequests = infoRequests;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting info requests: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostDetailsViewSegue"]) {
        PostDetailsViewController *detailsViewController = [segue destinationViewController];
        InfoRequestCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        InfoRequest *infoRequest = self.infoRequests[indexPath.row];
        Post *post = infoRequest.associatedPost;
        detailsViewController.post = post;
    } else if ([segue.identifier isEqualToString:@"ProfileViewSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        
        // Grab post from cell where user tapped username
        InfoRequestCell *cell = (InfoRequestCell *)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        InfoRequest *infoRequest = self.infoRequests[indexPath.row];
        
        if (![infoRequest.requestingUser.username isEqualToString:[User currentUser].username]) {
            profileViewController.user = infoRequest.requestingUser;
        }
    }
}

@end
