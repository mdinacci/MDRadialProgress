//
// ViewController.m
// MDRadialProgress
//
//
// Copyright (c) 2013 Marco Dinacci. All rights reserved.


#import "ViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@implementation ViewController

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];

	// Only required in this demo to align vertically the progress views.
	view.center = CGPointMake(self.view.center.x + 80, view.center.y);
	
	return view;
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
	CGRect frame = CGRectMake(5, y, 180, 50);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.numberOfLines = 0;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [label.font fontWithSize:14];
	
	return label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 800);
	[self.view addSubview:scrollView];
	
	self.view.backgroundColor = [UIColor whiteColor];
    
	int x = self.view.center.x + 80;
	int y = 20;
	
//	Example 1 ========================================================================
	UILabel *label = [self labelAtY:y andText:@"Standard theme: "];
	[scrollView addSubview:label];
	
    CGRect frame = CGRectMake(x, y, 50, 50);
    MDRadialProgressView *radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 7;
    radialView.progressCounter = 4;
	radialView.theme.sliceDividerHidden = YES;
    [scrollView addSubview:radialView];
    
//	Example 1 ========================================================================
	
	y += 80;

//	Example 7 ========================================================================
	label = [self labelAtY:y andText:@"Custom theme, shared by all instances: "];
	[scrollView addSubview:label];
	
	MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
	newTheme.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
	newTheme.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
	newTheme.centerColor = [UIColor clearColor];
	newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
	newTheme.sliceDividerHidden = YES;
	newTheme.labelColor = [UIColor blackColor];
	newTheme.labelShadowColor = [UIColor whiteColor];
	
	y += 50;
	
	frame = CGRectMake(10, y, 60, 60);
    MDRadialProgressView *radialView7 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
	radialView7.progressTotal = 4;
	radialView7.progressCounter = 1;
	[scrollView addSubview:radialView7];
	
	frame = CGRectMake(90, y, 60, 60);
	MDRadialProgressView *radialView8 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
	radialView8.progressTotal = 4;
	radialView8.progressCounter = 2;
	[scrollView addSubview:radialView8];
	
	frame = CGRectMake(170, y, 60, 60);
	MDRadialProgressView *radialView9 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
	radialView9.progressTotal = 4;
	radialView9.progressCounter = 3;
	[scrollView addSubview:radialView9];
	
	frame = CGRectMake(250, y, 60, 60);
	MDRadialProgressView *radialView10 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
	radialView10.progressTotal = 4;
	radialView10.progressCounter = 4;
	[scrollView addSubview:radialView10];
//	Example 7 ========================================================================
	
	y += 100;
	
//	Example 2 ========================================================================
	label = [self labelAtY:y andText:@"incompletedColor is clear, no divider, no label:"];
	[scrollView addSubview:label];
	
	frame = CGRectMake(x, y, 100, 100);
    MDRadialProgressView *radialView2 = [self progressViewWithFrame:frame];
	radialView2.progressTotal = 5;
    radialView2.progressCounter = 3;
    radialView2.theme.thickness = 15;
	radialView2.theme.incompletedColor = [UIColor clearColor];
	radialView2.theme.completedColor = [UIColor orangeColor];
    radialView2.theme.sliceDividerHidden = YES;
	radialView2.label.hidden = YES;

	[scrollView addSubview:radialView2];
    
//	Example 2 ========================================================================
	
	y += 130;

//	Example 3 ========================================================================
	label = [self labelAtY:y andText:@"Center color = completed color, no divider: "];
	[scrollView addSubview:label];
	
	frame = CGRectMake(x, y, 100, 100);
    MDRadialProgressView *radialView3 = [self progressViewWithFrame:frame];
	
	radialView3.progressTotal = 5;
    radialView3.progressCounter = 4;
	radialView3.theme.completedColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
	radialView3.theme.incompletedColor = [UIColor blackColor];
    radialView3.theme.thickness = 10;
    radialView3.theme.sliceDividerHidden = YES;
	radialView3.theme.centerColor = radialView3.theme.completedColor;

	[scrollView addSubview:radialView3];
//	Example 3 ========================================================================

	y += 130;
	
//	Example 4 ========================================================================
	label = [self labelAtY:y andText:@"No label, anti-clockwise: "];
	[scrollView addSubview:label];
	
	frame = CGRectMake(x, y, 70, 70);
    MDRadialProgressView *radialView4 = [self progressViewWithFrame:frame];
    
	radialView4.progressTotal = 10;
    radialView4.progressCounter = 3;
	radialView4.clockwise = NO;
	radialView4.theme.completedColor = [UIColor colorWithRed:90/255.0 green:200/255.0 blue:251/255.0 alpha:1.0];
	radialView4.theme.incompletedColor = [UIColor colorWithRed:82/255.0 green:237/255.0 blue:199/255.0 alpha:1.0];
    radialView4.theme.thickness = 30;
    radialView4.theme.sliceDividerHidden = NO;
    radialView4.theme.sliceDividerColor = [UIColor whiteColor];
    radialView4.theme.sliceDividerThickness = 2;
	radialView4.label.hidden = YES;
    
    [scrollView addSubview:radialView4];

//	Example 4 ========================================================================
	
	y += 110;

//	Example 5 ========================================================================
	label = [self labelAtY:y andText:@"Start from slice 3, custom label color with no shadow: "];
	[scrollView addSubview:label];
	
    frame = CGRectMake(x, y, 100, 100);
    MDRadialProgressView *radialView5 = [self progressViewWithFrame:frame];

	radialView5.progressTotal = 10;
    radialView5.progressCounter = 3;
	radialView5.startingSlice = 3;
    radialView5.theme.sliceDividerHidden = NO;
    radialView5.theme.sliceDividerThickness = 1;
	radialView5.label.textColor = [UIColor blueColor];
	radialView5.label.shadowColor = [UIColor clearColor];

	[scrollView addSubview:radialView5];
//	Example 5 ========================================================================
	
	y += 130;
	
//	Example 6 ========================================================================
	label = [self labelAtY:y andText:@"Huge thickness, no divider: "];
	[scrollView addSubview:label];
	
    frame = CGRectMake(x, y, 100, 100);
    MDRadialProgressView *radialView6 = [self progressViewWithFrame:frame];
	
	radialView6.startingSlice = 5;
	radialView6.progressTotal = 20;
    radialView6.progressCounter = 9;
	radialView6.startingSlice = 3;
	radialView6.clockwise = YES;
    radialView6.theme.thickness = 70;
	radialView6.theme.completedColor = [UIColor brownColor];
	radialView6.theme.sliceDividerThickness = 0;
    
	[scrollView addSubview:radialView6];
//	Example 6 ========================================================================

	y += 130;
	
//	Example 11 ========================================================================
	label = [self labelAtY:y andText:@"No progress, show dividers anyway"];
	[scrollView addSubview:label];
	
	frame = CGRectMake(x, y, 100, 100);
    MDRadialProgressView *radialView11 = [self progressViewWithFrame:frame];
	radialView11.progressTotal = 10;
    radialView11.progressCounter = 0;
	radialView11.theme.incompletedColor = [UIColor clearColor];
	radialView11.theme.centerColor = [UIColor whiteColor];
	radialView11.theme.sliceDividerColor = [UIColor grayColor];
	radialView11.theme.sliceDividerThickness = 2;
	radialView11.theme.sliceDividerHidden = NO;
	radialView11.label.hidden = YES;
	[scrollView addSubview:radialView11];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
