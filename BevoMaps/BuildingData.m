//
//  BuildingData.m
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "BuildingData.h"
#import "BuildingJSON.h"
#import <Parse/PFObject+Subclass.h>

@implementation BuildingData

+ (NSMutableDictionary *) getBuildingMap {
    
    NSMutableDictionary *buildingMap = [NSMutableDictionary new];
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingJSON = [query getFirstObject];
    
    
    if(buildingJSON != nil){
        buildingMap = [buildingJSON objectForKey:@"Buildings"];
        for(id key in buildingMap) {  //FOR DEBUGGING REMOVE LATER
            id value = [buildingMap objectForKey:key];
            NSLog(@"Key: %@ Value: %@", key, value);
        }
        
    }
    else
        NSLog(@"Parse Query Failed");
    
    return buildingMap;
}

+ (NSArray *) getMarkerList {
    return nil;
}

+ (NSMutableDictionary *) getSearchMap{
    return nil;
}

@end
