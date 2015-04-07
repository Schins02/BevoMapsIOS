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

#define ParseApplicationID @"7Z6Ys0bNVFV95NuisNLS8gUd7WGLEIR7AM1kWuWR" 
#define ParseClientKey @"yYQdBeF8XSQgvpYZBnwDASbEdrxVXXO946QL4iaZ"

@end
