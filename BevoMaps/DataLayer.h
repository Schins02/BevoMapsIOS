//
//  BuildingData.h
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLayer : NSObject

#define ParseApplicationID @"7Z6Ys0bNVFV95NuisNLS8gUd7WGLEIR7AM1kWuWR"
#define ParseClientKey @"yYQdBeF8XSQgvpYZBnwDASbEdrxVXXO946QL4iaZ"
#define DefaultFloor @"defaultFloor"
#define FloorNames @"floorNames"
#define Latitude @"latitude"
#define Longitude @"longitude"
#define LongName @"longName"
#define ShortName @"shortName"
#define Thumbnail @"thumbnail"

+ (NSMutableDictionary *) buildingMap;
+ (NSArray *) markerArray;
+ (NSMutableDictionary *) searchMap;

@end