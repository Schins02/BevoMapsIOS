//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "MapVC.h"
#import "MapHelper.h"

#import <MapKit/MapKit.h>

@interface MapVC ()

@property (strong, nonatomic) MapHelper *mapHelper;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cacheLayer = [[CacheLayer alloc] init];

  self.mapHelper = [[MapHelper alloc] initWithView:self.mapView];
  self.mapView.delegate = self.mapHelper;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGRect frame = self.textField.frame;
  frame.size.width = 10000;
  self.textField.frame = frame;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"Low memory warning.");
}

- (IBAction)touchLocation:(UIBarButtonItem *)sender {
  self.mapHelper.following = !self.mapHelper.following;
}

@end
