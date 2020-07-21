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
@property (weak, nonatomic) IBOutlet UILabel *fullAddressLabel;
@property (nonatomic, strong) FollowUp *followUp;
@property (weak, nonatomic) IBOutlet UIButton *incompleteButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;


@end

@implementation FollowUpCell

#pragma mark - Init

- (void)refreshFollowUp:(FollowUp *)followUp {
    self.followUp = followUp;
    [followUp.originalPost fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            NSString *postType = [Post formatTypeToString:followUp.originalPost.type];
            self.postTypeLabel.text = [NSString stringWithFormat:@"%@:", postType];
            self.postTitleLabel.text = followUp.originalPost.title;
        } else {
            NSLog(@"Error fetching associated post: %@", error.localizedDescription);
        }
    }];
    
    User *receivingUser = followUp.receivingUser;
    [receivingUser fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            self.usernameLabel.text = receivingUser.username;
            Address *address = receivingUser.address;
            [address fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (object) {
                    NSString *addressee = address.addressee;
                    NSString *streetAddress = address.streetAddress;
                    NSString *cityStateZipcode = [NSString stringWithFormat:@"%@, %@ %@", address.city, address.state, address.zipcode];
                    NSString *fullAddress = [NSString stringWithFormat:@"%@\n%@\n%@", addressee, streetAddress, cityStateZipcode];

                    self.fullAddressLabel.text = fullAddress;
                    
                } else {
                    NSLog(@"Error fetching user's address: %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"Error fetching receiving user: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Actions

- (IBAction)didPressCheck:(id)sender {
    [self removeFollowUp];
    [self.followUp.sendingUser addSentToUser:self.followUp.receivingUser];
    // TODO: Could notify receiving user that a card is on the way
    // Could repurpose follow-ups screen to updates and add new type
}

- (IBAction)didPressX:(id)sender {
    [self removeFollowUp];
    // TODO: Could notify user that offerer/request responder is no longer going to send a card
}

#pragma mark - Helper

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
