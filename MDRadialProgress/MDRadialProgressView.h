//
//  MDRadialProgressView.h
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRadialProgressView : UIView

@property (assign, nonatomic) NSUInteger progressTotal;
@property (assign, nonatomic) NSUInteger progressCurrent;

@property (strong, nonatomic) UIColor *completedColor;
@property (strong, nonatomic) UIColor *incompletedColor;

@property (assign, nonatomic) CGFloat thickness;

@property (strong, nonatomic) UIColor *sliceDividerColor;
@property (assign, nonatomic) BOOL sliceDividerHidden;
@property (assign, nonatomic) NSUInteger sliceDividerThickness;

@end
