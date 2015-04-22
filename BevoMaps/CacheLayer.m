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

@property (strong, nonatomic) NSDictionary *buildingMap, *searchMap;
@property (strong, nonatomic) NSMutableDictionary *markerMap;

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
      NSLog(@"*** CacheLayer ***: Creating image cache.");
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
  [self searchTask];
  return self;
}

- (NSString *)loadImage:(BuildingVC *)view
               building:(NSString *)building
                  floor:(NSString *)floor {
  NSDictionary *map = [self.buildingMap objectForKey:building];
  if ([map objectForKey:floor] == nil) {
    floor = [map objectForKey:DefaultFloor];
  }

  NSString *imageUrl = [map objectForKey:floor];
  NSURL *cacheUrl = [self.cachePath URLByAppendingPathComponent:[imageUrl lastPathComponent]];

  if ([self.fileManager fileExistsAtPath:[cacheUrl path] isDirectory:nil]) {
    view.image = [UIImage imageNamed:[cacheUrl path]];
  }
  else {
    [ImageTasks downloadImage:view info:map floor:floor cache:self.cachePath];
  }
  return floor;
}

- (void)loadMarkers:(MKMapView *)mapView {
  CacheLayer *__weak this = self;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *list = [DataLayer markerArray];
    if (list != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        for (NSDictionary *info in list) {
          CLLocationDegrees latitude = [[info objectForKey:Latitude] doubleValue];
          CLLocationDegrees longitude = [[info objectForKey:Longitude] doubleValue];
          
          MKPointAnnotation *annotation = [MKPointAnnotation new];
          annotation.title = [info objectForKey:ShortName];
          annotation.subtitle = [info objectForKey:LongName];
          annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
          [mapView addAnnotation:annotation];
          
          [this.markerMap setValue:info forKey:[info objectForKey:ShortName]];
          [this.markerMap setValue:info forKey:[NSString stringWithFormat:@"%f,%f", latitude, longitude]];
        }
      });
    }
  });
}

- (NSDictionary *)loadSearchMap {
  return self.searchMap;
}

- (NSArray *)floorNames:(NSString *)building {
  NSDictionary *map = [self.buildingMap objectForKey:building];
  return [[map objectForKey:FloorNames] componentsSeparatedByString:@" "];
}

- (BOOL)isBuilding:(NSString *)building {
  return [self.buildingMap objectForKey:building] != nil;
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

- (void)searchTask {
  CacheLayer *__weak this = self;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSDictionary *map = [DataLayer searchMap];
    if (map != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        this.searchMap = map;
      });
    }
  });
}

@end
