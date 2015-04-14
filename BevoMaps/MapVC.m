//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#define BGAlpha 0.1
#define BGFade 0.2

#import "MapVC.h"
#import "MapHelper.h"
#import "BuildingVC.h"
#import "SearchLayer.h"

#import <MapKit/MapKit.h>

@interface MapVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *building, *floor;
@property (strong, nonatomic) MapHelper *mapHelper;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITapGestureRecognizer *bgRecognizer;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cacheLayer = [CacheLayer new];
    
    self.mapHelper = [[MapHelper alloc] initWithView:self.mapView];
    self.mapView.delegate = self.mapHelper;
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.frame];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(touchBG)];
    [self.bgView addGestureRecognizer:self.bgRecognizer];
    
    self.textField.delegate = self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.textField.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.textField.frame = frame;
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
    controller.text = self.textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSDictionary *map = [SearchLayer parseInputText:textField.text];
    NSString *building = [map objectForKey:@"building"];
    
    if (building != nil && [self.cacheLayer isBuilding:building]) {
        [self createIntent:building floor:[map objectForKey:@"floor"]];
    }
    return false;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addSubview:self.bgView];
    [UIView animateWithDuration:BGFade animations:^{
        self.bgView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:BGAlpha];
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:BGFade animations:^{
        self.bgView.backgroundColor = [UIColor colorWithRed:0
                                                      green:0
                                                       blue:0
                                                      alpha:0];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

- (void)touchBG {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (IBAction)touchLocation:(UIBarButtonItem *)sender {
    self.mapHelper.following = !self.mapHelper.following;
}

@end
