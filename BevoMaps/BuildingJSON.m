//
//  BuildingJSON.m
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "BuildingJSON.h"
#import <Parse/PFObject+Subclass.h>

@implementation BuildingJSON

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"BuildingJSON";
}

@dynamic json;

@end
