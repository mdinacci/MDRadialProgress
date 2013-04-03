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
    self.sliceDividerHidden = NO;
    self.sliceDividerThickness = 2;
}

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(CGFloat)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{

    int slicesCompletedMinusOne = slicesCompleted - 1;
    float sliceValue = 1.0f/slicesCount;
    for (int i = 0; i < slicesCount; i++) {
        CGFloat startValue = sliceValue * i;
        CGFloat startAngle = startValue * 2 * M_PI - M_PI/2;
        CGFloat endValue = sliceValue * (i+1);
        CGFloat endAngle = endValue * 2 * M_PI - M_PI/2;
        
        CGColorRef color = self.incompletedColor.CGColor;
        if (slicesCompletedMinusOne >= i) {
            color = self.completedColor.CGColor;
        } 
        
        CGContextSetFillColorWithColor(context, color);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.progressTotal <= 0) {
        return;
    }
    
    // Draw the slices in the center of the view
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    float radius = self.bounds.size.width/2;
    [self drawSlices:self.progressTotal completed:self.progressCurrent radius:radius center:center inContext:contextRef];
    
    CGContextSetLineWidth(contextRef, 1);
    CGContextSetRGBStrokeColor(contextRef, 1.0, 0.0, 0.0, 1.0);
    
    CGSize viewSize = self.bounds.size;
    
    float halfThickness = self.thickness / 2;
    int outerRadius = viewSize.width - self.thickness;
    float halfOuterRadius = outerRadius / 2;
    int innerRadius = outerRadius - self.thickness;
    float halfInnerRadius = innerRadius / 2;
    
    if (! self.sliceDividerHidden) {
        int sliceCount = self.progressTotal;
        float slice = (2 * M_PI) / sliceCount;
        CGContextSetLineWidth(contextRef, self.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, self.sliceDividerColor.CGColor);
        for (int i = 0; i < sliceCount; i++) {
            double angle = slice * i;

            float outerX = (halfOuterRadius + halfThickness) * cos(angle - M_PI_2) + center.x;
            float outerY = (halfOuterRadius + halfThickness) * sin(angle - M_PI_2) + center.y;
            CGPoint startPoint = CGPointMake(outerX, outerY);

            float innerX = halfInnerRadius * cos(angle - M_PI_2) + center.x;
            float innerY = halfInnerRadius * sin(angle - M_PI_2) + center.y;
            CGPoint endPoint = CGPointMake(innerX, innerY);
            
            CGPoint points[2] = {startPoint, endPoint};
            CGContextStrokeLineSegments(contextRef, points, 2);
        }
    }
    
    // Draw circle
    CGContextSetLineWidth(contextRef, self.thickness);
    CGContextSetRGBFillColor(contextRef, 1.0, 1.0, 1.0, 1.0);
    CGRect circlePoint = CGRectMake(center.x - halfInnerRadius, center.y - halfInnerRadius,
                                    innerRadius, innerRadius);
    CGContextFillEllipseInRect(contextRef, circlePoint);
}


@end
