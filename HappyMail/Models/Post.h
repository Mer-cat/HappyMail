//
//  Post.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bodyText;
@property (nonatomic, strong) NSMutableArray *respondees;


// Properties used for optional features
/*
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic) NSInteger offerLimit;
@property (nonatomic) BOOL open;
@property (nonatomic, strong) NSString *offerRegion;
 */

+ (void) createNewPost: ( NSString * _Nullable )title withBody: ( NSString * _Nullable )bodyText withType: ( NSString * _Nullable )type withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
