//
//  User.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "Address.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) NSString *aboutMeText;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *myPosts;

// Properties for optional features
/*
@property (nonatomic, strong) NSMutableArray *thankYous;
 */

// MARK: Methods
+ (User *)user;

// TODO: Put any methods for changing properties that should go here

@end

NS_ASSUME_NONNULL_END
