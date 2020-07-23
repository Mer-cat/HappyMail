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
@dynamic recipientAddressString;
@dynamic originalPostType;
@dynamic recipientUsername;
@dynamic originalPostTitle;

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
    
    newFollowUp.originalPostType = originalPost.type;
    newFollowUp.originalPostTitle = originalPost.title;
    
    newFollowUp.recipientUsername = receivingUser.username;
    
    NSString *addressee = receivingUser.address.addressee;
    NSString *streetAddress = receivingUser.address.streetAddress;
    NSString *cityStateZipcode = [NSString stringWithFormat:@"%@, %@ %@", receivingUser.address.city, receivingUser.address.state, receivingUser.address.zipcode];
    NSString *fullAddress = [NSString stringWithFormat:@"%@\n%@\n%@", addressee, streetAddress, cityStateZipcode];
    newFollowUp.recipientAddressString = fullAddress;
    [newFollowUp saveInBackground];
}

- (void)removeFollowUp {
    [self deleteInBackground];
}

@end
