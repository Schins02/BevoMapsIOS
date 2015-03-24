//
//  BuildingData.h
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingData : NSObject

+ (NSMutableDictionary *) getBuildingMap;
+ (NSArray *) getMarkerList;
+ (NSMutableDictionary *) getSearchMap;

@end
