//
//  MDRadialProgressTheme.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "MDRadialProgressTheme.h"


// The font size is automatically adapted but this is the maximum it will get
// unless overridden by the user.
static const int kMaxFontSize = 64;


@implementation MDRadialProgressTheme

+ (id)themeWithName:(const NSString *)themeName
{
	MDRadialProgressTheme *theme = [[MDRadialProgressTheme alloc] init];
	theme.completedColor = [UIColor greenColor];
    theme.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    theme.sliceDividerColor = [UIColor whiteColor];
	theme.centerColor = [UIColor clearColor];
    theme.thickness = 15;
    theme.sliceDividerHidden = NO;
    theme.sliceDividerThickness = 2;
	
	// Label
	theme.labelColor = [UIColor blackColor];
	theme.dropLabelShadow = YES;
	theme.labelShadowColor = [UIColor darkGrayColor];
	theme.font = [UIFont systemFontOfSize:kMaxFontSize];
	
	return theme;
}

+ (id)standardTheme
{
	return [MDRadialProgressTheme themeWithName:STANDARD_THEME];
}

@end
