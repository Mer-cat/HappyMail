//
//  MapViewController.m
//  HappyMail
//
//  Created by Mercy Bickell on 7/21/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *sentToUsers;
@property (nonatomic, strong) NSMutableArray *placesSentTo;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.user = [User currentUser];
    
    [self initMap];
}

- (void)initMap {
    // Load in list of coordinates from user
    // Populate map with pins for each coordinate
    self.sentToUsers = self.user.sentToUsers;
    for (User *user in self.sentToUsers) {
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
                [self.placesSentTo addObject:user.address];
            } else {
                NSLog(@"Error with fetching user address: %@", error.localizedDescription);
            }
        }];
    }

    for (Address *address in self.placesSentTo) {
        // Drop pin on map for each address.coordinate
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(address.latitude.floatValue, address.longitude.floatValue);
        annotation.coordinate = coordinate;
        annotation.title = @"You sent a card here!";
        [self.mapView addAnnotation:annotation];
    }
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
