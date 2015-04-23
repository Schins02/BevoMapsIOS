//
//  MapHelper.m
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#define SpanDelta 0.002

#import "MapHelper.h"

@interface MapHelper() <CLLocationManagerDelegate>

@property (strong, nonatomic) CacheLayer *cacheLayer;

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

- (instancetype)initWithView:(MKMapView *)mapView
                  cacheLayer:(CacheLayer *)cacheLayer {
  self = [super init];
  if (self) {
    self.cacheLayer = cacheLayer;
    [self.cacheLayer loadMarkers:mapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapView = mapView;
    self.mapView.showsBuildings = true;
    self.mapView.showsPointsOfInterest = false;
    [self centerTower];
  }
  return self;
}

- (void)centerTower {
  MKCoordinateRegion region;
  region.center.latitude = 30.2861;
  region.center.longitude = -97.739321;
  region.span.latitudeDelta = SpanDelta;
  region.span.longitudeDelta = SpanDelta;
  [self.mapView setRegion:region];
}

- (void)centerUserLocation {
  if (!self.userLocation) {
    return;
  }
  [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate
                           animated:true];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    self.mapView.showsUserLocation = true;
  }
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation {
  self.userLocation = userLocation.location;
  if (self.following) {
    [self centerUserLocation];
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  MKAnnotationView *view =
  [mapView dequeueReusableAnnotationViewWithIdentifier:@"BuildingAnnotation"];
  if (!view) {
    view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                        reuseIdentifier:@"BuildingAnnotation"];
    view.canShowCallout = true;
    view.image = [UIImage imageNamed:@"Building"];
  }
  else {
    view.annotation = annotation;
  }
  return view;
}

@end
