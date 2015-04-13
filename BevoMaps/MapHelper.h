//
//  MapHelper.h
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapHelper : NSObject <MKMapViewDelegate>

@property (nonatomic) BOOL following;

- (instancetype)initWithView:(MKMapView *)mapView;

@end
