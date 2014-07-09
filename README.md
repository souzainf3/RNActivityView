# RNActivityView

RNActivityView is based on [MBProgressHUD](https://github.com/jdg/MBProgressHUD). All credits to this. 

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

## Usage

The main guideline you need to follow when dealing with MBProgressHUD while running long-running tasks is keeping the main thread work-free, so the UI can be updated promptly. The recommended way of using MBProgressHUD is therefore to set it up on the main thread and then spinning the task, that you want to perform, off onto a new thread. 

```objective-c
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
	// Do something...
	dispatch_async(dispatch_get_main_queue(), ^{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	});
});
```

If you need to configure the HUD you can do this by using the MBProgressHUD reference that showHUDAddedTo:animated: returns. 

```objective-c
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
hud.mode = MBProgressHUDModeAnnularDeterminate;
hud.labelText = @"Loading";
[self doSomethingInBackgroundWithProgressCallback:^(float progress) {
	hud.progress = progress;
} completionCallback:^{
	[hud hide:YES];
}];
```

UI updates should always be done on the main thread. Some MBProgressHUD setters are however considered "thread safe" and can be called from background threads. Those also include `setMode:`, `setCustomView:`, `setLabelText:`, `setLabelFont:`, `setDetailsLabelText:`, `setDetailsLabelFont:` and `setProgress:`.

If you need to run your long-running task in the main thread, you should perform it with a slight delay, so UIKit will have enough time to update the UI (i.e., draw the HUD) before you block the main thread with your task.

```objective-c
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
	// Do something...
	[MBProgressHUD hideHUDForView:self.view animated:YES];
});
```

You should be aware that any HUD updates issued inside the above block won't be displayed until the block completes.

For more examples, including how to use MBProgressHUD with asynchronous operations such as NSURLConnection, take a look at the bundled demo project. Extensive API documentation is provided in the header file (MBProgressHUD.h).

