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

/**
 * Creates a new address object
 * @param streetAddress The street address
 * @param city The city
 * @param state The state
 * @param zipcode The zipcode/postal code
 * @param addressee The name associated with the address
 * @param completion The block which returns the new address object or an error
 */
+ (void)createNewAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode addressee:(NSString *)addressee withCompletion:(void (^)(Address *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
