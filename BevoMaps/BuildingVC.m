//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "BuildingVC.h"
#import "SearchLayer.h"

@interface BuildingVC () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *upGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *downGesture;

@end

@implementation BuildingVC

- (UIImage *)image {
  return self.imageView.image;
}

-(void)setImage:(UIImage *)image {
  self.imageView.image = image;
  self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  [self.imageView sizeToFit];
  self.scrollView.contentSize = image ? image.size : CGSizeZero;
  self.scrollView.zoomScale = .15;
}

- (void)setScrollView:(UIScrollView *)scrollView {
  scrollView.minimumZoomScale = 0.1;
  scrollView.maximumZoomScale = 2.0;
  scrollView.delegate = self;
  scrollView.showsHorizontalScrollIndicator = YES;
  _scrollView = scrollView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.imageView = [[UIImageView alloc] init];
  [self.scrollView addSubview:self.imageView];

  self.upGesture.numberOfTouchesRequired = 2;
  self.upGesture.direction = UISwipeGestureRecognizerDirectionUp;

  self.downGesture.numberOfTouchesRequired = 2;
  self.downGesture.direction = UISwipeGestureRecognizerDirectionUp;
  [self.downGesture requireGestureRecognizerToFail:self.upGesture];

  self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
  [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.downGesture];

  [self.cacheLayer loadImage:self building:self.building floor:self.floor];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

- (IBAction)swipeUpFloor {
  NSLog(@"Change up floor.");
}

- (IBAction)swipeDownFloor {
  NSLog(@"Change down floor.");
}

@end
