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

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *followUps;
@property (nonatomic, strong) NSMutableArray *unpackedFollowUps;

@end

@implementation FollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.followUps = [User currentUser].followUps;
    [self unpackFollowUps];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUpCell"];
    
    // Populate cells with user's personal follow-ups
    FollowUp *followUp = self.unpackedFollowUps[indexPath.row];
    [cell refreshFollowUp:followUp];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.unpackedFollowUps.count;
}

/**
 * Given the user's list of follow-up posts, unpacks them into an array of follow-up objects
 */
- (void)unpackFollowUps {
    for (Post *post in self.followUps) {
        // User's offers to follow up on
        if (post.type == 0) {
            // Create a follow-up for each user
            // who responded to current user's offer
            for (User *user in post.respondees) {
                FollowUp *newFollowUp = [[FollowUp alloc] init];
                newFollowUp.receivingUser = user;
                newFollowUp.originalPost = post;
                [self.unpackedFollowUps addObject:newFollowUp];
            }
        } else if (post.type == 1) {  // Other user's requests
            // Create a follow-up for each request from other
            // users that current user responded to
            FollowUp *newFollowUp = [[FollowUp alloc] init];
            newFollowUp.receivingUser = post.author;
            newFollowUp.originalPost = post;
            [self.unpackedFollowUps addObject:newFollowUp];
        }
    }
    [self.tableView reloadData];
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
