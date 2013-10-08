//
//  MDRadialProgressLabel.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 07/10/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import "MDRadialProgressLabel.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"

// iOS6 has deprecated UITextAlignment* in favour of NSTextAlignment*
// This allow me to use the property from iOS < 6.
#ifdef __IPHONE_6_0
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#endif


@interface MDRadialProgressLabel ()

@property (assign, nonatomic) CGRect originalFrame;

@end


@implementation MDRadialProgressLabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = NO;
		self.textAlignment = UITextAlignmentCenter;

		// Center in the frame's center
		[self centerInFrame:frame];
		
		// Reduce the frame according to the thickness declared in the theme.
		CGFloat width = frame.size.width - theme.thickness;
		CGFloat height = frame.size.height - theme.thickness;
		CGRect adjustedFrame = CGRectMake(frame.origin.x + theme.thickness, frame.origin.y + theme.thickness, width, height);
		self.bounds = adjustedFrame;
		
		self.textColor = theme.labelColor;
		if (theme.dropLabelShadow) {
			self.layer.shadowColor = theme.labelShadowColor.CGColor;
		}
		
		// Align horizontally and vertically the label.
		self.numberOfLines = 0;
		self.adjustsFontSizeToFitWidth = YES;
		self.adjustsLetterSpacingToFitWidth = YES;
		
		self.font = theme.font;
    }
    return self;
}

- (void)centerInFrame:(CGRect)frame
{
	CGPoint center = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height / 2);
	self.center = center;
}

#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:keyThickness]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		CGFloat thickness = view.theme.thickness;
		CGRect frame = view.frame;
		CGRect adjustedFrame = CGRectMake(frame.origin.x + thickness, frame.origin.y + thickness,
										  frame.size.width - thickness, frame.size.height - thickness);
		
		[self setNeedsLayout];
		[self setNeedsDisplay];

		self.bounds = adjustedFrame;
	}
}



@end
