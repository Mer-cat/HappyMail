//
//  InfoRequest.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequest.h"
#import "PFObject+Subclass.h"

/**
 * Data model for an info request, which represents a request for information from one user to another
 */
@implementation InfoRequest

@dynamic requestingUser;
@dynamic associatedPost;
@dynamic requestedUser;
@dynamic requestingUserUsername;
@dynamic associatedPostTitle;

#pragma mark - PFSubclassing

+ (nonnull NSString *)parseClassName {
    return @"InfoRequest";
}

#pragma mark - Creation and deletion

+ (void)createNewInfoRequestToUser:(User *)requestedUser fromUser:(User *)requestingUser fromPost:(Post *) post {
    InfoRequest *newInfoRequest = [InfoRequest new];
    newInfoRequest.requestedUser = requestedUser;
    newInfoRequest.requestingUser = requestingUser;
    newInfoRequest.associatedPost = post;
    newInfoRequest.requestingUserUsername = requestingUser.username;
    newInfoRequest.associatedPostTitle = post.title;
    
    [newInfoRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully created new info request");
        } else {
            NSLog(@"Error adding new info request: %@", error.localizedDescription);
        }
    }];
}

- (void)removeInfoRequest {
    [self deleteInBackground];
}

@end
