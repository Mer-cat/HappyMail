//
//  InfoRequestCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/16/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InfoRequestCellDelegate;

/**
 * Custom UITableViewCell to show an InfoRequest object
 */
@interface InfoRequestCell : UITableViewCell

// MARK: Properties
@property (nonatomic, weak) id<InfoRequestCellDelegate> delegate;

// MARK: Methods

/**
 * Populates the InfoRequestCell with information
 * @param infoRequest The InfoRequest object from which to pull information
 */
- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest;

/**
 * Handles the user marking an info-request as approved
 */
- (void)markAsApproved;

/**
 * Handles the user marking an info-request as denied
 */
- (void)markAsDenied;

@end

@protocol InfoRequestCellDelegate

/**
 *  The delegate method which activates upon an InfoRequest being approved or denied
 *
 *  @param infoRequest The InfoRequest that was changed
 */
- (void)didChangeInfoRequest:(InfoRequest *)infoRequest;

/**
 * Delegate method which activates upon title label being long-pressed
 *
 * @param sender The cell in which the label is tapped
 */
- (void)showRequestDetailView:(id)sender;

@end

NS_ASSUME_NONNULL_END
