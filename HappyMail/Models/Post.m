//
//  Post.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Post.h"
#import "PFObject+Subclass.h"

@implementation Post
    
@dynamic author;
@dynamic type;
@dynamic title;
@dynamic bodyText;
@dynamic respondees;


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)createNewPostWithTitle:(NSString * _Nullable)title withBody:(NSString * _Nullable)bodyText withType:(NSInteger)type withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    User *user = [User currentUser];
    newPost.author = user;
    newPost.title = title;
    newPost.bodyText = bodyText;
    newPost.type = type;
    newPost.respondees = [[NSMutableArray alloc] init];
    
    // Add this post to the author's follow-ups
    [user addFollowUp:newPost];    
    [newPost saveInBackgroundWithBlock:completion];
}

- (void)addRespondee:(User *)user {
    [self addObject:user forKey:@"respondees"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"%@ added to respondees for this post", user.username);
        } else {
            NSLog(@"Error adding user to respondees: %@", error.localizedDescription);
        }
    }];
}

- (void)removeRespondee:(User *)user {
    [self removeObject:user forKey:@"respondees"];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"%@ removed from respondees for this post", user.username);
        } else {
            NSLog(@"Error removing user from respondees: %@", error.localizedDescription);
        }
    }];
}

@end
