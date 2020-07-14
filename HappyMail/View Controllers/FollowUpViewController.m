//
//  FollowUpViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpViewController.h"
#import "FollowUpCell.h"

@interface FollowUpViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *followUps;

@end

@implementation FollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.followUps = [User currentUser].followUps;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowUpCell"];
    
    // Populate cells with user's personal follow-ups
    Post *post = self.followUps[indexPath.row];
    [cell refreshFollowUp:post];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followUps.count;
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
