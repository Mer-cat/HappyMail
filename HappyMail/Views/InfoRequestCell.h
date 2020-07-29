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
- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest;

@end

@protocol InfoRequestCellDelegate

- (void)didChangeInfoRequest:(InfoRequest *)infoRequest;

@end

NS_ASSUME_NONNULL_END
