//
//  FollowUpViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpViewController.h"
#import "FollowUpCell.h"
#import "UnpackedFollowUp.h"
#import "Post.h"
#import "User.h"
#import <Parse/Parse.h>

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *followUps;
@property (nonatomic, strong) NSMutableArray *unpackedFollowUps;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    
    // TODO: Set up live query to auto-reload table view when followUps change
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUpCell"];
    
    // Populate cells with user's personal follow-ups
    UnpackedFollowUp *followUp = self.unpackedFollowUps[indexPath.row];
    [cell refreshFollowUp:followUp];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@", self.unpackedFollowUps);
    return self.unpackedFollowUps.count;
}

#pragma mark - Parse network calls

/**
 * Fetch the user's follow-ups from Parse
 */
- (void)fetchFollowUps {
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:[User currentUser].username];
    [query includeKey:@"followUps"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully fetched user's follow-ups");
            User *user = objects[0];
            self.followUps = user.followUps;
            [self unpackFollowUps];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error fetching follow-ups: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Helpers

/**
 * Given the user's list of follow-up posts, unpacks them into an array of follow-up objects
 */
- (void)unpackFollowUps {
    // Zero out the array so that we do not create duplicates
    self.unpackedFollowUps = [NSMutableArray new];
    
    for (Post *post in self.followUps) {
        // User's offers to follow up on
        if (post.type == 0) {
            
            // Create a follow-up for each user
            // who responded to current user's offer
            NSLog(@"%@", post.respondees);
            for (User *user in post.respondees) {
                UnpackedFollowUp *newFollowUp = [[UnpackedFollowUp alloc] init];
                newFollowUp.receivingUser = user;
                newFollowUp.originalPost = post;
                [self.unpackedFollowUps addObject:newFollowUp];
            }
        } else if (post.type == 1) {  // Other user's requests
            
            // Create a follow-up for each request from other
            // users that current user responded to
            UnpackedFollowUp *newFollowUp = [[UnpackedFollowUp alloc] init];
            newFollowUp.receivingUser = post.author;
            newFollowUp.originalPost = post;
            [self.unpackedFollowUps addObject:newFollowUp];
        }
    }
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
