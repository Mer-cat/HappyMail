//
//  FollowUp.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUp.h"

/**
 * Data model for a follow-up object, which represents action item for user to follow up on
 */
@implementation FollowUp

@dynamic receivingUser;
@dynamic sendingUser;
@dynamic originalPost;

#pragma mark - PFSubclassing

+ (nonnull NSString *)parseClassName {
    return @"FollowUp";
}

#pragma mark - Creation and deletion

+ (void)createNewFollowUpForUser:(User *)sendingUser fromPost:(Post *)originalPost aboutUser:(User *)receivingUser {
    FollowUp *newFollowUp = [FollowUp new];
    
    newFollowUp.sendingUser = sendingUser;
    newFollowUp.originalPost = originalPost;
    newFollowUp.receivingUser = receivingUser;
    
    [newFollowUp saveInBackground];
}

- (void)removeFollowUp {
    [self deleteInBackground];
}

@end
