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

/**
 * View controller for users' profiles
 */
@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;

@end

NS_ASSUME_NONNULL_END
