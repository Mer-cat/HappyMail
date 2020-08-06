//
//  FollowUpCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowUp.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FollowUpCellDelegate;

/**
 * Custom UITableViewCell to show a FollowUp object
 */
@interface FollowUpCell : UITableViewCell

// MARK: Properties
@property (nonatomic, weak) id<FollowUpCellDelegate> delegate;

// MARK: Methods

/**
 * Populates the FollowUpCell with information
 *
 * @param followUp The FollowUp object whose information will be used to populate the cell
 */
- (void)refreshFollowUp:(FollowUp *)followUp;

/**
 * Removes the follow-up and updates the user's map
 */
- (void)markAsComplete;

/**
 * Removes the follow-up
 */
- (void)markAsIncomplete;

/**
 * Shows the buttons for marking a FollowUp as complete/incomplete
 */
- (void)showButtons;

/**
 * Hides the buttons for marking a FollowUp as complete/incomplete
 */
- (void)hideButtons;

@end

@protocol FollowUpCellDelegate

/**
 * The method for the delegate to implement, activated upon a FollowUp being marked as complete/incomplete
 *
 * @param followUp The FollowUp that was changed
 */
- (void)didChangeFollowUp:(FollowUp *)followUp;

/**
 * Delegate method which activates upon post title label being long-pressed
 */
- (void)showPostDetailView;

@end

NS_ASSUME_NONNULL_END
