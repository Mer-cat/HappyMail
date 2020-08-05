//
//  ProfileHeaderCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/28/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserExternalData.h"
#import "ProfileViewController.h"

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
 * @param externalData Data associated with the user that may be updated by other user actions
 */
- (void)loadCell:(User *)user externalData:(UserExternalData * _Nullable)externalData;

/**
 * Make this cell the delegate of the Profile View Controller
 * @param controller The profile view controller that hosts the cell
 */
- (void)makeDelegateOfViewController:(ProfileViewController *)controller;


@end

@protocol ProfileHeaderCellDelegate

/**
 * Implementation should pull up an image picker, activated upon user tapping their own image
 */
- (void)initUIImagePickerController;

- (void)relayout;

@end

NS_ASSUME_NONNULL_END
