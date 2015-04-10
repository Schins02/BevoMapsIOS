//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "MapViewController.h"
#import "DataLayer.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self zoomToTower];
}

- (void) zoomToTower {
    float spanX = 0.003;
    float spanY = 0.003;
    MKCoordinateRegion region;
    region.center.latitude = 30.2861;
    region.center.longitude = -97.739321;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
