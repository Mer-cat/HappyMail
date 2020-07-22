//
//  InfoRequestCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequestCell.h"
#import "FollowUp.h"

/**
 * Custom UITableViewCell to show an InfoRequest object
 */
@interface InfoRequestCell ()

@property (weak, nonatomic) IBOutlet UIButton *usernameButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestButtonLabel;
@property (nonatomic, strong) InfoRequest *infoRequest;

@end

@implementation InfoRequestCell

#pragma mark - Init

- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest {
    self.infoRequest = infoRequest;
    [self.infoRequest.requestingUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self.usernameButtonLabel setTitle:self.infoRequest.requestingUser.username forState:UIControlStateNormal];
        } else {
            NSLog(@"Error fetching requesting user for info request");
        }
    }];
    
    [self.infoRequest.associatedPost fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self.requestButtonLabel setTitle:self.infoRequest.associatedPost.title forState:UIControlStateNormal];
        } else {
            NSLog(@"Error fetching associated post for info request");
        }
    }];
}

#pragma mark - Actions

- (IBAction)didPressApprove:(id)sender {
    // Add follow-up for requesting user then remove info request
    [FollowUp createNewFollowUpForUser:self.infoRequest.requestingUser fromPost:self.infoRequest.associatedPost aboutUser:self.infoRequest.requestedUser];
    [self.infoRequest removeInfoRequest];
}

- (IBAction)didPressDeny:(id)sender {
    // Delete this inforequest
    [self.infoRequest removeInfoRequest];
}


@end
