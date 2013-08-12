//
//  MDRadialProgressView.m
//  MDRadialProgress
//
//  Created by Marco Dinacci on 25/03/2013.
//  Copyright (c) 2013 Marco Dinacci. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"


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
    // Default values
    self.completedColor = [UIColor greenColor];
    self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.sliceDividerColor = [UIColor whiteColor];
    self.thickness = 40;
    self.sliceDividerHidden = YES;
    self.sliceDividerThickness = 2;
    
    self.startSlice = 0;
    self.clockwise = 0;
}

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(CGFloat)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
	if (! self.sliceDividerHidden)
    {
		// Draw one arc at a time.
        
        float sliceValue = 1.0f/slicesCount;
        for (int i = self.startSlice; i < (slicesCount+self.startSlice); i++) {
            
            CGFloat startValue = sliceValue * i;
            CGFloat startAngle;
            if(self.clockwise) startAngle = -startValue * 2 * M_PI - M_PI_2;
            else               startAngle =  startValue * 2 * M_PI - M_PI_2;
            
            
            CGFloat endValue = sliceValue * (i + 1);
            CGFloat endAngle;
            if(self.clockwise) endAngle = -endValue * 2 * M_PI - M_PI_2;
            else               endAngle =  endValue * 2 * M_PI - M_PI_2;
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, endAngle, self.clockwise);
            
            CGColorRef color = self.incompletedColor.CGColor;
            
            if ((slicesCompleted - 1 + self.startSlice) >= i) {
                color = self.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
            
        }
    }
    else
    {
        
        CGFloat sliceAngle = (2 * M_PI) / self.progressTotal;
        
        CGFloat originAngle;
        if(self.clockwise) originAngle = -M_PI_2 - sliceAngle*self.startSlice;
        else               originAngle = -M_PI_2 + sliceAngle*self.startSlice;
        
		// Draw the arcs grouped instead of individually to avoid
		// artifacts between one slice and another.
		// Completed slices
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
        
        
        CGFloat endAngle;
        if(self.clockwise) endAngle = originAngle - sliceAngle * self.progressCurrent;
        else               endAngle = originAngle + sliceAngle * self.progressCurrent;
        
		CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, self.clockwise);
		CGColorRef color = self.completedColor.CGColor;
		CGContextSetFillColorWithColor(context, color);
		CGContextFillPath(context);
		
		// Incompleted slices
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
		CGFloat startAngle = endAngle;
        endAngle = originAngle;
		CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, self.clockwise);
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
    
    self.startSlice = self.startSlice%self.progressTotal;
    
    // Draw the slices.
    
	CGSize viewSize = self.bounds.size;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2;
    [self drawSlices:self.progressTotal
		   completed:self.progressCurrent
			  radius:radius
			  center:center
		   inContext:contextRef];
    
	// Draw the slice separators.
	
    int outerDiameter = viewSize.width;
    float outerRadius = outerDiameter / 2;
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
    
    // Draw the inner circle to fake a hole in the middle.
    
    CGContextSetLineWidth(contextRef, self.thickness);
    
    CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGRect circlePoint = CGRectMake(center.x - innerRadius, center.y - innerRadius,
                                    innerDiameter, innerDiameter);
    CGContextFillEllipseInRect(contextRef, circlePoint);
}


@end
