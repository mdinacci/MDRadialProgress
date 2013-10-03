//
//  MDRadialProgressView.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"

#define MD_DEBUG 0


@interface MDRadialProgressView ()

// Padding from the view bounds to the outer circumference of the view.
// Useful because at times the circle may appear "cut" by one or two pixels
// since it's drawing over the view bounds.
@property (assign, nonatomic) NSUInteger internalPadding;

@end


@implementation MDRadialProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self internalInit];
}

- (void)internalInit
{
    // Default values for public properties
    self.completedColor = [UIColor greenColor];
    self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.sliceDividerColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.thickness = 40;
    self.sliceDividerHidden = NO;
    self.sliceDividerThickness = 2;
    self.startingSlice = 1;
    self.clockwise = YES;
	
	// Private properties
	self.internalPadding = 2;
}

#pragma mark - Drawing

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(CGFloat)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
    NSUInteger startingSlice = self.startingSlice -1;
    
	if (!self.sliceDividerHidden && self.sliceDividerThickness > 0) {
		// Draw one arc at a time.
        
        CGFloat sliceAngle = (2 * M_PI ) / slicesCount;
        for (int i =0; i < slicesCount; i++) {
            CGFloat startValue = (sliceAngle * i) + sliceAngle * startingSlice;
            CGFloat startAngle, endAngle;
            if (self.clockwise) {
                startAngle = - M_PI_2 + startValue;
				endAngle = startAngle + sliceAngle;
            } else {
                startAngle = - M_PI_2 - startValue;
				endAngle = startAngle - sliceAngle;
            }
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius,
							startAngle, endAngle, cgClockwise);
            
            CGColorRef color = self.incompletedColor.CGColor;
            
            if (i < slicesCompleted) {
                color = self.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    } else {
		// Draw just two arcs, one for the completed slices and one for the
		// uncompleted ones.
		
        CGFloat originAngle, endAngle;
		CGFloat sliceAngle = (2 * M_PI) / self.progressTotal;
		CGFloat startingAngle = sliceAngle * startingSlice;
		CGFloat progressAngle = sliceAngle * self.progressCounter;
		
		if (self.progressCounter == 0) {
			originAngle = -M_PI_2;
			endAngle = originAngle + 2 * M_PI;
		} else {
			if (self.clockwise) {
				originAngle = -M_PI_2 + startingAngle;
				endAngle = originAngle + progressAngle;
			} else {
				originAngle = -M_PI_2 - startingAngle;
				endAngle = originAngle - progressAngle;
			}
		}
		
		// Draw the arcs grouped instead of individually to avoid
		// artifacts between one slice and another.
		// Completed slices.
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, cgClockwise);
		CGColorRef color = self.completedColor.CGColor;
		CGContextSetFillColorWithColor(context, color);
		CGContextFillPath(context);
		
		// Incompleted slices
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
		CGFloat startAngle = endAngle;
        endAngle = originAngle;
		CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
		color = self.incompletedColor.CGColor;
		CGContextSetFillColorWithColor(context, color);
		CGContextFillPath(context);
	}
}

- (void)drawRect:(CGRect)rect
{
    if (self.progressTotal <= 0) {
        return;
    }
    
    // Draw the slices.
    
	CGSize viewSize = self.bounds.size;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2 - self.internalPadding;
    [self drawSlices:self.progressTotal
		   completed:self.progressCounter
			  radius:radius
			  center:center
		   inContext:contextRef];
    
	// Draw the slice separators.
	
    int outerDiameter = viewSize.width;
    float outerRadius = outerDiameter / 2 - self.internalPadding;
    int innerDiameter = outerDiameter - self.thickness;
    float innerRadius = innerDiameter / 2;
    
    if (! self.sliceDividerHidden) {
        int sliceCount = self.progressTotal;
        float sliceAngle = (2 * M_PI) / sliceCount;
        CGContextSetLineWidth(contextRef, self.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, self.sliceDividerColor.CGColor);
        for (int i = 0; i < sliceCount; i++) {
            double startAngle = sliceAngle * i - M_PI_2;
			double endAngle = sliceAngle * (i + 1) - M_PI_2;
            
			CGContextBeginPath(contextRef);
			CGContextMoveToPoint(contextRef, center.x, center.y);
			
			// Draw the outer arc
			CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
			// Draw the inner arc. The separator line is drawn automatically when moving from
			// the point where the outer arc ended to the point where the inner arc starts.
			CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
			
			CGContextSetStrokeColorWithColor(contextRef, self.sliceDividerColor.CGColor);
			CGContextStrokePath(contextRef);
        }
    }

#if MD_DEBUG
	// Draw the bounds of the view for debug purposes
	CGContextSetLineWidth(contextRef, 1);
	CGContextSetStrokeColorWithColor(contextRef, [UIColor redColor].CGColor);
	CGContextStrokeRect(contextRef, self.bounds);
#endif
	
    // Draw a clear inner circle to fake a hole in the middle if the bg color is clearColor
	CGContextSetLineWidth(contextRef, self.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}


@end
