//
//  MDRadialProgressLabel.h
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRadialProgressTheme;

@interface MDRadialProgressLabel : UILabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme;

// If adjustFontSizeToFitBounds is enabled, limit the size of the font to the bounds'width * pointSizeToWidthFactor.
@property (assign, nonatomic) CGFloat pointSizeToWidthFactor;

// Whether the algorithm to autoscale the font size is enabled or not.
@property (assign, nonatomic) BOOL adjustFontSizeToFitBounds;

@end
