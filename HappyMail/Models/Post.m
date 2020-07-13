//
//  Post.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Post.h"

@implementation Post
    
@dynamic author;
@dynamic type;
@dynamic title;
@dynamic bodyText;
@dynamic respondees;


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) createNewPost: ( NSString * _Nullable )title withBody: ( NSString * _Nullable )bodyText withType: ( NSString * _Nullable )type withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.title = title;
    newPost.bodyText = bodyText;
    newPost.type = type;
    
    [newPost saveInBackgroundWithBlock: completion];
}

/* Useful method for user object
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
 */

@end
