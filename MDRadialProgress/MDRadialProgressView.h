//
//  MDRadialProgressView.h
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRadialProgressView : UIView

// The total number of steps in the progress view.
@property (assign, nonatomic) NSUInteger progressTotal;

// The number of steps currently completed.
@property (assign, nonatomic) NSUInteger progressCounter;

// Color of the completed steps.
@property (strong, nonatomic) UIColor *completedColor;

// Color of the incompleted steps.
@property (strong, nonatomic) UIColor *incompletedColor;

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

// Whether the progress is drawn clockwise (YES) or anticlockwise (NO)
@property (assign, nonatomic) BOOL clockwise;

// The index of the slice where the first completed step is.
@property (assign, nonatomic) NSUInteger startingSlice;

@end
