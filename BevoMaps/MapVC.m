//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "MapVC.h"
#import "MapHelper.h"
#import "BuildingVC.h"
#import "SearchLayer.h"

#import <MapKit/MapKit.h>

@interface MapVC () <UITextFieldDelegate>

@property (strong, nonatomic) MapHelper *mapHelper;
@property (strong, nonatomic) NSDictionary *searchResults;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapVC

- (NSDictionary *)searchResults {
  if(!_searchResults){
    _searchResults = [[NSDictionary alloc] init];
  }
  return _searchResults;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cacheLayer = [[CacheLayer alloc] init];
  
  self.mapHelper = [[MapHelper alloc] initWithView:self.mapView];
  self.mapView.delegate = self.mapHelper;
  
  self.textField.delegate = self;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGRect frame = self.textField.frame;
  frame.size.width = self.navigationController.navigationBar.frame.size.width;
  self.textField.frame = frame;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"Low memory warning.");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self performSegueWithIdentifier:@"showBuilding" sender:self];
  return false;
}

- (IBAction)touchLocation:(UIBarButtonItem *)sender {
  self.mapHelper.following = !self.mapHelper.following;
}

@end
