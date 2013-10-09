//
// MDRadialProgressView.m
// MDRadialProgress
//
//
// Copyright (c) 2013 Marco Dinacci
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"


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
	self.progressTotal = 1;
	self.progressCounter = 0;
	self.startingSlice = 1;
    self.clockwise = YES;
	self.showProgressSummary = YES;
	
	// Standard theme
    self.completedColor = [UIColor greenColor];
    self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.sliceDividerColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
	self.centerColor = [UIColor clearColor];
    self.thickness = 40;
    self.sliceDividerHidden = NO;
    self.sliceDividerThickness = 2;
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	[self addObserver:self forKeyPath:@"progressTotal" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"progressCounter" options:NSKeyValueObservingOptionNew context:nil];
	
	// Add the summary view as an observer for changes.
	if (self.showProgressSummary) {
		[self addSubview:self.progressSummaryView];
		
		[self addObserver:self.progressSummaryView forKeyPath:@"progressTotal" options:NSKeyValueObservingOptionNew context:nil];
		[self addObserver:self.progressSummaryView forKeyPath:@"progressCounter" options:NSKeyValueObservingOptionNew context:nil];
		[self addObserver:self.progressSummaryView forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:nil];
	}
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if (self.progressTotal <= 0) {
        return;
    }
    
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGSize viewSize = self.bounds.size;
	CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
	
    // Draw the slices.
    [self drawSlices:contextRef withViewSize:viewSize andCenter:center];
	
	// Draw the slice separators.
	[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

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
		if (self.progressCounter < self.progressTotal) {
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
}

- (void)drawSlices:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
    CGFloat radius = viewSize.width / 2 - self.internalPadding;
    [self drawSlices:self.progressTotal
		   completed:self.progressCounter
			  radius:radius
			  center:center
		   inContext:contextRef];
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
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
}

- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int innerDiameter = viewSize.width - self.thickness;
    float innerRadius = innerDiameter / 2;
	
	CGContextSetLineWidth(contextRef, self.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.centerColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}

# pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// Re-set the accessibilityValue and the progressSummaryView text.
	float percentageCompleted = (100 / self.progressTotal) * self.progressCounter;
	
	NSString *newValue = [NSString stringWithFormat:@"%.2f", percentageCompleted];
	self.accessibilityValue = newValue;
	
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}

# pragma mark - Setters

- (void)setShowProgressSummary:(BOOL)showProgressSummary
{
	_showProgressSummary = showProgressSummary;
	if (_showProgressSummary && self.progressSummaryView == NULL) {
//		CGFloat radius = (self.bounds.size.width - self.thickness) / 2;
//		CGRect frame = CGRectMake(self.center.x, self.center.y, radius, radius);
		
//		float percentageCompleted = (100 / self.progressTotal) * self.progressCounter;
//		self.progressSummaryView = [[MDRadialProgressLabel alloc] initWithFrame:frame];
//		self.progressSummaryView.textColor = self.completedColor;
//		self.progressSummaryView.text = [NSString stringWithFormat:@"%.2f", percentageCompleted];
	}
	
	self.progressSummaryView.hidden = !_showProgressSummary;
}

# pragma mark - Accessibility

- (UIAccessibilityTraits)accessibilityTraits
{
	return [super accessibilityTraits] | UIAccessibilityTraitUpdatesFrequently;
}

@end
