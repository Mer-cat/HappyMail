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

/**
 * Data model for a Post object which interacts with Parse
 */
@interface Post : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) User *author;
@property (nonatomic) PostType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bodyText;
@property (nonatomic, strong) NSMutableArray *respondees;
@property (nonatomic) NSInteger responseLimit;
@property (nonatomic, strong) NSArray *taggedUsers;

// MARK: Methods

/**
 * Create a new post and save it to Parse
 * @param title The title of the post
 * @param bodyText The main body text of the post
 * @param type The post type (e.g. Offer)
 * @param limit The maximum number of respondees allowed, relevant only to offers
 * @param taggedUsers The usernames of users that were tagged if the post is a thank-you
 * @param completion The block which returns either the new post or an error
 */
+ (void)createNewPostWithTitle:(NSString * _Nullable)title withBody:(NSString * _Nullable)bodyText withType:(PostType)type withLimit:(NSInteger)limit withTaggedUsers:(NSArray * _Nullable)taggedUsers withCompletion:(void (^)(Post *, NSError *))completion;
/**
 * Adds a respondee for the given post
 * @param user The respondee to add
 */
- (void)addRespondee:(User *)user;

/**
 * Removes a respondee for a given post
 * @param user The respondee to remove
 */
- (void)removeRespondee:(User *)user;

/**
 * Given a post type, returns the string representation for the post type
 * @param postType The post type (e..g Offer or Request)
 *
 * @return The string representation of the post type
 */
+ (NSString *)formatTypeToString:(PostType)postType;

@end

NS_ASSUME_NONNULL_END
