//
//  ViewController.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "ViewController.h"
#import "MDRadialProgressView.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = CGRectMake(30, 30, 50, 50);
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    radialView.progressTotal = 4;
    radialView.progressCurrent = 2;
    radialView.thickness = 10;
    radialView.backgroundColor = [UIColor whiteColor];
    radialView.sliceDividerHidden = YES;
    
    [self.view addSubview:radialView];
	
	frame = CGRectMake(180, 10, 100, 100);
    MDRadialProgressView *radialView2 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView2.progressTotal = 10;
    radialView2.progressCurrent = 3;
	radialView2.completedColor = [UIColor blueColor];
	radialView2.incompletedColor = [UIColor redColor];
    radialView2.thickness = 30;
    radialView2.backgroundColor = [UIColor whiteColor];
    radialView2.sliceDividerHidden = NO;
    radialView2.sliceDividerColor = [UIColor whiteColor];
    radialView2.sliceDividerThickness = 1;

	[self.view addSubview:radialView2];
	
	
	frame = CGRectMake(30, 200, 120, 120);
    MDRadialProgressView *radialView3 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView3.progressTotal = 5;
    radialView3.progressCurrent = 4;
	radialView3.completedColor = [UIColor whiteColor];
	radialView3.incompletedColor = [UIColor blackColor];
    radialView3.thickness = 10;
    radialView3.backgroundColor = [UIColor blackColor];
    radialView3.sliceDividerHidden = YES;
	
	[self.view addSubview:radialView3];
	
	
	frame = CGRectMake(180, 220, 70, 70);
    MDRadialProgressView *radialView4 = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    radialView4.progressTotal = 5;
    radialView4.progressCurrent = 3;
    radialView4.thickness = 15;
	radialView4.incompletedColor = [UIColor orangeColor];
	radialView4.completedColor = [UIColor purpleColor];
    radialView4.backgroundColor = [UIColor yellowColor];
	radialView4.sliceDividerColor = [UIColor yellowColor];
    radialView4.sliceDividerHidden = NO;
	radialView4.sliceDividerThickness = 5;
    
    [self.view addSubview:radialView4];
	
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
