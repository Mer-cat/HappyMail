//
//  UserExternalData.h
//  HappyMail
//
//  Created by Mercy Bickell on 8/5/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserExternalData : PFObject <PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *username;  // Allows for better tracking in Parse
@property (nonatomic, strong) NSMutableArray *thankYous;

// MARK: Methods

/**
 * Creates a new UserExternalData object
 * @param user User whose external data is represented by this object
 */
+ (void)createUserExternalData:(User *)user;

/**
 * Adds a thank you post to this object's thankYous array
 * @param post The thank you to be added
 */
- (void)addThankYou:(Post *)post;

@end

NS_ASSUME_NONNULL_END
