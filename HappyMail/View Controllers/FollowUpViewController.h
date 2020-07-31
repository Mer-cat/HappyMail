//
//  FollowUpViewController.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * View controller for viewing a user's follow-ups
 */
@interface FollowUpViewController : UIViewController

/**
 * Fetch the user's follow-ups from Parse with completion, used mainly for setting
 * the badge icon from outside of this view controller
 *
 * @param completion The block which returns either an NSArray of FollowUps or an error
 */
- (void)fetchFollowUpsWithCompletion:(void (^)(NSArray *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
