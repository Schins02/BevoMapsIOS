//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#define IPhone6 1042
#define IPhone5s 888

#define BGAlpha 0.1
#define BGFade 0.2

#import "BuildingVC.h"
#import "SearchLayer.h"

@interface BuildingVC () <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITapGestureRecognizer *bgRecognizer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *upGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *downGesture;

@property float userZoomScale;

@end

@implementation BuildingVC

- (UIImage *)image {
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image {
  self.scrollView.zoomScale = 1.0;
  self.imageView.image = image;
  self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  [self.imageView sizeToFit];
  self.scrollView.contentSize = image ? image.size : CGSizeZero;
  self.scrollView.zoomScale = self.userZoomScale;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    scrollView.backgroundColor = [UIColor colorWithRed:232/255.0
                                                 green:221/255.0
                                                  blue:189/255.0
                                                 alpha:1];
    scrollView.minimumZoomScale = 0.1;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [UIImageView new];
    [self.scrollView addSubview:self.imageView];
    
    self.textField = [[UITextField alloc] initWithFrame:
                      CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width - 160, 30)];
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.textField setFont:[UIFont systemFontOfSize:14]];
    self.textField.delegate = self;
    self.textField.placeholder = @"Search";
    self.textField.text = self.searchText;
    self.navigationItem.titleView = self.textField;
    
    self.upGesture.numberOfTouchesRequired = 2;
    self.upGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.downGesture.numberOfTouchesRequired = 2;
    self.downGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.frame];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(touchBG)];
    [self.bgView addGestureRecognizer:self.bgRecognizer];
    
    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.upGesture];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.downGesture];
    
    [self adjustForScreenSize];
    
    [self.cacheLayer loadImage:self building:self.building floor:self.floor];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (IBAction)swipeUpFloor {
  self.userZoomScale = self.scrollView.zoomScale;
  NSArray *floors = [self.cacheLayer floorNames:self.building];
  NSInteger index = [floors indexOfObject:self.floor];
  if (--index > 0) {
    self.floor = floors[index];
    [self.cacheLayer loadImage:self building:self.building floor:self.floor];
  }
}

- (IBAction)swipeDownFloor {
  self.userZoomScale = self.scrollView.zoomScale;
  NSArray *floors = [self.cacheLayer floorNames:self.building];
  NSInteger index = [floors indexOfObject:self.floor];
  if (++index < floors.count) {
    self.floor = floors[index];
    [self.cacheLayer loadImage:self building:self.building floor:self.floor];
  }
}

- (void)adjustForScreenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger totalScreenSize = screenRect.size.width + screenRect.size.height;
    UIEdgeInsets insets;
    switch(totalScreenSize){
        case IPhone6:
            insets = UIEdgeInsetsMake(80, 30, 0, 0);
            break;
        case IPhone5s:
            insets = UIEdgeInsetsMake(50, 30, 0, 0);
            break;
    }
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    self.userZoomScale = .15;
}

- (void)createIntent:(NSString *)building floor:(NSString *)floor {
    self.building = building;
    self.floor = floor;
    [self.cacheLayer loadImage:self building:self.building floor:self.floor];
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

@end
