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
@dynamic authorUsername;

#pragma mark - PFSubclassing

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

#pragma mark - Post creation

+ (void)createNewPostWithTitle:(NSString * _Nullable)title withBody:(NSString * _Nullable)bodyText withType:(PostType)type withCompletion:(void (^)(Post *, NSError *))completion {
    
    Post *newPost = [Post new];
    User *user = [User currentUser];
    newPost.author = user;
    newPost.title = title;
    newPost.bodyText = bodyText;
    newPost.type = type;
    newPost.respondees = [[NSMutableArray alloc] init];
    newPost.authorUsername = user.username;
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            completion(newPost, nil);
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - Respondee field methods

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

#pragma mark - Comparison

/**
 * Comparison method which allows for sorting of posts from newest to oldest
 */
- (NSComparisonResult)compare:(Post *)otherPost {
    return [otherPost.createdAt compare:self.createdAt];
}

#pragma mark - Formatting

+ (NSString *)formatTypeToString:(PostType)postType {
    NSString *result = nil;
    
    switch(postType) {
        case Offer:
            result = @"Offer";
            break;
        case Request:
            result = @"Request";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PostType"];
    }
    
    return result;
}

@end
