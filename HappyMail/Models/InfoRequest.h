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

/**
 * Data model for an info request, which represents a request for information from one user to another
 */
@interface InfoRequest : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *requestingUser;
@property (nonatomic, strong) Post *associatedPost;
@property (nonatomic, strong) User *requestedUser;

// MARK: Methods

/**
 * Creates a new request for information from one user to another as an InfoRequest object
 *
 * @param requestedUser The user whose information is being requested
 * @param requestingUser The user who is requesting the other user's information
 * @param post The post from which the info-request was created
 */
+ (void)createNewInfoRequestToUser:(User *)requestedUser fromUser:(User *)requestingUser fromPost:(Post *)post;

/**
 * Deletes this info request
 */
- (void)removeInfoRequest;

@end

NS_ASSUME_NONNULL_END
