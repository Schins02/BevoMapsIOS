//
//  CacheLayer.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/29/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"
#import "DataLayer.h"

@interface CacheLayer()

@property (strong, nonatomic) NSDictionary *buildingMap;

@end

@implementation CacheLayer

- (instancetype)init {
  self = [super init];
  [self downloadBuildingMapTask];
  return self;
}

- (void)loadImage:(UIImageView *)view building:(NSString *)building floor:(NSString *)floor {
  NSString *imageUrl = [[self.buildingMap objectForKey:building] objectForKey:floor];
  
}

- (void)downloadBuildingMapTask {
  CacheLayer *__weak this = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSDictionary *map = [DataLayer getBuildingMap];
    if (map != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        this.buildingMap = map;
      });
    }
  });
}

- (void)loadImageTask:(NSString *)name view:(UIImageView *)view {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = [UIImage imageNamed:name];
    dispatch_async(dispatch_get_main_queue(), ^{
      view.image = image;
    });
  });
}

@end