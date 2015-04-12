//
//  ImageTasks.m
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "ImageTasks.h"
#import "CacheLayer.h"
#import "DataLayer.h"

@implementation ImageTasks

+ (void)downloadImage:(UIImageView *)view
                 info:(NSDictionary *)map
                floor:(NSString *)floor
                cache:(NSURL *)url {
  [ImageTasks freeCache:[url path]];
  NSURL *imageUrl = [NSURL URLWithString:[map objectForKey:floor]];
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  NSURLSessionDataTask *task = [session dataTaskWithURL:imageUrl
                                          completionHandler:^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError *error) {
    if (!error) {
      NSURL *fileUrl = [url URLByAppendingPathComponent:[imageUrl lastPathComponent]];
      [data writeToURL:fileUrl atomically:true];

      UIImage *image = [UIImage imageWithData:data];
      dispatch_async(dispatch_get_main_queue(), ^{
        view.image = image;

        for (NSString *key in map) {
          if (![key isEqualToString:DefaultFloor] &&
              ![key isEqualToString:FloorNames] &&
              ![key isEqualToString:floor]) {
            [ImageTasks cacheImage:[map objectForKey:key] cache:url];
          }
        }
      });
    }
  }];

  [task resume];
}

+ (void)cacheImage:(NSString *)image cache:(NSURL *)url {
  NSURL *imageUrl = [NSURL URLWithString:image];
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  NSURLSessionDataTask *task = [session dataTaskWithURL:imageUrl
                                      completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError *error) {
    if (!error) {
      NSURL *fileUrl = [url URLByAppendingPathComponent:[imageUrl lastPathComponent]];
      [data writeToURL:fileUrl atomically:true];
    }
  }];

  [task resume];
}

+ (void)freeCache:(NSString *)path {
  NSMutableString *log = [NSMutableString stringWithString:@"Deleted:  "];
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *files = [manager subpathsOfDirectoryAtPath:path error:nil];

  NSUInteger length = 0;
  for (NSString *name in files) {
    NSDictionary *attrs = [manager attributesOfItemAtPath:[path stringByAppendingPathComponent:name]
                                                    error:nil];
    length += [attrs fileSize];
  }

  while (length > CacheLimit) {
    NSDate *oldest = [NSDate date];

    int index = 0;
    for (int i = 0; i < files.count; ++i) {
      NSString *file = [path stringByAppendingPathComponent:files[i]];
      NSDictionary *attrs = [manager attributesOfItemAtPath:file error:nil];
      NSDate *modified = [attrs fileModificationDate];

      if ([[modified earlierDate:oldest] isEqual:modified]) {
        index = i;
        oldest = modified;
      }
    }

    NSString *file = [path stringByAppendingPathComponent:files[index]];
    NSDictionary *attrs = [manager attributesOfItemAtPath:file error:nil];
    [log appendFormat:@"%@, ", files[index]];
    length -= [attrs fileSize];
    [manager removeItemAtPath:file error:nil];
  }

  NSLog(@"%@", [log substringToIndex:log.length - 2]);
}

@end
