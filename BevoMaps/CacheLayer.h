//
//  CacheLayer.h
//  BevoMaps
//
//  Created by Eric Nguyen on 3/29/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuildingVC;

@interface CacheLayer : NSObject

- (void)loadImage:(BuildingVC *)view
         building:(NSString *)building
            floor:(NSString *)floor;

@end
