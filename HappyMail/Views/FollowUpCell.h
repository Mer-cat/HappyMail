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
- (void)refreshFollowUp:(FollowUp *)followUp;
- (void)showButtons;
- (void)hideButtons;

@end

@protocol FollowUpCellDelegate
- (void)didChangeFollowUp:(FollowUp *)followUp;

@end

NS_ASSUME_NONNULL_END
