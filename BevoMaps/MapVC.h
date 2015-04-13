//
//  ViewController.h
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"

#import <UIKit/UIKit.h>

@interface MapVC : UIViewController 
@property (strong, nonatomic) CacheLayer *cacheLayer;

@end

