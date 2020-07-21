//
//  Address.h
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Address : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *addressee;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipcode;


+ (void)createNewAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode addressee:(NSString *)addressee withCompletion:(void (^)(Address *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
