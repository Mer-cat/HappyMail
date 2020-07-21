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
@dynamic myPosts;
@dynamic sentToUsers;

/**
 * Override PFUser init method
 */
+ (User*)user {
    return (User*)[PFUser user];
}

- (void)addSentToUser:(User *)user {
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [self addObject:user forKey:@"sentToUsers"];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"%@ added to sent users", user.username);
                } else {
                    NSLog(@"Error adding user to sent users: %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"Error adding a new sent-to-user: %@", error.localizedDescription);
        }
    }];
}

@end
