//
// MDRadialProgressView.h
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

#import <UIKit/UIKit.h>

@class MDRadialProgressTheme;

@interface MDRadialProgressView : UIView

// The total number of steps in the progress view.
@property (assign, nonatomic) NSUInteger progressTotal;

// The number of steps currently completed.
@property (assign, nonatomic) NSUInteger progressCounter;

// Whether the progress is drawn clockwise (YES) or anticlockwise (NO)
@property (assign, nonatomic) BOOL clockwise;

// Whether the current progress should be shown or not
// FIXME a bit redundant since one could use progressSummaryView.hidden
@property (assign, nonatomic) BOOL showProgressSummary;

// The index of the slice where the first completed step is.
@property (assign, nonatomic) NSUInteger startingSlice;

// The progress summary view, visible if showNumericProgress is set to YES
@property (strong, nonatomic) UIView *progressSummaryView;

// The theme currently used
@property (strong, nonatomic) MDRadialProgressTheme *theme;

@end
