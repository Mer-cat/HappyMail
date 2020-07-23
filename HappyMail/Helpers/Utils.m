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

#pragma mark - UIAlertController helper

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

+ (void)queryCurrentUserWithCompletion:(void (^)(User *, NSError *))completion {
    PFQuery *userQuery = [PFUser query];
    [userQuery includeKey:@"address"];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId]
                                     block:^(PFObject *populatedUser, NSError *error) {
        if (populatedUser) {
            completion((User*) populatedUser, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
