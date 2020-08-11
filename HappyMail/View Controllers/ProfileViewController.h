//
//  ProfileViewController.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewControllerDelegate;

/**
 * View controller for users' profiles
 */
@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;

@end

@protocol ProfileViewControllerDelegate

/**
 * Delegate method activated upon a profile image being changed
 * @param image The new profile image
 */
- (void)didChangeProfileImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
