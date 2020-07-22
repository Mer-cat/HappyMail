//
//  FollowUp.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface FollowUp : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *receivingUser;
@property (nonatomic, strong) User *sendingUser;
@property (nonatomic, strong) Post *originalPost;

// MARK: Methods
+ (void)createNewFollowUpForUser:(User *)sendingUser fromPost:(Post *)originalPost aboutUser:(User *)receivingUser;
- (void)removeFollowUp;

@end

NS_ASSUME_NONNULL_END
