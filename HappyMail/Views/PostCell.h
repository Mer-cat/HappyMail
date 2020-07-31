//
//  PostCell.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/14/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Custom UITableViewCell for Posts
 */
@interface PostCell : UITableViewCell

/**
 * Sets all the labels and information inside a PostCell
 *
 * @param post The post from which the cell should populate information
 */
- (void)refreshPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
