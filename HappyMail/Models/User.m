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
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post added to %@'s follow-ups successfully", self.username);
        } else {
            NSLog(@"Error adding post to %@'s follow-ups: %@", self.username, error.localizedDescription);
        }
    }];
}

- (void)removeFollowUp:(Post *)post {
    [self removeObject:post forKey:@"followUps"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post removed from %@'s follow-ups successfully", self.username);
        } else {
            NSLog(@"Error removing post from %@'s follow-ups: %@", self.username, error.localizedDescription);
        }
    }];
}

@end
