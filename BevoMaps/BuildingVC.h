//
//  ViewController.h
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"

#import <UIKit/UIKit.h>

@interface BuildingVC : UIViewController

@property (strong, nonatomic) CacheLayer *cacheLayer;
@property (strong, nonatomic) NSString *building, *floor;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSString *searchText;

@end

