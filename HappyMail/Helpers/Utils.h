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
 * Create new alert on the screen with specified message and title
 */
+ (void)showAlertWithMessage:(NSString *) message title:(NSString *)title controller:(id)controller;


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

/**
 * Resizes images since Parse only allows 10MB uploads for a photo
 */
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

/**
 * Queries parse for the user object, populated with address key
 */
+ (void)queryUser:(User *)user withCompletion:(void (^)(User *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
