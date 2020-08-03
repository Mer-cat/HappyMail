//
//  Utils.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@implementation Utils

#pragma mark - Refresh control helper

+ (UIRefreshControl *)createRefreshControlInView:(UIView *)view withSelector:(SEL)selector withColor:(UIColor *)color fromController:(UIViewController *)controller {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:color];
    [refreshControl addTarget:controller action:selector forControlEvents:UIControlEventValueChanged];
    [view insertSubview:refreshControl atIndex:0];
    return refreshControl;
}

#pragma mark - UIAlertController helper

+ (void)showAlertWithMessage:(NSString *)message
                       title:(NSString *)title
                  controller:(id)controller
                    okAction:(SEL _Nullable)okSelector
       shouldAddCancelButton:(BOOL)shouldAddCancel
              cancelSelector:(SEL _Nullable)cancelSelector {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (okSelector) {
            // IMP is a pointer to the start of the function that
            // implements the method
            // Need to specify return type to prevent memory leaks
            IMP imp = [controller methodForSelector:okSelector];
            void (*func)(id, SEL) = (void *)imp;
            func(controller, okSelector);
        }
    }];
    
    // Add the OK action to the alert controller
    [alert addAction:okAction];
    
    if (shouldAddCancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
            IMP imp = [controller methodForSelector:cancelSelector];
            void (*func)(id, SEL) = (void *)imp;
            func(controller,cancelSelector);
        }];
        
        [alert addAction:cancelAction];
    }
    
    [controller presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Style helpers

+ (void)roundCorners:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8;
    
    // Add padding around button
    if ([view isKindOfClass:[UIButton class]]){
        UIButton *button = (UIButton *)view;
        button.contentEdgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
    }
}

#pragma mark - Image helpers

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // Check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // Get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Parse query helpers

+ (void)queryUser:(PFUser *)user withCompletion:(void (^)(User *, NSError *))completion {
    PFQuery *userQuery = [PFUser query];
    [userQuery includeKey:@"address"];
    [userQuery getObjectInBackgroundWithId:[user objectId]
                                     block:^(PFObject *populatedUser, NSError *error) {
        if (populatedUser) {
            completion((User*) populatedUser, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
