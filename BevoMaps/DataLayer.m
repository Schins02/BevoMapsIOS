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

+ (NSMutableDictionary *) getBuildingMap {
    
    NSMutableDictionary *buildingMap = [NSMutableDictionary new];
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingJSON = [query getFirstObject];
    
    
    if(buildingJSON != nil){
        buildingMap = [buildingJSON objectForKey:@"Buildings"];
        for(id key in buildingMap) {
            id value = [buildingMap objectForKey:key];
            NSLog(@"Key: %@ Value: %@", key, value); //FOR DEBUGGING REMOVE LATER
        }
        
    }
    else{
        NSLog(@"Parse Query Failed");
        return  nil;
    }
    
    return buildingMap;
}

+ (NSArray *) getMarkerArray {
    
    NSArray *markers = [NSArray new];
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingJSON = [query getFirstObject];
    
    if(buildingJSON != nil){
        markers = [buildingJSON objectForKey:@"Markers"];
        for(NSDictionary *dict in markers){
            for(id key in dict) {
                id value = [dict objectForKey:key];
                NSLog(@"Key: %@ Value: %@", key, value); //FOR DEBUGGING REMOVE LATER
            }
            
        }
    }
    else{
        NSLog(@"Parse Query Failed");
        return nil;
    }
    
    return markers;
}

+ (NSMutableDictionary *) getSearchMap{
    return nil;
}

@end