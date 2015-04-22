//
//  MapHelper.h
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"

#import <MapKit/MapKit.h>

@interface MapHelper : NSObject <MKMapViewDelegate>

@property (nonatomic) BOOL following;

- (instancetype)initWithView:(MKMapView *)mapView
                  cacheLayer:(CacheLayer *)cacheLayer;

@end
