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

/**
 * Create a refresh control for the given view controller, which upon pulling will call the given selector
 *
 * @param view The view in which to insert the refresh control
 * @param selector The selector for the refresh control
 * @param color The color of the refresh control
 * @param controller The view controller where the refresh control is implemented
 *
 * @return The UIRefreshControl object created
 */
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
 * Rounds the corners of the given view
 * @param view  View whose corners are to be rounded
 */
+ (void)roundCorners:(UIView *)view;

/**
 * Create a border around the given label
 * @param label The label on which a border is to be drawn
 * @param color The color of the border
 */
+ (void)createBorder:(UILabel *)label color:(UIColor *)color;

+ (PFFileObject *)getPFFileFromImage:(UIImage * _Nullable)image;

/**
 * Resizes images since Parse only allows 10MB uploads for a photo
 *  @param image The image to be resized
 *  @param size The desired size of the image
 *
 *  @return The resized image
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
