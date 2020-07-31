//
//  Utils.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Class of helper/utility methods
 */
@interface Utils : NSObject


+ (UIRefreshControl *)createRefreshControlInView:(UIView *)view withSelector:(SEL)selector withColor:(UIColor *)color fromController:(UIViewController *)controller;
/**
 * Create new UIAlert on the screen with specified message and title
 *
 * @param message Main message of UIAlert
 * @param title Title of UIAlert
 * @param controller The view controller in which the alert should be displayed
 * @param okSelector the selector to perform upon the ok button press *MUST HAVE VOID RETURN TYPE AND NO PARAMS*
 * @param shouldAddCancel Bool to indicate whether the alert should add a cancel button
 * @param cancelSelector the selector to perform upon the cancel button press (if included) *MUST HAVE VOID RETURN TYPE AND NO PARAMS*
 */
+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title controller:(id)controller okAction:(SEL _Nullable)okSelector shouldAddCancelButton:(BOOL)shouldAddCancel cancelSelector:(SEL _Nullable)cancelSelector;

/**
 * Rounds the corners of the given label
 * @param view  View whose corners are to be rounded
 */
+ (void)roundCorners:(UIView *)view;

+ (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image;

/**
 * Resizes images since Parse only allows 10MB uploads for a photo
 *  @param image The image to be resized
 *  @param size The desired size of the image
 */
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

/**
 * Queries parse for the user object, populated with address key
 * @param user The user whose information should be grabbed via query
 * @param completion The completion block upon query results
 */
+ (void)queryUser:(User *)user withCompletion:(void (^)(User *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
