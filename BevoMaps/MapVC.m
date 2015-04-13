//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "MapVC.h"
#import "MapHelper.h"
#import "SearchLayer.h"
#import "BuildingVC.h"

#import <MapKit/MapKit.h>

@interface MapVC ()

@property (strong, nonatomic) MapHelper *mapHelper;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSDictionary *searchResults;

@end

@implementation MapVC

- (NSDictionary *)getSearchResults {
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

- (IBAction)userSearched:(UITextField *)sender {
    self.searchResults = [SearchLayer parseInputText:sender.text];
    //if([self.searchResults count] > 0)
        //[self performSegueWithIdentifier:@"showBuilding" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end
