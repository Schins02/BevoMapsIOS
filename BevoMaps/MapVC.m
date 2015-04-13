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

@property (strong, nonatomic) NSString *building, *floor;
@property (strong, nonatomic) MapHelper *mapHelper;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cacheLayer = [CacheLayer new];
  
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
  NSDictionary *map = [SearchLayer parseInputText:textField.text];
  NSString *building = [map objectForKey:@"building"];

  if (building != nil && [self.cacheLayer isBuilding:building]) {
    [self createIntent:building floor:[map objectForKey:@"floor"]];
  }
  return false;
}

- (void)createIntent:(NSString *)building floor:(NSString *)floor {
  self.building = building;
  self.floor = floor;
  [self performSegueWithIdentifier:@"showBuilding" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  BuildingVC *controller = (BuildingVC *)segue.destinationViewController;
  controller.cacheLayer = self.cacheLayer;
  controller.building = self.building;
  controller.floor = self.floor;
}

- (IBAction)touchLocation:(UIBarButtonItem *)sender {
  self.mapHelper.following = !self.mapHelper.following;
}

@end
