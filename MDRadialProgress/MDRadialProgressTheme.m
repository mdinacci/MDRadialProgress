//
//  MDRadialProgressTheme.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "MDRadialProgressTheme.h"

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
	
	return theme;
}

+ (id)standardTheme
{
	return [MDRadialProgressTheme themeWithName:STANDARD_THEME];
}

@end
