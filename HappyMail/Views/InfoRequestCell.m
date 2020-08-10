//
//  InfoRequestCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequestCell.h"
#import "FollowUp.h"
#import "Utils.h"
#import "PaddedLabel.h"

@interface InfoRequestCell ()

@property (weak, nonatomic) IBOutlet UIButton *usernameButtonLabel;
@property (nonatomic, strong) InfoRequest *infoRequest;
@property (weak, nonatomic) IBOutlet PaddedLabel *requestTitleLabel;

@end

@implementation InfoRequestCell

#pragma mark - Cell lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *titleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOriginalPost)];
    [self.requestTitleLabel addGestureRecognizer:titleTapGesture];
}

#pragma mark - Init

- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest {
    self.infoRequest = infoRequest;
    
    [Utils roundCorners:self.usernameButtonLabel];
    [Utils roundCorners:self.requestTitleLabel];
    
    [self.usernameButtonLabel setTitle:self.infoRequest.requestingUser.username forState:UIControlStateNormal];
    self.requestTitleLabel.text = self.infoRequest.associatedPost.title;
    
    [self.requestTitleLabel setTextInsets];
}

#pragma mark - Approve/deny Actions

- (void)markAsApproved {
    // Add follow-up for requesting user then remove info request
    [FollowUp createNewFollowUpForUser:self.infoRequest.requestingUser fromPost:self.infoRequest.associatedPost aboutUser:self.infoRequest.requestedUser];
    [self.infoRequest removeInfoRequest];
    [self.delegate didChangeInfoRequest:self.infoRequest];
}

- (void)markAsDenied {
    // Delete this inforequest
    [self.infoRequest removeInfoRequest];
    [self.delegate didChangeInfoRequest:self.infoRequest];
}

#pragma mark - Gesture recognizer actions

- (void)goToOriginalPost {
    [self.delegate showRequestDetailView:self];
}

@end
