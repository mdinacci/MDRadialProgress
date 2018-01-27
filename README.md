# MDRadialProgress

A custom UIView useful to represent progress in discrete steps. 

It has the following features:

* Draw progress in separated slices or as a single arc.
* Can customize all colors, the distance of the slices and their thickness. 
* Clockwise and anti-clockwise drawing order.
* Can start progress from any slice, not necessarily from the top.
* Display a label with the current progress. The label size automatically adapts to the space available. The label can be customised with a block (new in 1.0.5)
* Themes support for easier customization of multiple views.
* Indeterminate mode
* Fully accessible
* Support iOS 6.0+
* BSD licensed.


![Screenshot](screenshot.png "Screenshot")

![Indeterminate mode animation](https://cloud.githubusercontent.com/assets/7833300/4783674/223a17ea-5d31-11e4-8671-3e648e23a7c7.gif "Indeterminate mode")

## Documentation

### Installation

Either use CocoaPods by adding the line below to your _Podfile_:

```
pod 'MDRadialProgress'
```

or copy `MDRadialProgress.{h|m}`, `MDRadialProgressLabel.{h|m}`, `MDRadialProgressTheme.{h|m}` into your project.

### Usage

There is an extensive example included in `ViewController.m`. Tweak it and run it to experiment. 

**See the RELEASE_NOTES for changes between versions.**

Version 1.0 has introduced the concept of *theme* in order to make the customisation of many progress views
simpler. If for example you have a table where in every cell you have a MDRadialProgressView, now you
can create a theme with the appearance you like and apply it to all views, instead of customising
each view singularly.

### Dependencies
Remember to add the QuartzCore framework provided with Xcode or simply import it with `#import <QuartzCore/QuartzCore.h>` when you want to use
the indeterminate mode feature of MDRadialProgress.

## Localization
The component is fully accessible and it uses two labels that can be used by
VoiceOver to speak the current progress value to the user. 
If you want to provide localized text messages translate these two labels in your Localization.strings files:

"Progress",
"Progress changed to:"

## License
The License is now BSD (https://opensource.org/licenses/BSD-3-Clause).

## Contributors
See the [Contributors page](https://github.com/mdinacci/MDRadialProgress/graphs/contributors) on github.

