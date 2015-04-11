//
//  ImageTasks.m
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "CacheLayer.h"
#import "ImageTasks.h"

@implementation ImageTasks

+ (void)downloadImage:(UIImageView *)view
                 info:(NSDictionary *)map
                floor:(NSString *)floor
                cache:(NSURL *)path {
  UIImageView *__weak imageView = view;

  NSURL *imageUrl = [NSURL URLWithString:[map objectForKey:floor]];
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  NSURLSessionDataTask *task = [session dataTaskWithURL:imageUrl
                                          completionHandler:^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError *error) {
    if (!error) {
      NSURL *fileUrl = [path URLByAppendingPathComponent:[imageUrl lastPathComponent]];
      [data writeToURL:fileUrl atomically:true];

      UIImage *image = [UIImage imageWithData:data];
      dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = image;
      });
    }
  }];

  [task resume];
}

+ (void)loadImage:(UIImageView *)view
              path:(NSURL *)url {
  UIImageView *__weak imageView = view;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = [UIImage imageNamed:[url path]];
    dispatch_async(dispatch_get_main_queue(), ^{
      imageView.image = image;
    });
  });
}

@end