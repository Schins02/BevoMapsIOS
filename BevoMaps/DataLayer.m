//
//  BuildingData.m
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "DataLayer.h"
#import "BuildingJSON.h"
#import <Parse/PFObject+Subclass.h>

@implementation DataLayer

+ (NSDictionary *)buildingMap {
    PFObject *buildingJSON = [DataLayer getBuildingJSON];
    
    if(!buildingJSON){
        NSLog(@"*** DataLayer ***: Parse query failed.");
        return nil;
    }
    
    return [buildingJSON objectForKey:@"Buildings"];
}

+ (NSArray *)markerArray {
    PFObject *buildingJSON = [DataLayer getBuildingJSON];
    
    if(!buildingJSON){
        NSLog(@"*** DataLayer ***: Parse query failed.");
        return nil;
    }
    
    return [buildingJSON objectForKey:@"Markers"];
}

+ (NSDictionary *)searchMap {
    PFObject *buildingJSON = [DataLayer getBuildingJSON];
    
    if(!buildingJSON){
        NSLog(@"*** DataLayer ***: Parse query failed.");
        return nil;
    }
    
    return [buildingJSON objectForKey:@"SearchMap"];
}

+ (PFObject *)getBuildingJSON {
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    return [query getFirstObject];
}

@end
