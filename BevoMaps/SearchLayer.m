//
//  SearchLayer.m
//  BevoMaps
//
//  Created by Trent Kan on 3/23/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "SearchLayer.h"

@implementation SearchLayer

+(NSDictionary *)parseInputText_TestOnly
{
    // NSDictionary cannot have nil, must be an NSNull object
    return @{@"building" : @"GDC", @"floor" : [NSNull null]};
}

// NSString *input = @"GDC floor 1";
// NSString *input = @"GDC first floor";

+(NSDictionary *)parseInputText:(NSString *)input
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    return result;
}

@end
