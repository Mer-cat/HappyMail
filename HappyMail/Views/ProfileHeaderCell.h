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

// MARK: Properties
@property (nonatomic, weak) id<ProfileHeaderCellDelegate> delegate;

// MARK: Methods
/**
 * Populates the ProfileHeaderCell with information
 *
 * @param user The user whose profile is being viewed
 */
- (void)loadCell:(User *)user;

@end

@protocol ProfileHeaderCellDelegate

/**
 * Implementation should pull up an image picker, activated upon user tapping their own image
 */
- (void) initUIImagePickerController;

@end

NS_ASSUME_NONNULL_END
