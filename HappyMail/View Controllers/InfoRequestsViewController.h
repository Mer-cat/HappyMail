//
//  InfoRequestsViewController.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * View controller for viewing a user's InfoRequests
 */
@interface InfoRequestsViewController : UIViewController

/**
 * Fetch the info request with completion
 * Mainly to enable showing badge for number of info requests
 */
- (void)fetchInfoRequestsWithCompletion:(void (^)(NSArray *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
