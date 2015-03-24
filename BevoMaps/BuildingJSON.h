//
//  BuildingJSON.h
//  BevoMaps
//
//  Created by John Schindler on 3/24/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BuildingJSON : PFObject<PFSubclassing>

@property (strong, nonatomic) NSData *json;

+ (NSString *)parseClassName;

@end
