//
//  PostCell.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"

@interface PostCell ()

@property (weak, nonatomic) IBOutlet UILabel *offerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *responsesLabel;

@end

@implementation PostCell

#pragma mark - Cell lifecycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Prevents cells from incorrectly hiding the reponse count
    self.responsesLabel.hidden = NO;
}

#pragma mark - Init

- (void)refreshPost:(Post *)post {
    
    // Set labels
    self.offerTypeLabel.text = [Post formatTypeToString:post.type];
    self.titleLabel.text = post.title;
    [self.usernameButton setTitle:post.author.username forState:UIControlStateNormal];
    
    if (post.type == Offer) {
        self.responsesLabel.text = [NSString stringWithFormat:@"%ld/%ld responses",post.respondees.count, post.responseLimit];
    } else {
        self.responsesLabel.hidden = YES;
    }
    
    NSDate *timeCreated = post.createdAt;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@ ago", timeCreated.shortTimeAgoSinceNow];
    
}

@end
