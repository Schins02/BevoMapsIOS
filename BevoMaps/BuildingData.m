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
    
    NSMutableDictionary *json = [NSMutableDictionary new];
    PFQuery *query = [BuildingJSON query];
    [query whereKey:@"pk" equalTo:@"jsonObj"];
    PFObject *buildingData = [query getFirstObject];
    
    
    if(buildingData != nil){
        json = [buildingData objectForKey:@"Buildings"];
        for(id key in json) {  //FOR DEBUGGING REMOVE LATER
            id value = [json objectForKey:key];
            NSLog(@"Key: %@ Value: %@", key, value);
        }
        
    }
    else
        NSLog(@"Parse Query Failed");
    
    return json;
}

+ (NSArray *) getMarkerList {
    return nil;
}

+ (NSMutableDictionary *) getSearchMap{
    return nil;
}

@end
