//
//  CacheLayer.h
//  BevoMaps
//
//  Created by Eric Nguyen on 3/29/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CacheLayer : NSObject

- (void)loadImage:(UIImage *)view building:(NSString *)building floor:(NSString *)floor;

@end
