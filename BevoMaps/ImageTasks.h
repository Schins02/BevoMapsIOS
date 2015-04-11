//
//  ImageTasks.h
//  BevoMaps
//
//  Created by Eric Nguyen on 4/11/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTasks : NSObject

+ (void)downloadImage:(UIImageView *)view
                 info:(NSDictionary *)map
                floor:(NSString *)floor
                cache:(NSURL *)path;

+ (void)loadImage:(UIImageView *)view
              path:(NSURL *)url;

@end
