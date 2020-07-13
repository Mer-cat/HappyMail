//
//  InfoRequest.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "InfoRequest.h"

@implementation InfoRequest

@dynamic requestingUser;
@dynamic associatedPost;
@dynamic requestedUser;

+ (nonnull NSString *)parseClassName {
    return @"InfoRequest";
}

@end
