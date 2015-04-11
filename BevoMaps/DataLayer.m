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

+ (NSMutableDictionary *) buildingMap {

    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingJSON = [query getFirstObject];
    
    if(!buildingJSON){
        NSLog(@"Parse Query Failed");
        return nil;
    }
    
    return [buildingJSON objectForKey:@"Buildings"];
}

+ (NSArray *) markerArray {
    
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingJSON = [query getFirstObject];
    
    if(!buildingJSON){
        NSLog(@"Parse Query Failed");
        return nil;
    }
    
    return [buildingJSON objectForKey:@"Markers"];
}

+ (NSMutableDictionary *) searchMap{
    return nil;
}

@end