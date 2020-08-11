//
//  PaddedLabel.m
//  HappyMail
//
//  Created by Mercy Bickell on 8/6/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PaddedLabel.h"

@interface PaddedLabel ()

@property (nonatomic) UIEdgeInsets textInsets;

@end

@implementation PaddedLabel

- (void)setTextInsets {
    _textInsets = UIEdgeInsetsMake(2, 6, 2, 6);
    [self invalidateIntrinsicContentSize];
}

/**
 * Calculate the proper textRect by subtracting the insets, then calculating the original label bounds
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.textInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.width += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

/**
 * Add insets to the label
 */
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end
