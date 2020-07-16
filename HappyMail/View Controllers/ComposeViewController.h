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

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

@protocol ComposeViewControllerDelegate
- (void)didPost:(Post *) post;

@end

NS_ASSUME_NONNULL_END
