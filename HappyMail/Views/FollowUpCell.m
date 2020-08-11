//
//  FollowUpCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpCell.h"
#import "Utils.h"
#import "PaddedLabel.h"

@interface FollowUpCell ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet PaddedLabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (nonatomic, strong) FollowUp *followUp;

@end

@implementation FollowUpCell

#pragma mark - Cell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Add tap gesture recognizer to title
    UITapGestureRecognizer *titleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOriginalPost)];
    [self.postTitleLabel addGestureRecognizer:titleTapGesture];
}

#pragma mark - Init

- (void)refreshFollowUp:(FollowUp *)followUp {
    
    // Round corners of buttons and labels that have backgrounds
    [Utils roundCorners:self.usernameButton];
    [Utils roundCorners:self.postTitleLabel];
    
    self.followUp = followUp;
    [self.usernameButton setTitle:followUp.receivingUser.username forState:UIControlStateNormal];
    NSString *postType = [Post formatTypeToString:followUp.originalPost.type];
    self.postTypeLabel.text = [NSString stringWithFormat:@"%@:", postType];
    self.postTitleLabel.text = followUp.originalPost.title;
    self.fullAddressLabel.text = followUp.recipientAddressString;
    
    [self.postTitleLabel setTextInsets];
}

#pragma mark - Marking actions

- (void)markAsComplete {
    [Utils queryUser:self.followUp.receivingUser withCompletion:^(User *user, NSError *error) {
        if (user) {
            [self.followUp.sendingUser addSentToUser:self.followUp.receivingUser];
            [self removeFollowUp];
        } else {
            NSLog(@"Error querying user: %@", error.localizedDescription);
        }
    }];
    // TODO: Could notify receiving user that a card is on the way
    // Could repurpose follow-ups screen to updates and add new type
}

- (void)markAsIncomplete {
    [self removeFollowUp];
    // TODO: Could notify user that offerer/request responder is no longer going to send a card
}

#pragma mark - Gesture recognizer actions

- (void)goToOriginalPost {
    [self.delegate showPostDetailView:self];
}

#pragma mark - Helpers

- (void)removeFollowUp {
    [self.followUp removeFollowUp];
    [self.delegate didChangeFollowUp:self.followUp];
}

@end
