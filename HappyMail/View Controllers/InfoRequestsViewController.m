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
    [infoQuery orderByDescending:@"createdAt"];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
