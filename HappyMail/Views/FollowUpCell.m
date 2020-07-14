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

@end

@implementation FollowUpCell

- (void)refreshFollowUp:(UnpackedFollowUp *)followUp {
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

@end