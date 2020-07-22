//
//  PostCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"

/**
 * Custom UITableViewCell for Posts
 */
@interface PostCell ()
@property (weak, nonatomic) IBOutlet UILabel *offerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation PostCell

#pragma mark - Init

- (void)refreshPost:(Post *)post {
    // Set labels
    [post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            self.offerTypeLabel.text = [Post formatTypeToString:post.type];
            self.titleLabel.text = post.title;
            [post.author fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (object) {
                    [self.usernameButton setTitle:post.author.username forState:UIControlStateNormal];
                } else {
                    NSLog(@"Error fetching user: %@", error.localizedDescription);
                }
            }];
            NSDate *timeCreated = post.createdAt;
            self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
        } else {
            NSLog(@"Error fetching post: %@", error.localizedDescription);
        }
    }];
}

@end
