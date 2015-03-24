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

// Cases to handle later
// NSString *input = @"GDC floor 1";
// NSString *input = @"GDC first floor";

// Correct input GDC 1.xxx
// Assume correct input
+(NSDictionary *)parseInputText:(NSString *)input
{
    assert (![input isEqualToString:@""]);
    assert (input != nil);
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    @try
    {
        NSArray *searchResults = [input componentsSeparatedByString:@" "];
        assert (searchResults.count == 2);
        // Add building -- need to move to own method to error check
        [result setObject:searchResults[0] forKey:[SearchLayer getKey:0]];
        // Add floor -- need to move to own method to error check
        [result setObject:searchResults[1] forKey:[SearchLayer getKey:1]];
    }
    @catch (NSException *e)
    {
        NSLog(@"Bad search term");
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

/******************/
/******************/
/* HELPER METHODS */
/******************/
/******************/

// Returns the key given an index or an empty string if the index is out of bounds
+(NSString *)getKey:(NSInteger)forIndex
{
    NSArray *keys = @[@"building", @"floor"];
    if (forIndex > keys.count - 1)
    {
        NSLog(@"Index requested out of range");
        return @"";
    }
    return keys[forIndex];
}


@end
