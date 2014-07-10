# RNActivityView

RNActivityView is based on [MBProgressHUD](https://github.com/jdg/MBProgressHUD). All credits to [MBProgressHUD](https://github.com/jdg/MBProgressHUD).


Was designed to facilitate the calls, especially on large projects. Were refactored and created categories in the implementation of [Zee - Personal Finances](https://itunes.apple.com/us/app/id422694086).


![https://itunes.apple.com/us/app/id422694086](https://raw.githubusercontent.com/souzainf3/RNActivityView/master/Demo/Screens/qrcode.png)


[MBProgressHUD](https://github.com/jdg/MBProgressHUD) is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread. The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD with some additional features. 

The differential is RNActivityView which has a category (extension to UIView) to facilitate the use of the component. Decreases the work of getting instantiating and configuring component for simple uses.

[![](http://dl.dropbox.com/u/378729/MBProgressHUD/1-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/1.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/2-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/2.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/3-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/3.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/4-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/4.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/5-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/5.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/6-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/6.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/7-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/7.png)

## Requirements

RNActivityView requires ARC. 

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework


## Adding RNActivityView to your project

### Cocoapods

1. Add a pod entry for RNActivityView to your Podfile `pod 'RNActivityView'`
2. Install the pod(s) by running `pod install`.
3. Import RNActivityView Category `#import "UIView+RNActivityView.h"`.

## Usage using category (UIView+RNActivityView.h)

Simply call the associated instance. 

```objective-c
[self.view showActivityViewWithLabel:@"Loading"];
[self.view hideActivityViewWithAfterDelay:2];
```

If you need to configure the RNActivityView you can call the associated instance. 

```objective-c
	self.view.activityView.mode = RNActivityViewModeDeterminate;
	self.view.activityView.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		self.view.activityView.progress = progress;
		usleep(50000);
	}
```

Associated object With Blocks

```objective-c
	[self.view showActivityViewWithMode:(RNActivityViewModeIndeterminate) label:@"With a block" detailLabel:nil whileExecutingBlock:^{
		[self myProgressTask];
	}];
```

All other functions can be called directly from the associated instance. No need to manually set a variable for this..

