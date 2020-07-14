//
//  PostCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()
@property (weak, nonatomic) IBOutlet UILabel *offerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation PostCell

#pragma mark - Init

- (void)refreshPost:(Post *)post {
    // Set labels
    self.offerTypeLabel.text = _PostTypes()[post.type];
    self.titleLabel.text = post.title;
    self.usernameLabel.text = post.author.username;
    self.timestampLabel.text = @"Filler";
}

@end
