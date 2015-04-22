//
//  CacheLayer.h
//  BevoMaps
//
//  Created by Eric Nguyen on 3/29/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class BuildingVC;

@interface CacheLayer : NSObject

- (NSString *)loadImage:(BuildingVC *)view
         building:(NSString *)building
            floor:(NSString *)floor;
- (void)loadMarkers:(MKMapView *)mapView;
- (NSDictionary *)loadSearchMap;

- (NSArray *)floorNames:(NSString *)building;
- (BOOL)isBuilding:(NSString *)building;

@end
