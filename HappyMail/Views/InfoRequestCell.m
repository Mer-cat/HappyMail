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

- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest {
    [infoRequest.requestingUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self.usernameButtonLabel setTitle:infoRequest.requestingUser.username forState:UIControlStateNormal];
        } else {
            NSLog(@"Error fetching requesting user for info request");
        }
    }];
    
    [infoRequest.associatedPost fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self.requestButtonLabel setTitle:infoRequest.associatedPost.title forState:UIControlStateNormal];
        } else {
            NSLog(@"Error fetching associated post for info request");
        }
    }];
}

@end
