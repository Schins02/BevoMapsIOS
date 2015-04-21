//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#define BGAlpha 0.1
#define BGFade 0.2

#define BUTTON_WIDTH 43
#define BUTTON_HEIGHT 30

#define FONT_SIZE 30

#import "BuildingVC.h"
#import "SearchLayer.h"

@interface BuildingVC () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic) CGFloat zoomScale;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITapGestureRecognizer *bgRecognizer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *upGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *downGesture;

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (strong, nonatomic) NSDictionary *defaultFloors;

@end

@implementation BuildingVC

- (UIImage *)image {
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image {
    self.scrollView.zoomScale = 1;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.imageView sizeToFit];
    self.scrollView.contentSize = image ? image.size : CGSizeZero;
    self.scrollView.zoomScale = self.zoomScale;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    scrollView.backgroundColor = [UIColor colorWithRed:232/255.0
                                                 green:221/255.0
                                                  blue:189/255.0
                                                 alpha:1];
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(80, 30, 80, 30);
    scrollView.minimumZoomScale = 0.1;
    scrollView.maximumZoomScale = 2.0;
    scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView = scrollView;
}

-(UIButton *)createButton:(NSString *)title y_coord:(float)y
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    UIColor *burntOrange = [UIColor colorWithRed:191.0/255.0
                                           green:87.0/255.0
                                            blue:0.0
                                           alpha:1.0];
    [button setTitleColor:burntOrange forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, y, BUTTON_WIDTH, BUTTON_HEIGHT);
    button.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [self.view addSubview:button];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.zoomScale = 0.15;
    
    self.imageView = [UIImageView new];
    [self.scrollView addSubview:self.imageView];
    
    self.textField = [[UITextField alloc] initWithFrame:
                      CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width - 160, 30)];
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.textField setFont:[UIFont systemFontOfSize:14]];
    self.textField.delegate = self;
    self.textField.placeholder = @"Search";
    self.textField.text = self.text;
    self.navigationItem.titleView = self.textField;
    
    self.upGesture.numberOfTouchesRequired = 2;
    self.upGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.downGesture.numberOfTouchesRequired = 2;
    self.downGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.frame];
    self.bgView.backgroundColor = [UIColor clearColor];
    
    self.bgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(touchBackground)];
    [self.bgView addGestureRecognizer:self.bgRecognizer];
    
    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.upGesture];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.downGesture];
    
    [self.cacheLayer loadImage:self building:self.building floor:self.floor];
    
    self.upButton = [self createButton:@"△" y_coord:self.view.frame.size.height - 90];
    [self.upButton addTarget:self action:@selector(changeUpFloor) forControlEvents:UIControlEventTouchUpInside];
    self.downButton = [self createButton:@"▽" y_coord:self.view.frame.size.height - 30];
    [self.downButton addTarget:self action:@selector(changeDownFloor) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSDictionary *map = [SearchLayer parseInputText:textField.text];
    NSString *building = [map objectForKey:@"building"];
    
    if (building != nil && [self.cacheLayer isBuilding:building]) {
        self.building = building;
        self.floor = [map objectForKey:@"floor"];
        [self.cacheLayer loadImage:self building:self.building floor:self.floor];
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

- (IBAction)changeUpFloor {
    self.zoomScale = self.scrollView.zoomScale;
    NSArray *floors = [self.cacheLayer floorNames:self.building];
    
    if(self.floor == nil) //hack to fix floor not getting set when user enters no floor
        self.floor = self.defaultFloors[self.building];
        
    NSInteger index = [floors indexOfObject:self.floor];
    if (--index >= 0) {
        self.floor = floors[index];
        [self.cacheLayer loadImage:self building:self.building floor:self.floor];
    }
}

- (IBAction)changeDownFloor {
    self.zoomScale = self.scrollView.zoomScale;
    NSArray *floors = [self.cacheLayer floorNames:self.building];
    
    
    if(self.floor == nil)  //hack to fix floor not getting set when user enters no floor
        self.floor = self.defaultFloors[self.building];
        
    NSInteger index = [floors indexOfObject:self.floor];
    if (++index < floors.count) {
        self.floor = floors[index];
        [self.cacheLayer loadImage:self building:self.building floor:self.floor];
    }
}

- (void)touchBackground {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (NSDictionary *)defaultFloors {
    if(!_defaultFloors){
        _defaultFloors = @{@"BME":@"2",
                           @"CLA":@"1",
                           @"SAC":@"1",
                           @"UTC":@"2",
                           @"WEL":@"2",
                           @"GDC":@"2"};
    }
    return _defaultFloors;
}

@end
