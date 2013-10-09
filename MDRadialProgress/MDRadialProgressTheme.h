//
//  MDRadialProgressTheme.h
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <Foundation/Foundation.h>


static const NSString *STANDARD_THEME = @"standard";


@interface MDRadialProgressTheme : NSObject

+ (id)themeWithName:(const NSString *)themeName;
+ (id)standardTheme;

// Color of the completed steps.
@property (strong, nonatomic) UIColor *completedColor;

// Color of the incompleted steps.
@property (strong, nonatomic) UIColor *incompletedColor;

// Color of the inner center
@property (strong, nonatomic) UIColor *centerColor;

// Thickness of the progress view.
@property (assign, nonatomic) CGFloat thickness;

// Color used to draw the division between each slices.
// Normally set to the background color so that it makes the slices
// look separated.
@property (strong, nonatomic) UIColor *sliceDividerColor;

// Whether the slice division is hidden or not.
@property (assign, nonatomic) BOOL sliceDividerHidden;

// Regulates how far apart the slice are when sliceDividerHidden is set to YES.
@property (assign, nonatomic) NSUInteger sliceDividerThickness;


// Label properties

// Color of the label text.
@property (strong, nonatomic) UIColor *labelColor;

// Shall we drop a shadow ?
@property (assign, nonatomic) BOOL dropLabelShadow;

// Shadow color of the label text.
@property (strong, nonatomic) UIColor *labelShadowColor;

// Shadow offset
@property (assign, nonatomic) CGSize labelShadowOffset;

// Font to use in the label.
@property (strong, nonatomic) UIFont *font;

@end
