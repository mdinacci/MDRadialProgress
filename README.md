# MDRadialProgress

A custom UIView useful to represent progress in discrete steps. 

![Screenshot](screenshot.png "Screenshot")

## Documentation

### Installation

Either use CocoaPods by adding the line below to your _Podfile_:

```
pod MDRadialProgress
```

or copy `MDRadialProgress.{h|m}` into your project.

### Usage

There is an example included in `ViewController.m`. Tweak it and run it to
experiment. 

Here's an explanation of the options available for customisation:

```
CGRect frame = CGRectMake(30, 30, 50, 50);
MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame];

// Total number of steps    
radialView.progressTotal = 5;
// Number of steps completed
radialView.progressCurrent = 2;

// Customisation (see red and blue example in the screenshot above)
radialView.completedColor = [UIColor blueColor];
radialView.incompletedColor = [UIColor redColor];
radialView.thickness = 30;
// Be sure to use the same color for background and sliceDivider to simulate
// the space between one step and another.
radialView.backgroundColor = [UIColor whiteColor];
radialView.sliceDividerColor = [UIColor whiteColor];
// The first and third example uses sliceDividerHidden = YES
radialView.sliceDividerHidden = NO;
radialView.sliceDividerThickness = 1;
```

## License (MIT)
Copyright (c) 2013 Marco Dinacci

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

