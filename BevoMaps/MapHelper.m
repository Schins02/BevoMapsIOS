//
//  MapHelper.m
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#define SpanDelta 0.004

#import "MapHelper.h"

@interface MapHelper() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation MapHelper

- (void)setFollowing:(BOOL)following {
  if (following) {
    [self centerUserLocation];
  }
  _following = following;
}

- (instancetype)initWithView:(MKMapView *)mapView {
  self = [super init];
  if (self) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    self.mapView = mapView;
    [self centerTower];
  }
  return self;
}

- (void)centerUserLocation {
  if (!self.userLocation) {
    return;
  }
  MKCoordinateRegion region;
  region.center.latitude = self.userLocation.coordinate.latitude;
  region.center.longitude = self.userLocation.coordinate.longitude;
  region.span.latitudeDelta = SpanDelta;
  region.span.longitudeDelta = SpanDelta;
  [self.mapView setRegion:region];
}

- (void)centerTower {
  MKCoordinateRegion region;
  region.center.latitude = 30.2861;
  region.center.longitude = -97.739321;
  region.span.latitudeDelta = SpanDelta;
  region.span.longitudeDelta = SpanDelta;
  [self.mapView setRegion:region];
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation {
  self.userLocation = userLocation.location;
  if (self.following) {
    [self centerUserLocation];
  }
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    self.mapView.showsUserLocation = true;
  }
}

@end
