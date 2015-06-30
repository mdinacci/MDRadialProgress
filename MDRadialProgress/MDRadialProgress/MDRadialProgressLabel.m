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
		// Center it in the frame.
		CGPoint center = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height / 2);
		self.center = center;

		[self updatedFrame:frame];
		[self updatedThickness:theme.thickness];
		[self updatedFontAttributes:theme];

		// Customise appearance
		self.textAlignment = UITextAlignmentCenter;
		self.pointSizeToWidthFactor = 0.5;
		self.adjustFontSizeToFitBounds = YES;

		// Align horizontally and vertically (numberOfLines) the label.
		self.numberOfLines = 0;
		self.adjustsFontSizeToFitWidth = YES;
		
		// Very important because iOS 6 uses a white color which will results
		// in the label drawing over the MDRadialProgressView.
		self.backgroundColor = [UIColor clearColor];
    }
	
    return self;
}

- (void)updatedFrame:(CGRect)newFrame {
	_originalFrame = newFrame;
}

- (void)updatedThickness:(CGFloat)thickness {
	// Reduce the bounds according to the thickness declared in the theme.
	// This may change later, see observeValueForKeyPath...

	CGFloat sideDimension = MIN(CGRectGetWidth(_originalFrame), CGRectGetHeight(_originalFrame)) - thickness;
	CGRect adjustedFrame = CGRectMake(_originalFrame.origin.x + thickness, _originalFrame.origin.y + thickness, sideDimension, sideDimension);

	self.bounds = adjustedFrame;
}

- (void)updatedFontAttributes:(MDRadialProgressTheme *)theme {
	self.font = theme.font;
	self.textColor = theme.labelColor;

	if (theme.dropLabelShadow) {
		self.shadowColor = theme.labelShadowColor;
		self.shadowOffset = theme.labelShadowOffset;
    } else  {
        self.shadowOffset = CGSizeZero;
    }
}

- (void)drawRect:(CGRect)rect
{
	if (self.adjustFontSizeToFitBounds) {
		// adjustsFontSizeToFitWidth works but the text look too big when the progress view is small.
		// This scale down the font until its point size is less than pointSizeToWidthFactor of the bounds' width.
		CGFloat maxWidth = rect.size.width * self.pointSizeToWidthFactor;
		while (self.font.pointSize > maxWidth) {
			self.font = [self.font fontWithSize:self.font.pointSize - 1];
		}
	}
	
	[super drawRect:rect];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:keyThickness]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		[self updatedThickness:view.theme.thickness];
		[self setNeedsLayout];
	} else if ([keyPath isEqualToString:keyFrame]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		[self updatedFrame:view.bounds];
        [self updatedThickness:view.theme.thickness];
		[self setNeedsLayout];
	} else if ([[keyPath lowercaseString] rangeOfString:@"label"].location != NSNotFound || [keyPath isEqualToString:keyFont]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		[self updatedFontAttributes:view.theme];
		[self setNeedsLayout];
	} else if ([keyPath isEqualToString:keyTheme]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		[self updatedThickness:view.theme.thickness];
		[self updatedFontAttributes:view.theme];
		[self setNeedsLayout];
	}
}



@end
