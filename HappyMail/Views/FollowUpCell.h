//
//  FollowUpCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnpackedFollowUp.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FollowUpCellDelegate;

@interface FollowUpCell : UITableViewCell
@property (nonatomic, weak) id<FollowUpCellDelegate> delegate;

- (void)refreshFollowUp:(UnpackedFollowUp *)followUp;
- (void)showButtons;
- (void)hideButtons;

@end

@protocol FollowUpCellDelegate
- (void) didChangeFollowUp:(UnpackedFollowUp *)followUp;

@end

NS_ASSUME_NONNULL_END
