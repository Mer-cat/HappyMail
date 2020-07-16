//
//  FollowUpCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpCell.h"

@interface FollowUpCell ()
@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) UnpackedFollowUp *followUp;
@property (weak, nonatomic) IBOutlet UIButton *incompleteButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation FollowUpCell

- (void)refreshFollowUp:(UnpackedFollowUp *)followUp {
    self.followUp = followUp;
    NSString *postType = _PostTypes()[followUp.originalPost.type];
    self.postTypeLabel.text = [NSString stringWithFormat:@"%@:", postType];
    self.postTitleLabel.text = followUp.originalPost.title;
    [followUp.receivingUser fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            self.usernameLabel.text = followUp.receivingUser.username;
            self.addressLabel.text = followUp.receivingUser.address;
        } else {
            NSLog(@"Error fetching receiving user: %@", error.localizedDescription);
        }
    }];
}

- (void)showButtons {
    self.incompleteButton.hidden = NO;
    self.completeButton.hidden = NO;
}

- (void)hideButtons {
    self.incompleteButton.hidden = YES;
    self.completeButton.hidden = YES;
}

- (IBAction)didPressCheck:(id)sender {
    NSLog(@"Pressed check");
    if (self.followUp.originalPost.type == 0) {
        [self.followUp.originalPost removeRespondee:self.followUp.receivingUser];
    } else if (self.followUp.originalPost.type == 1) {  // Request that current user responded to
        [[User currentUser] removeFollowUp:self.followUp.originalPost];
    }
    [self.delegate didChangeFollowUp:self.followUp];
    // TODO: Could notify receiving user that a card is on the way
}

- (IBAction)didPressX:(id)sender {
    NSLog(@"Pressed X");
    // Offer that user made
    if (self.followUp.originalPost.type == 0) {
        [self.followUp.originalPost removeRespondee:self.followUp.receivingUser];
    } else if (self.followUp.originalPost.type == 1) {  // Request that current user responded to
        [[User currentUser] removeFollowUp:self.followUp.originalPost];
    }
    [self.delegate didChangeFollowUp:self.followUp];
    // TODO: Could notify user that offerer/request responder is no longer going to send a card
}

@end
