//
//  UserExternalData.m
//  HappyMail
//
//  Created by Mercy Bickell on 8/5/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "UserExternalData.h"

@implementation UserExternalData

@dynamic user;
@dynamic username;
@dynamic thankYous;

+ (nonnull NSString *)parseClassName {
    return @"UserExternalData";
}

+ (void)createUserExternalData:(User *)user {
    UserExternalData *newExternalData = [UserExternalData new];
    newExternalData.user = user;
    newExternalData.username = user.username;
    newExternalData.thankYous = [[NSMutableArray alloc] init];
    
    [newExternalData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully created external data for user: %@", user.username);
        } else {
            NSLog(@"Error creating external data: %@", error.localizedDescription);
        }
    }];
}

- (void)addThankYou:(Post *)post {
    [self addObject:post forKey:@"thankYous"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully added thank you");
        } else {
            NSLog(@"Error adding thank you");
        }
    }];
}

@end
