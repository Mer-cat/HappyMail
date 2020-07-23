//
//  Address.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Data model representation of an address, which each user has
 */
@interface Address : PFObject<PFSubclassing>

// MARK: Properties
@property (nonatomic, strong) NSString *addressee;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

// MARK: Methods
+ (void)createNewAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode addressee:(NSString *)addressee withCompletion:(void (^)(Address *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
