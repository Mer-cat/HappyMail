//
//  PaddedLabel.m
//  HappyMail
//
//  Created by Mercy Bickell on 8/6/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PaddedLabel.h"

@implementation PaddedLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets myLabelInsets = UIEdgeInsetsMake(0, 6, 0, 6);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, myLabelInsets)];
}

@end
