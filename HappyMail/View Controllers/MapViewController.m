//
//  MapViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Address.h"
#import "Utils.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *sentToUsers;
@property (nonatomic, strong) NSMutableArray *placesSentTo;

@end

@implementation MapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    [Utils queryUser:[User currentUser] withCompletion:^(User *user, NSError *error) {
        if (user) {
            self.user = user;
            [self initMap];
        } else {
            NSLog(@"Error fetching current user: %@",error.localizedDescription);
        }
    }];
}

#pragma mark - Init

- (void)initMap {
    // Load in list of coordinates from user
    // Populate map with pins for each coordinate
    self.sentToUsers = self.user.sentToUsers;
    NSLog(@"%@",self.user.sentToUsers);
    [self initPlacesSentTo];
}

- (void)initPlacesSentTo {
    NSLog(@"%@", self.sentToUsers);
    for (User *user in self.sentToUsers) {
        [Utils queryUser:user withCompletion:^(User *user, NSError *error) {
            if (user) {
                NSLog(@"Found a user");
                NSLog(@"%@", user.address);
                [self.placesSentTo addObject:user.address];
                [self dropPin:user.address];
            } else {
                NSLog(@"Error querying user: %@", error.localizedDescription);
            }
        }];
    }
}

#pragma mark - Helper

- (void)dropPin:(Address *)address {
    // Drop pin on map for each address.coordinate
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(address.latitude.floatValue, address.longitude.floatValue);
    annotation.coordinate = coordinate;
    annotation.title = @"You sent a card here!";
    [self.mapView addAnnotation:annotation];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.pinTintColor = [MKPinAnnotationView purplePinColor];
        annotationView.animatesDrop = YES;
    }
    return annotationView;
}

@end
