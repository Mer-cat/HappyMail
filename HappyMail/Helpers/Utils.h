//
//  Utils.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Class of helper/utility methods
 */
@interface Utils : NSObject

+ (void)showAlertWithMessage:(NSString *) message title:(NSString *)title controller:(id)controller;

@end

NS_ASSUME_NONNULL_END
