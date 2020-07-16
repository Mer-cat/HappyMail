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

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource, FollowUpCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *followUps;
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
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUpCell"];
    cell.delegate = self;
    
    // Populate cells with user's personal follow-ups
    FollowUp *followUp = self.followUps[indexPath.row];
    [cell refreshFollowUp:followUp];
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
    [self.tableView reloadData];
}

#pragma mark - Parse network calls

/**
 * Fetch the user's follow-ups from Parse
 */
- (void)fetchFollowUps {
    PFQuery *query = [PFQuery queryWithClassName:@"FollowUp"];
    [query whereKey:@"sendingUser" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successfully fetched user's follow-ups");
            self.followUps = (NSMutableArray *) objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error fetching follow-ups: %@", error.localizedDescription);
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
