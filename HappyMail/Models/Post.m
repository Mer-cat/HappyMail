//
//  Post.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Post.h"

@implementation Post
    
@dynamic author;
@dynamic type;
@dynamic title;
@dynamic bodyText;
@dynamic respondees;


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) createNewPostWithTitle:(NSString * _Nullable)title withBody:(NSString * _Nullable)bodyText withType:(NSInteger)type withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.title = title;
    newPost.bodyText = bodyText;
    newPost.type = type;
    
    [newPost saveInBackgroundWithBlock: completion];
}

@end
