//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "ViewController.h"
#import "SearchLayer.h"



@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic) unsigned floor;

@end

@implementation ViewController

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar
{
    NSLog(@"User searched for %@", searchBar.text);
    NSDictionary *searchResults = [SearchLayer parseInputText:searchBar.text];
    NSLog(@"Parsed as: %@", searchResults);
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.1;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:221.0/255.0 blue:189.0/255.0 alpha:1.0];
    _scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UIImage *)image
{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)i
{
    self.imageView.image = i;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    self.scrollView.zoomScale = .14;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image = [UIImage imageNamed:@"GDCFloor1"];
    [self.scrollView addSubview:self.imageView];
    self.searchBar.delegate = self;
    self.floor = 1;
    self.swipeGesture.numberOfTouchesRequired = 2;
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.swipeGesture];
}

- (IBAction)floorSwipe:(UISwipeGestureRecognizer *)sender {
    
    self.floor++;
    if (self.floor == 8)
    {
        self.floor = 7;
    }
    else
    {
        NSString *current_floor = [NSString stringWithFormat:@"GDCFloor%u", self.floor];
        self.scrollView.zoomScale = 1.0;
        self.image = [UIImage imageNamed:current_floor];
    }
    
}



@end
