# RNActivityView

RNActivityView is based on [MBProgressHUD](https://github.com/jdg/MBProgressHUD). All credits to [MBProgressHUD](https://github.com/jdg/MBProgressHUD).


Was designed to facilitate the calls, especially on large projects.


[MBProgressHUD](https://github.com/jdg/MBProgressHUD) is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread. The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD with some additional features. 

The differential is RNActivityView which has a category (extension to UIView) to facilitate the use of the component. Decreases the work of getting instantiating and configuring component for simple uses.

[![](https://cloud.githubusercontent.com/assets/91322/26737574/95128ef6-477f-11e7-8b3a-456b2b585e75.png)](https://cloud.githubusercontent.com/assets/91322/26737572/94a137a6-477f-11e7-9778-6266006f2dba.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737576/951cc0c4-477f-11e7-9bc4-891cbbe70f80.png)](https://cloud.githubusercontent.com/assets/91322/26737575/95178c6c-477f-11e7-8df9-03aeeca5d39d.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737577/9523169a-477f-11e7-83d9-c1a55b724c0a.png)](https://cloud.githubusercontent.com/assets/91322/26737578/95235920-477f-11e7-9968-9ecf506aba06.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737579/954371ce-477f-11e7-85f8-660807a7f35e.png)](https://cloud.githubusercontent.com/assets/91322/26737573/95048432-477f-11e7-8f1d-4d5736b10488.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737581/954e3c9e-477f-11e7-93d9-2a8e2e0e7dd0.png)](https://cloud.githubusercontent.com/assets/91322/26737580/954aff70-477f-11e7-9634-5802daea2dee.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737583/955ba17c-477f-11e7-93aa-d952fb0bbce3.png)](https://cloud.githubusercontent.com/assets/91322/26737582/9552886c-477f-11e7-8e90-46acd9a8527c.png)
[![](https://cloud.githubusercontent.com/assets/91322/26737585/95a31822-477f-11e7-9ca6-b33ceb3a3f49.png)](https://cloud.githubusercontent.com/assets/91322/26737584/956392f6-477f-11e7-918f-717a42758156.png)

## Requirements

RNActivityView works on iOS 7+ and requires ARC to build. Works fine on Objective-C and Swift.

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

## Apps using this control
[Zee - Personal Finances](https://itunes.apple.com/us/app/id422694086).
[BirdLight](https://itunes.apple.com/us/app/birdlight/id1281370890?mt=8).


