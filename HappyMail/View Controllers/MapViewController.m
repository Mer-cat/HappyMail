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
    self.user = [User currentUser];
    
    [self initMap];
}

#pragma mark - Init

- (void)initMap {
    // Load in list of coordinates from user
    // Populate map with pins for each coordinate
    self.sentToUsers = self.user.sentToUsers;
    [self initPlacesSentTo];
}

- (void)initPlacesSentTo {
    for (User *user in self.sentToUsers) {
        NSLog(@"Found a user");
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
                NSLog(@"%@", user.address);
                [self.placesSentTo addObject:user.address];
                [self dropPin:user.address];
            } else {
                NSLog(@"Error with fetching user address: %@", error.localizedDescription);
            }
        }];
    }
}

#pragma mark - Helper

- (void)dropPin:(Address *)address {
    // Drop pin on map for each address.coordinate
    [address fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            NSLog(@"Dropped pin");
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(address.latitude.floatValue, address.longitude.floatValue);
            annotation.coordinate = coordinate;
            annotation.title = @"You sent a card here!";
            [self.mapView addAnnotation:annotation];
        } else {
            NSLog(@"Failed to drop pin: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        //annotationView.canShowCallout = true;
        //annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)]
        annotationView.pinTintColor = [MKPinAnnotationView purplePinColor];
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
