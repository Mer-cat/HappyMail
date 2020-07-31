//
//  PostDetailsViewController.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostDetailsViewControllerDelegate;

/**
 * View controller for viewing a single post in more detail
 */
@interface PostDetailsViewController : UIViewController

// MARK: Properties
@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) id<PostDetailsViewControllerDelegate> delegate;

@end

@protocol PostDetailsViewControllerDelegate

/**
 * Delegate method, activated upon a user responding to a post
 */
- (void)didRespond;

@end

NS_ASSUME_NONNULL_END
