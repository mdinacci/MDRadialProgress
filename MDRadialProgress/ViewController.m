//
//  ViewController.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "ViewController.h"
#import "MDRadialProgressView.h"


@interface ViewController ()

@property (strong, nonatomic) MDRadialProgressView *radialView;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = CGRectMake(100, 200, 50, 50);
    self.radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    self.radialView.progressTotal = 5;
    self.radialView.progressCurrent = 3;
    self.radialView.thickness = 10;
    self.radialView.backgroundColor = [UIColor whiteColor];
    self.radialView.sliceDividerHidden = NO;
    self.radialView.sliceDividerColor = [UIColor whiteColor];
    self.radialView.sliceDividerThickness = 1;
    
    [self.view addSubview:self.radialView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
