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
	
	self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(30, 30, 50, 50);
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    radialView.progressTotal = 4;
    radialView.progressCounter = 2;
    radialView.thickness = 10;
    radialView.sliceDividerHidden = YES;
    
    [self.view addSubview:radialView];
	
	frame = CGRectMake(180, 10, 100, 100);
    MDRadialProgressView *radialView2 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView2.progressTotal = 10;
    radialView2.progressCounter = 3;
	radialView2.completedColor = [UIColor blueColor];
	radialView2.incompletedColor = [UIColor redColor];
    radialView2.thickness = 30;
    radialView2.sliceDividerHidden = NO;
    radialView2.sliceDividerColor = [UIColor whiteColor];
    radialView2.sliceDividerThickness = 2;

	[self.view addSubview:radialView2];
	
	frame = CGRectMake(10, 180, 300, 25);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = @"Lorem ipsum dolor sit...";
	[self.view addSubview:label];
	
	frame = CGRectMake(30, 150, 120, 120);
    MDRadialProgressView *radialView3 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView3.progressTotal = 5;
    radialView3.progressCounter = 4;
	radialView3.completedColor = [UIColor redColor];
	radialView3.incompletedColor = [UIColor blackColor];
    radialView3.thickness = 10;
    radialView3.sliceDividerHidden = YES;
	
	[self.view addSubview:radialView3];
	
	
	frame = CGRectMake(180, 170, 70, 70);
    MDRadialProgressView *radialView4 = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    radialView4.progressTotal = 5;
    radialView4.progressCounter = 3;
    radialView4.thickness = 15;
	radialView4.incompletedColor = [UIColor orangeColor];
	radialView4.completedColor = [UIColor purpleColor];
    radialView4.sliceDividerHidden = NO;
	radialView4.sliceDividerThickness = 5;
    
    [self.view addSubview:radialView4];
    
    
    frame = CGRectMake(40, 300, 100, 100);
    MDRadialProgressView *radialView5 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView5.progressTotal = 10;
    radialView5.progressCounter = 3;
    radialView5.thickness = 30;
    radialView5.sliceDividerHidden = NO;
    radialView5.sliceDividerColor = [UIColor blueColor];
    radialView5.sliceDividerThickness = 1;
    radialView5.startingSlice = 1;
    radialView5.clockwise = NO;
    
	[self.view addSubview:radialView5];
	
    frame = CGRectMake(180, 300, 100, 100);
    MDRadialProgressView *radialView6 = [[MDRadialProgressView alloc] initWithFrame:frame];
	
	radialView6.startingSlice = 5;
	radialView6.progressTotal = 20;
    radialView6.progressCounter = 9;
	radialView6.startingSlice = 3;
    radialView6.thickness = 80;
	radialView6.completedColor = [UIColor brownColor];
	radialView6.sliceDividerThickness = 0;
    radialView6.clockwise = YES;
    
	[self.view addSubview:radialView6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
