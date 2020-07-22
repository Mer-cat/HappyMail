//
//  User.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "Address.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@class Post;

@interface User : PFUser<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) NSString *aboutMeText;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) NSArray *sentToUsers;  // Users that this user has sent cards to

// Properties for optional features
/*
 @property (nonatomic, strong) NSMutableArray *thankYous;
 */

// MARK: Methods
+ (User *)user;

- (void)addSentToUser:(User *)user;
- (void)addPostToMyPosts:(Post *)post;

@end

NS_ASSUME_NONNULL_END
