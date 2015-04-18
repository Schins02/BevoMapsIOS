//
//  SearchLayer.m
//  BevoMaps
//
//  Created by Trent Kan on 3/23/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "SearchLayer.h"

#define BUILDING_KEY 0
#define FLOOR_KEY 1

@implementation SearchLayer


+ (NSDictionary *)parseInputText:(NSString *)input
{
    //  assert (![input isEqualToString:@""]);
    //  assert (input != nil);
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    @try
    {
        NSArray *searchResults = [input componentsSeparatedByString:@" "];
        //    assert (searchResults.count == 2);

        // Add building
        NSString *building = [SearchLayer parseBuilding:searchResults];
        if (!building)
        {
            NSLog(@"Building not found");
        }
        [result setObject:building forKey:[SearchLayer getKey:BUILDING_KEY]];
        
        // Add floor
        NSString *floor = [NSString stringWithFormat:@"%c", [[SearchLayer parseFloorAndRoom:searchResults] characterAtIndex:0]];
        if ([floor isEqualToString:@""])
        {
            floor = @"1";
        }
        [result setObject:floor forKey:[SearchLayer getKey:FLOOR_KEY]];
    }
    @catch (NSException *e)
    {
        NSLog(@"Bad search term.");
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}

/******************/
/******************/
/* HELPER METHODS */
/******************/
/******************/

+(NSString *)parseBuilding:(NSArray *)searchResults
{
    // Find result with 3 letters
    for (NSObject *o in searchResults)
    {
        if ([SearchLayer isValidBuilding:(NSString *)o])
        {
            return [(NSString *)o uppercaseString];
        }
    }
    return nil;
}

+(BOOL)isValidBuilding:(NSString *) s
{
    return ([s length] == 3);
}

+(NSString *)parseFloorAndRoom:(NSArray *)searchResults
{
    for (NSObject *o in searchResults)
    {
        if ([SearchLayer containsNumber:(NSString *)o])
        {
            return (NSString *)o;
        }
    }
    return @"";
}

+(BOOL)containsNumber:(NSString *)s
{
    NSArray *numbers = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    for (int i = 0; i < s.length; ++i)
    {
        NSLog(@"looking at character: %c", [s characterAtIndex:i]);
        for (int n = 0; n < numbers.count; ++n)
        {
            NSLog(@"before error");
            NSLog(@"looking at number: %@", numbers[n]);
            if ([[NSString stringWithFormat:@"%@", numbers[n]] isEqualToString:[NSString stringWithFormat:@"%c",[s characterAtIndex:i]]])
            {
                NSLog(@"Contains number!!!");
                return true;
            }
        }
    }
    return false;
}

// Returns the key given an index or an empty string if the index is out of bounds
+ (NSString *)getKey:(NSInteger)forIndex
{
    NSArray *keys = @[@"building", @"floor"];
    if (forIndex > keys.count - 1)
    {
        NSLog(@"Index requested out of range.");
        return @"";
    }
    return keys[forIndex];
}

@end
