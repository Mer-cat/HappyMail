//
//  FollowUp.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "FollowUp.h"

@implementation FollowUp

@dynamic receivingUser;
@dynamic sendingUser;
@dynamic originalPost;

+ (nonnull NSString *)parseClassName {
    return @"FollowUp";
}

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
