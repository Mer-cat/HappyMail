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
@dynamic followUps;
@dynamic address;
@dynamic infoRequests;

/**
 * Override PFUser init method
 */
+ (User*)user {
    return (User*)[PFUser user];
}

- (void)addFollowUp:(Post *)post {
    [self addObject:post forKey:@"followUps"];
    [self saveInBackground];
}

@end
