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

@class Post;
@class User;

@interface InfoRequest : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *requestingUser;
@property (nonatomic, strong) Post *associatedPost;
@property (nonatomic, strong) User *requestedUser;
@property (nonatomic, strong) NSString *requestingUserUsername;
@property (nonatomic, strong) NSString *associatedPostTitle;

// MARK: Methods
+ (void)createNewInfoRequestToUser:(User *)requestedUser fromUser:(User *)requestingUser fromPost:(Post *) post;
- (void)removeInfoRequest;

@end

NS_ASSUME_NONNULL_END
