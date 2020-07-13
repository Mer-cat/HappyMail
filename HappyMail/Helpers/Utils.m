//
//  Utils.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils

#pragma mark - UIAlertController helper

/**
 * Create new alert on the screen with specified message and title
 */
+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title controller:(id)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // Dismiss the view.
    }];
    // Add the OK action to the alert controller
    [alert addAction:okAction];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
}

@end
