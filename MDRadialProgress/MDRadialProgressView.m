//
// MDRadialProgressView.m
// MDRadialProgress
//
//
// Copyright (c) 2013 Marco Dinacci. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"


@interface MDRadialProgressView ()

// Padding from the view bounds to the outer circumference of the view.
// Useful because at times the circle may appear "cut" by one or two pixels
// since it's drawing over the view bounds.
@property (assign, nonatomic) NSUInteger internalPadding;

@end


@implementation MDRadialProgressView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:theme];
    }
    return self;
}

- (void)awakeFromNib
{
    [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
}

- (void)dealloc {
    [self removeObserver:self.label forKeyPath:keyThickness];
}

- (void)internalInitWithTheme:(MDRadialProgressTheme *)theme
{
    // Default values for public properties
	self.progressTotal = 1;
	self.progressCounter = 0;
	self.startingSlice = 1;
    self.clockwise = YES;
	
	// Use standard theme by default
	self.theme = theme;
	
	// Init the progress label, even if not visible.
	self.label = [[MDRadialProgressLabel alloc] initWithFrame:self.bounds andTheme:self.theme];
	[self addSubview:self.label];
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	
	// Important to avoid showing artifacts
	self.backgroundColor = [UIColor clearColor];
	
	// Register the progress label for changes in the thickness so that it can be repositioned.
	[self addObserver:self.label forKeyPath:keyThickness options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Setters

- (void)setProgressCounter:(NSUInteger)progressCounter
{
	_progressCounter = progressCounter;
	[self notifyProgressChange];
    
    // setNeedsDisplay needs to be in the main queue to update
	// the drawRect if the caller of this method is in a different queue.
	dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setProgressTotal:(NSUInteger)progressTotal
{
	_progressTotal = progressTotal;
	[self notifyProgressChange];
	
	dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
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
	
	// Draw the slices if there's at least some progress or if, even without progress, the slice dividers are visible.
	if (self.progressCounter > 0 || (self.progressCounter == 0 && ! self.theme.sliceDividerHidden)) {
		double radius = viewSize.width / 2 - self.internalPadding;
		[self drawSlices:self.progressTotal
			   completed:self.progressCounter
				  radius:radius
				  center:center
			   inContext:contextRef];
	}
	
	// Draw the slice separators, unless the sliceDividerHidden property is true.
	if (! self.theme.sliceDividerHidden) {
		[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
	}
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(double)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
    NSUInteger startingSlice = self.startingSlice -1;
    
	if (! self.theme.sliceDividerHidden && self.theme.sliceDividerThickness > 0) {
		// Draw one arc at a time.
        
        double sliceAngle = (2 * M_PI ) / slicesCount;
        for (int i =0; i < slicesCount; i++) {
            double startValue = (sliceAngle * i) + sliceAngle * startingSlice;
            double startAngle, endAngle;
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
            
            CGColorRef color = self.theme.incompletedColor.CGColor;
            
            if (i < slicesCompleted) {
                color = self.theme.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    } else {
		// Draw just two arcs, one for the completed slices and one for the
		// uncompleted ones.
		
        double originAngle, endAngle;
		double sliceAngle = (2 * M_PI) / self.progressTotal;
		double startingAngle = sliceAngle * startingSlice;
		double progressAngle = sliceAngle * self.progressCounter;
		
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
		CGColorRef color = self.theme.completedColor.CGColor;
		CGContextSetFillColorWithColor(context, color);
		CGContextFillPath(context);
		
		if (self.progressCounter < self.progressTotal) {
			// Incompleted slices
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, center.x, center.y);
			double startAngle = endAngle;
			CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
			color = self.theme.incompletedColor.CGColor;
			CGContextSetFillColorWithColor(context, color);
			CGContextFillPath(context);
		}
	}
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int outerDiameter = viewSize.width;
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
	int sliceCount = self.progressTotal;
	double sliceAngle = (2 * M_PI) / sliceCount;
	
	CGContextSetLineWidth(contextRef, self.theme.sliceDividerThickness);
	CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
	CGContextMoveToPoint(contextRef, center.x, center.y);
	
	for (int i = 0; i < sliceCount; i++) {
		CGContextBeginPath(contextRef);
		
		double startAngle = sliceAngle * i - M_PI_2;
		double endAngle = sliceAngle * (i + 1) - M_PI_2;

		// Draw the outer slice arc clockwise.
		CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
		// Draw the inner slice arc in the opposite direction. The separator line is drawn automatically when moving
		// from the point where the outer arc ended to the point where the inner arc starts.
		CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
		CGContextStrokePath(contextRef);
	}
}

- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int innerDiameter = viewSize.width - self.theme.thickness;
    double innerRadius = innerDiameter / 2.0;
	
	CGContextSetLineWidth(contextRef, self.theme.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.theme.centerColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}

# pragma mark - Accessibility

- (UIAccessibilityTraits)accessibilityTraits
{
	return [super accessibilityTraits] | UIAccessibilityTraitUpdatesFrequently;
}

# pragma mark - Notifications

- (void)notifyProgressChange
{
	// Update the accessibilityValue and the progressSummaryView text.
	float percentageCompleted = (100.0f / self.progressTotal) * self.progressCounter;
	
	self.accessibilityValue = [NSString stringWithFormat:@"%.2f", percentageCompleted];
	self.label.text = [NSString stringWithFormat:@"%.0f", percentageCompleted];
	
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}

@end
