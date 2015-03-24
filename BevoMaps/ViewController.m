//
//  ViewController.m
//  BevoMaps
//
//  Created by Eric Nguyen on 3/22/15.
//  Copyright (c) 2015 BevoMaps. All rights reserved.
//

#import "ViewController.h"
#import "SearchLayer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
