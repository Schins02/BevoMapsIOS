//
//  CacheLayer.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/29/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"
#import "DataLayer.h"
#import "ImageTasks.h"

@interface CacheLayer()

@property (strong, nonatomic, readonly) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *cachePath;
@property (strong, nonatomic) NSDictionary *buildingMap;

@end

@implementation CacheLayer

- (NSFileManager *)fileManager {
  return [NSFileManager defaultManager];
}

- (NSURL *)cachePath {
  if (!_cachePath) {
    NSURL *cacheParent = [[self.fileManager URLsForDirectory:NSCachesDirectory
                                           inDomains:NSUserDomainMask] lastObject];
    _cachePath = [cacheParent URLByAppendingPathComponent:@"ImagesCache"];

    BOOL directory = true;
    if (![self.fileManager fileExistsAtPath:[_cachePath path] isDirectory:&directory]) {
      NSLog(@"Creating image cache.");
      [self.fileManager createDirectoryAtURL:_cachePath
                 withIntermediateDirectories:false
                                  attributes:nil
                                       error:nil];
    }
  }
  return _cachePath;
}

- (instancetype)init {
  self = [super init];
  [self buildingTask];
  return self;
}

- (void)loadImage:(BuildingVC *)view
         building:(NSString *)building
            floor:(NSString *)floor {
  if ([self.buildingMap objectForKey:floor] == nil) {
    floor = [self.buildingMap objectForKey:DefaultFloor];
  }

  NSDictionary *map = [self.buildingMap objectForKey:building];
  NSString *imageUrl = [map objectForKey:floor];
  NSURL *cacheUrl = [self.cachePath URLByAppendingPathComponent:[imageUrl lastPathComponent]];

  if ([self.fileManager fileExistsAtPath:[cacheUrl path] isDirectory:nil]) {
    NSLog(@"Loading from cache.");
    view.image = [UIImage imageNamed:[cacheUrl path]];
  }
  else {
    NSLog(@"Loading from network.");
    [ImageTasks downloadImage:view info:map floor:floor cache:self.cachePath];
  }
}

- (void)buildingTask {
  CacheLayer *__weak this = self;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSDictionary *map = [DataLayer buildingMap];
    if (map != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        this.buildingMap = map;
      });
    }
  });
}

@end