//
//  Address.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Address.h"

@implementation Address

@dynamic streetAddress;
@dynamic city;
@dynamic state;
@dynamic zipcode;
@dynamic addressee;

+ (nonnull NSString *)parseClassName {
    return @"Address";
}

+ (void)createNewAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipcode:(NSString *)zipcode addressee:(NSString *)addressee withCompletion:(void (^)(Address *, NSError *))completion {
    
    Address *newAddress = [Address new];
    newAddress.streetAddress = streetAddress;
    newAddress.city = city;
    newAddress.state = state;
    newAddress.zipcode = zipcode;
    newAddress.addressee = addressee;
    
    [newAddress saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            completion(newAddress, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
