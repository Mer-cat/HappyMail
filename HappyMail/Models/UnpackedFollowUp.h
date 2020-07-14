//
//  UnpackedFollowUp.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnpackedFollowUp : NSObject

@property (nonatomic, strong) User *receivingUser;
@property (nonatomic, strong) Post *originalPost;

@end

NS_ASSUME_NONNULL_END
