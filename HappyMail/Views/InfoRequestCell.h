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

/**
* Custom UITableViewCell to show an InfoRequest object
*/
@interface InfoRequestCell : UITableViewCell

- (void)refreshInfoRequestCell:(InfoRequest *)infoRequest;

@end

NS_ASSUME_NONNULL_END
