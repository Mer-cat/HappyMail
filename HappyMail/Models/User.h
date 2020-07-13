//
//  User.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *aboutMeText;
@property (nonatomic, strong) PFFileObject *profileImage;
@property (nonatomic, strong) NSMutableArray *followUps;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableArray *infoRequests;

// Properties for optional features
/*
@property (nonatomic, strong) NSMutableArray *thankYous;
 */

@end

NS_ASSUME_NONNULL_END
