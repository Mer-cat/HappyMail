//
//  ProfileHeaderCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/28/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileHeaderCellDelegate;

@interface ProfileHeaderCell : UITableViewCell
@property (nonatomic, weak) id<ProfileHeaderCellDelegate> delegate;

- (void)loadCell:(User *)user;

@end

@protocol ProfileHeaderCellDelegate
- (void) initUIImagePickerController;

@end

NS_ASSUME_NONNULL_END
