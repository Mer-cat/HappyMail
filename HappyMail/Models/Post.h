//
//  Post.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/13/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

// Needed due to compile-time errors
@class User;

@interface Post : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *author;
@property (nonatomic) PostType type;
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

// MARK: Methods
+ (void)createNewPostWithTitle:(NSString * _Nullable)title withBody:(NSString * _Nullable)bodyText withType:(PostType)type withCompletion:(void (^)(Post *, NSError *))completion;

- (void)addRespondee:(User *)user;
- (void)removeRespondee:(User *)user;
+ (NSString *)formatTypeToString:(PostType)postType;

@end

NS_ASSUME_NONNULL_END
