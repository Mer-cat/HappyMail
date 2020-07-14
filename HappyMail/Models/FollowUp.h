//
//  FollowUp.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface FollowUp : PFObject<PFSubclassing>

@property (nonatomic, strong) User *receivingUser;
@property (nonatomic, strong) Post *originalPost;

@end

NS_ASSUME_NONNULL_END
