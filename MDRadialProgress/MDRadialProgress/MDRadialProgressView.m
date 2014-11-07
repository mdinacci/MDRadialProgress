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

// Stores whatever value the progress counter had before the indeterminate mode
// animation so that after indeterminate mode is over the progress view can return
// to its previous state.
@property (assign, nonatomic) NSUInteger progressCounterTemp;

// Stores whatever value the progress label had before the indeterminate mode
// animation so that after indeterminate mode is over the progress view can return
// to its previous state.
@property (strong, nonatomic) MDRadialProgressLabel *labelTemp;

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

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
    if (self) {
		[self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
    }
	
	return self;
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
    self.labelTemp = [[MDRadialProgressLabel alloc] initWithFrame:self.bounds andTheme:self.theme];
	[self addSubview:self.label];
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	
	// Important to avoid showing artifacts
	self.backgroundColor = [UIColor clearColor];

	// Register the progress label for changes
	for (NSString *keyToObserve in [self themePropertiesToObserve]) {
		[self addObserver:self.label forKeyPath:keyToObserve options:NSKeyValueObservingOptionNew context:nil];
	}
}

- (CGSize)intrinsicContentSize
{
    return self.frame.size;
}

- (void)dealloc
{
	for (NSString *observedKey in [self themePropertiesToObserve]) {
	    [self removeObserver:self.label forKeyPath:observedKey];
	}
}

#pragma mark - Setters

- (void)setTheme:(MDRadialProgressTheme *)aTheme
{
	_theme = aTheme;

	[self setNeedsDisplay];
}

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

- (void)setIsIndeterminateProgress:(BOOL)isIndeterminateProgress
{
    _isIndeterminateProgress = isIndeterminateProgress;

    if(_isIndeterminateProgress){
        self.labelTemp.text = self.label.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = @"";
        });
        [self startAnimationForIndeterminateMode];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = self.labelTemp.text;
        });
        [self stopAnimationForIndeterminateMode];
    }
}


# pragma mark - Indeterminate Mode ANimations

- (void) startAnimationForIndeterminateMode
{
    // store progress counter value for use at the end of animation
    self.progressCounterTemp = self.progressCounter;
    
    // Change progress counter value to value reasonably suited or indeterminate animation
    self.progressCounter = (int)(0.18181818 * (float)_progressTotal);
    
    // Spin forever .. or at least until we stop it
    [self runSpinAnimationOnView:self duration:10 rotations:1 repeat:HUGE_VALF];
}

- (void) stopAnimationForIndeterminateMode
{
    // stop spinning animation
    [self.layer removeAnimationForKey:@"rotationAnimation"];
    
    // return progress counter to the vaue it had before the animation
    self.progressCounter = self.progressCounterTemp;
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGSize viewSize = self.bounds.size;
	CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
	
	// Always attempt to draw, even if there is no progress because one might want to display the empty progress.
	// See issue #17 https://github.com/mdinacci/MDRadialProgress/issues/17
	double radius = MIN(viewSize.width, viewSize.height) / 2 - self.internalPadding;
	[self drawSlicesWithRadius:radius center:center inContext:contextRef];
	
	// Draw the slice separators, unless the sliceDividerHidden property is true.
	if (! self.theme.sliceDividerHidden) {
		[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
	}
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

- (void)drawSlicesWithRadius:(double)circleRadius
					  center:(CGPoint)center
				   inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
    NSUInteger startingSlice = self.startingSlice -1;
    
	// If there's no progress, just draw the incomplete arc.
	if (self.progressCounter == 0 && self.theme.drawIncompleteArcIfNoProgress) {
		[self drawArcInContext:context
						center:center
						radius:circleRadius
					startAngle:0
					  endAngle:M_PI * 2
						 color:self.theme.incompletedColor.CGColor
					 clockwise:cgClockwise];
		return;
	}
	
	if (! self.theme.sliceDividerHidden && self.theme.sliceDividerThickness > 0) {
		// Draw one arc at a time.
        
        double sliceAngle = (2 * M_PI ) / self.progressTotal;
        for (int i =0; i < self.progressTotal; i++) {
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
            
            if (i < self.progressCounter) {
                color = self.theme.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    } else {
		// Draw just two arcs, one for the completed slices (if any) and one for the
		// uncompleted ones.
		
        double originAngle, endAngle;
		double sliceAngle = (2 * M_PI) / self.progressTotal;
		double startingAngle = sliceAngle * startingSlice;
		double progressAngle = sliceAngle * self.progressCounter;
		
		if (self.clockwise) {
			originAngle = -M_PI_2 + startingAngle;
			endAngle = originAngle + progressAngle;
		} else {
			originAngle = -M_PI_2 - startingAngle;
			endAngle = originAngle - progressAngle;
		}
		
		// Draw the arcs grouped instead of individually to avoid
		// artifacts between one slice and another.
		
		// Completed slices.
		[self drawArcInContext:context
						center:center
						radius:circleRadius
					startAngle:originAngle
					  endAngle:endAngle
						 color:self.theme.completedColor.CGColor
					 clockwise:cgClockwise];
		
		if (self.progressCounter < self.progressTotal) {
			// Incompleted slices
			[self drawArcInContext:context
							center:center
							radius:circleRadius
						startAngle:endAngle
						  endAngle:originAngle
							 color:self.theme.incompletedColor.CGColor
						 clockwise:cgClockwise];
		}
	}
}

- (void)drawArcInContext:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle
				endAngle:(CGFloat)endAngle color:(CGColorRef)color clockwise:(BOOL)cgClockwise
{
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, center.x, center.y);
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, cgClockwise);
	CGContextSetFillColorWithColor(context, color);
	CGContextFillPath(context);
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int outerDiameter = MIN(viewSize.width, viewSize.height);
    double outerRadius = outerDiameter / 2.0 - self.internalPadding;
    int innerDiameter = (outerDiameter - self.theme.thickness);
    double innerRadius = innerDiameter / 2.0;
	int sliceCount = (int)self.progressTotal;
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
	int innerDiameter = MIN(viewSize.width, viewSize.height) - self.theme.thickness;
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
	
    NSString *text;
	
    if (self.labelTextBlock) {
        text = self.labelTextBlock(self);
    } else {
        float percentageCompleted = (100.0f / self.progressTotal) * self.progressCounter;
        text = [NSString stringWithFormat:@"%.0f", percentageCompleted];
    }
	
	self.accessibilityValue = text;
	self.label.text = text;
	
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}

- (NSArray *)themePropertiesToObserve
{
	return [NSArray arrayWithObjects:
		keyTheme, keyThickness, keyFrame, keyLabelColor, keyDropLabelShadow,
		keyLabelShadowColor, keyLabelShadowOffset, keyFont, nil];
}

@end
