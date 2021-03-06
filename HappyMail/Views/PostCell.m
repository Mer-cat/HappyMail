//
//  PostCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"
#import "Utils.h"
#import <ChameleonFramework/Chameleon.h>
@import Parse;

@interface PostCell ()

@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsesLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation PostCell

#pragma mark - Cell lifecycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Prevents cells from incorrectly hiding the response count
    self.responsesLabel.hidden = NO;
}

#pragma mark - Init

- (void)refreshPost:(Post *)post {
    // Stylize certain elements
    [Utils roundCorners:self.usernameButton];
    [Utils roundCorners:self.containerView];
    [Utils createBorder:self.containerView color:FlatWhiteDark];
    
    // Set labels
    self.postTypeLabel.text = [Post formatTypeToString:post.type];
    self.titleLabel.text = post.title;
    [self.usernameButton setTitle:post.author.username forState:UIControlStateNormal];
    self.usernameLabel.text = post.author.username;
    
    NSDate *timeCreated = post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
    
    // Set and stylize profile image
    UIImage *placeholderImage = [UIImage imageNamed:@"blank-profile-picture"];
    [self.profileImage setImage: placeholderImage];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.file = post.author.profileImage;
    [self.profileImage loadInBackground];
    [Utils createBorder:self.profileImage color:FlatBlack];
    
    // Show responses label only for offers
    if (post.type == Offer) {
        self.responsesLabel.text = [NSString stringWithFormat:@"%ld/%ld responses",post.respondees.count, post.responseLimit];
    } else {
        self.responsesLabel.hidden = YES;
    }
}

@end
