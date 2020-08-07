//
//  PaddedLabel.h
//  HappyMail
//
//  Created by Mercy Bickell on 8/6/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Subclass of UILabel to provide padding for labels that have a visible background color
 */
@interface PaddedLabel : UILabel

/**
 * Set the text properly within the bounds of the label with proper insets
 */
- (void)setTextInsets;

@end

NS_ASSUME_NONNULL_END
