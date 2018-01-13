//
//  JETMapViewController.m
//  ParkingSpotter
//
//  Created by Lyudmyla Ivanova on 1/12/18.
//  Copyright © 2018 Lyudmyla Ivanova. All rights reserved.
//

@import MapKit;
@import CoreLocation;
#import "JETMapViewController.h"

@interface JETMapViewController () <CLLocationManagerDelegate, MKAnnotation>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *parkingSpots;

@end

@implementation JETMapViewController

static NSString *const kViewControllerTitle = @"Spots Near You";
static NSString *const kMapAnnotationReuseIdentifier = @"Annotation";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:kViewControllerTitle];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];
    [self.locationManager startUpdatingLocation];
    self.mapView = [[MKMapView alloc]init];
//    [self.mapView registerClass:<#(nullable Class)#> forAnnotationViewWithReuseIdentifier:<#(nonnull NSString *)#>]
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.mapType = MKMapTypeHybrid;
    self.view = self.mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)zoomToCurrentLocation {
    float spanX = 0.005;
    float spanY = 0.005;
    MKCoordinateRegion region =
                    MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude,
                                                                      self.mapView.userLocation.coordinate.longitude),
                                           MKCoordinateSpanMake(spanX, spanY));
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert =
            [UIAlertController alertControllerWithTitle:@"Error"
                                                message:@"Cannot obtain your current location. Please change your Privacy settings to allow this app access your location."
                                         preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestLocation];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations && (locations.count > 0)) {
        CLLocation *currentLocation = [locations objectAtIndex:0];
        CLLocationDegrees latitude = currentLocation.coordinate.latitude;
        CLLocationDegrees longitude = currentLocation.coordinate.longitude;
    }
    [self zoomToCurrentLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView =
                                    [mapView dequeueReusableAnnotationViewWithIdentifier:kMapAnnotationReuseIdentifier];
    return annotationView;
}

@end
