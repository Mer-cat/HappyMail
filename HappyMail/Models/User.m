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
@dynamic sentToUsers;
@dynamic entityName;
@dynamic entityId;
@dynamic entityMetadata;

#pragma mark - PFUser

+ (User*)user {
    return (User*)[PFUser user];
}

- (NSString *)entityName {
    return self.username;
}

#pragma mark - Array field changers

- (void)addSentToUser:(User *)user {
    [self addObject:user forKey:@"sentToUsers"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"%@ added to sent users", user.username);
        } else {
            NSLog(@"Error adding user to sent users: %@", error.localizedDescription);
        }
    }];
}

@end
