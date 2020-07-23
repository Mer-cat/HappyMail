//
//  FollowUpCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpCell.h"
#import "Utils.h"

/**
 * Custom UITableViewCell to show a FollowUp object
 */
@interface FollowUpCell ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (nonatomic, strong) FollowUp *followUp;
@property (weak, nonatomic) IBOutlet UIButton *incompleteButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation FollowUpCell

#pragma mark - Init

- (void)refreshFollowUp:(FollowUp *)followUp {
    [self hideButtons];
    
    self.followUp = followUp;
    [self.usernameButton setTitle:followUp.recipientUsername forState:UIControlStateNormal];
    NSString *postType = [Post formatTypeToString:followUp.originalPostType];
    self.postTypeLabel.text = [NSString stringWithFormat:@"%@:", postType];
    self.postTitleLabel.text = followUp.originalPostTitle;
    
    self.fullAddressLabel.text = followUp.recipientAddressString;
}

#pragma mark - Actions

- (IBAction)didPressCheck:(id)sender {
    [self removeFollowUp];
    [Utils queryUser:self.followUp.receivingUser withCompletion:^(User *user, NSError *error) {
        if (user) {
            [self.followUp.sendingUser addSentToUser:self.followUp.receivingUser];
        } else {
            NSLog(@"Error querying user: %@", error.localizedDescription);
        }
    }];
    // TODO: Could notify receiving user that a card is on the way
    // Could repurpose follow-ups screen to updates and add new type
}

- (IBAction)didPressX:(id)sender {
    [self removeFollowUp];
    // TODO: Could notify user that offerer/request responder is no longer going to send a card
}

#pragma mark - Helpers

- (void)removeFollowUp {
    switch (self.followUp.originalPost.type) {
        case Offer:
            [self.followUp.originalPost removeRespondee:self.followUp.receivingUser];
            [self.followUp removeFollowUp];
            break;
        case Request:
            [self.followUp.originalPost removeRespondee:self.followUp.sendingUser];
            [self.followUp removeFollowUp];
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
            break;
    }
    [self.delegate didChangeFollowUp:self.followUp];
}

- (void)showButtons {
    self.incompleteButton.hidden = NO;
    self.completeButton.hidden = NO;
}

- (void)hideButtons {
    self.incompleteButton.hidden = YES;
    self.completeButton.hidden = YES;
}


@end
