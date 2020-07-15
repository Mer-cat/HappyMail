//
//  User.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

// Needed due to circular dependency causing compile-time errors
@class Post;

@interface User : PFUser<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) NSString *aboutMeText;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) NSMutableArray *followUps;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableArray *infoRequests;

// Properties for optional features
/*
@property (nonatomic, strong) NSMutableArray *thankYous;
 */

// MARK: Methods
+ (User *)user;
- (void)addFollowUp:(Post *)post;
- (void)removeFollowUp:(Post *)post;

@end

NS_ASSUME_NONNULL_END
