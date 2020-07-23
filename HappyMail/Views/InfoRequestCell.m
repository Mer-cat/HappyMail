//
//  InfoRequestCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequestCell.h"
#import "FollowUp.h"

@interface InfoRequestCell ()

@property (weak, nonatomic) IBOutlet UIButton *usernameButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestButtonLabel;
@property (nonatomic, strong) InfoRequest *infoRequest;

@end

@implementation InfoRequestCell

#pragma mark - Init

- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest {
    self.infoRequest = infoRequest;
    
    [self.usernameButtonLabel setTitle:self.infoRequest.requestingUserUsername forState:UIControlStateNormal];
    [self.requestButtonLabel setTitle:self.infoRequest.associatedPostTitle forState:UIControlStateNormal];
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
