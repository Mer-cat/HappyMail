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

/**
 * User object representation, subclassed from Parse User obejct
 */
@interface User : PFUser<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) NSString *aboutMeText;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *sentToUsers;  // Users that this user has sent cards to

// MARK: Methods

/**
 * Override PFUser init method
 * @return Returns a User object
 */
+ (User *)user;

/**
 * Adds a user to this user's list of users they have sent cards to before
 * @param user The user to be added to this user's sentToUsers array
 */
- (void)addSentToUser:(User *)user;

@end

NS_ASSUME_NONNULL_END
