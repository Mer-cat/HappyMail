//
//  Address.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Address.h"
#import "Utils.h"

@implementation Address

@dynamic streetAddress;
@dynamic city;
@dynamic state;
@dynamic zipcode;
@dynamic addressee;
@dynamic latitude;
@dynamic longitude;

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
    
    // Grab the coordinate for the address
    NSString *cityStateZipcode = [NSString stringWithFormat:@"%@, %@ %@", newAddress.city, newAddress.state, newAddress.zipcode];
    NSString *fullAddress = [NSString stringWithFormat:@"%@ %@", newAddress.streetAddress, cityStateZipcode];
    
    [newAddress assignCoordinateFromAddress:fullAddress withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [newAddress saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    completion(newAddress, nil);
                } else {
                    completion(nil, error);
                }
            }];
        } else {
            NSLog(@"Error assigning coordinate from address: %@", error.localizedDescription);
        }
    }];
}

- (void)assignCoordinateFromAddress:(NSString *)address withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks) {
            CLPlacemark *place = placemarks[0];
            CLLocation *location = place.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            self.latitude = [NSNumber numberWithDouble:coordinate.latitude];
            self.longitude = [NSNumber numberWithDouble:coordinate.longitude];
            NSLog(@"Successfully grabbed coordinate from address");
            completion(YES, nil);
        } else {
            NSLog(@"Error getting coordinates: %@", error.localizedDescription);
            completion(NO, error);
        }
    }];
}

@end
