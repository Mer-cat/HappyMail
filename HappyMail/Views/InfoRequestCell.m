//
//  InfoRequestCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequestCell.h"

@interface InfoRequestCell ()

@property (weak, nonatomic) IBOutlet UIButton *usernameButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestButtonLabel;

@end

@implementation InfoRequestCell

#pragma mark - Init

- (void)refreshInfoRequestCell {
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

// TODO: Need to refactor FollowUp data model before implementing these
- (IBAction)didPressApprove:(id)sender {
    // TODO: Add follow-up for requesting user
}

- (IBAction)didPressDeny:(id)sender {
    // TODO: Delete this inforequest
}


@end
