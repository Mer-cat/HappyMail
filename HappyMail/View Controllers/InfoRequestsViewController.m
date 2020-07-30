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
#import "Utils.h"

@interface InfoRequestsViewController () <UITableViewDelegate, UITableViewDataSource, InfoRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoRequests;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation InfoRequestsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchInfoRequests];
    
    // Add refresh control
    self.refreshControl = [Utils createRefreshControlInView:self.tableView withSelector:@selector(fetchInfoRequests) withColor:[UIColor brownColor] fromController:self];
    
    // Auto-refresh
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchInfoRequests) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoRequests.count;
}

#pragma mark - Parse query

- (void)fetchInfoRequests {
    PFQuery *infoQuery = [PFQuery queryWithClassName:@"InfoRequest"];
    [infoQuery whereKey:@"requestedUser" equalTo:[User currentUser]];
    [infoQuery includeKey:@"requestedUser"];
    [infoQuery includeKey:@"requestingUser"];
    [infoQuery includeKey:@"associatedPost"];
    [infoQuery includeKey:@"requestedUser.address"];
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
    PFQuery *infoQuery = [PFQuery queryWithClassName:@"InfoRequest"];
    [infoQuery whereKey:@"requestedUser" equalTo:[User currentUser]];
    [infoQuery includeKey:@"requestedUser"];
    [infoQuery includeKey:@"requestingUser"];
    [infoQuery includeKey:@"associatedPost"];
    [infoQuery includeKey:@"requestedUser.address"];
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

#pragma mark - InfoRequestCellDelegate

- (void)didChangeInfoRequest:(InfoRequest *)infoRequest {
    [self.infoRequests removeObject:infoRequest];
    [self.tableView reloadData];
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
