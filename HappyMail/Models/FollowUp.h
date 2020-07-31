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

/**
 * Data model for a follow-up object, which represents action item for user to follow up on
 */
@interface FollowUp : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *receivingUser;
@property (nonatomic, strong) User *sendingUser;
@property (nonatomic, strong) Post *originalPost;
@property (nonatomic, strong) NSString *recipientAddressString;

// MARK: Methods

/**
 * Creates a new FollowUp object for a user to view in their FollowUps
 * @param sendingUser The user who "owns" the follow-up, i.e. needs to follow up by sending a card
 * @param originalPost The post which led to the creation of the FollowUp
 * @param receivingUser The user whose information will be displayed with the FollowUp
 */
+ (void)createNewFollowUpForUser:(User *)sendingUser fromPost:(Post *)originalPost aboutUser:(User *)receivingUser;

/**
 * Deletes this FollowUp
 */
- (void)removeFollowUp;

@end

NS_ASSUME_NONNULL_END
