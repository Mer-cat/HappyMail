//
//  ComposeViewController.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate;

/**
 * View controller for creating a new post
 */
@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

@protocol ComposeViewControllerDelegate

/**
 * Delegate method activated upon a new post being made
 * @param post The newly created post
 */
- (void)didPost:(Post *) post;

@end

NS_ASSUME_NONNULL_END
