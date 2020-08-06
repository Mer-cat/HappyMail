//
//  FollowUpCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUpCell.h"
#import "Utils.h"

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

#pragma mark - Cell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *titleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOriginalPost)];
    [self.postTitleLabel addGestureRecognizer:titleTapGesture];
}

#pragma mark - Init

- (void)refreshFollowUp:(FollowUp *)followUp {
    [self hideButtons];
    
    // Round corners of buttons
    [Utils roundCorners:self.usernameButton];
    [Utils roundCorners:self.postTitleLabel];
    [Utils roundCorners:self.incompleteButton];
    [Utils roundCorners:self.completeButton];
    
    self.followUp = followUp;
    [self.usernameButton setTitle:followUp.receivingUser.username forState:UIControlStateNormal];
    NSString *postType = [Post formatTypeToString:followUp.originalPost.type];
    self.postTypeLabel.text = [NSString stringWithFormat:@"%@:", postType];
    self.postTitleLabel.text = followUp.originalPost.title;
    
    self.fullAddressLabel.text = followUp.recipientAddressString;
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

- (void)showButtons {
    self.incompleteButton.hidden = NO;
    self.completeButton.hidden = NO;
}

- (void)hideButtons {
    self.incompleteButton.hidden = YES;
    self.completeButton.hidden = YES;
}


@end
