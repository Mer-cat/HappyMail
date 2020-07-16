//
//  User.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "User.h"
#import "PFObject+Subclass.h"

@implementation User

@dynamic aboutMeText;
@dynamic profileImage;
@dynamic address;

/**
 * Override PFUser init method
 */
+ (User*)user {
    return (User*)[PFUser user];
}

@end
