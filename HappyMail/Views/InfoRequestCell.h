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

@interface InfoRequestCell : UITableViewCell
@property (nonatomic, strong) InfoRequest *infoRequest;

- (void)refreshInfoRequestCell;

@end

NS_ASSUME_NONNULL_END
