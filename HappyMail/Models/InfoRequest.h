//
//  InfoRequest.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoRequest : PFObject<PFSubclassing>

@property (nonatomic, strong) User *requestingUser;
@property (nonatomic, strong) Post *associatedPost;
@property (nonatomic, strong) User *requestedUser;

@end

NS_ASSUME_NONNULL_END
