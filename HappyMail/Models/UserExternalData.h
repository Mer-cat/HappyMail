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

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *username;  // Allows for better tracking in Parse
@property (nonatomic, strong) NSMutableArray *thankYous;

+ (void)createUserExternalData:(User *)user;
- (void)addThankYou:(Post *)post;

@end

NS_ASSUME_NONNULL_END
