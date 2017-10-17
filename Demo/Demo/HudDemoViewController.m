
#import "HudDemoViewController.h"
#import <unistd.h>
#import "UIView+RNActivityView.h"

#define SCREENSHOT_MODE 0


@implementation HudDemoViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
	UIView *content = [[self.view subviews] objectAtIndex:0];
#if SCREENSHOT_MODE
	[content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
#endif
	((UIScrollView *)self.view).contentSize = content.bounds.size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIView *content = [[self.view subviews] objectAtIndex:0];
	((UIScrollView *)self.view).contentSize = content.bounds.size;
}


#pragma mark -
#pragma mark IBActions

- (IBAction)showSimple:(id)sender {
	// Return to Default Properties Values
	[self.navigationController.view.rn_activityView setupDefaultValues];
	
	[self.navigationController.view showActivityView];
	[self.navigationController.view hideActivityViewWithAfterDelay:2];
}

- (IBAction)showWithLabel:(id)sender {
	[self.navigationController.view showActivityViewWithLabel:@"Loading"];
	[self.navigationController.view hideActivityViewWithAfterDelay:2];
}

- (IBAction)showWithDetailsLabel:(id)sender {
	
	[self.navigationController.view showActivityViewWithLabel:@"Loading" detailLabel:@"updating data"];
	[self.navigationController.view hideActivityViewWithAfterDelay:2];
}

- (IBAction)showWithLabelDeterminate:(id)sender {
	
	[self.navigationController.view showActivityViewWithMode:RNActivityViewModeDeterminate label:@"Loading" detailLabel:nil whileExecuting:@selector(myProgressTask) onTarget:self];
}

- (IBAction)showWIthLabelAnnularDeterminate:(id)sender {
	
	[self.navigationController.view showActivityViewWithMode:RNActivityViewModeAnnularDeterminate label:@"Loading" detailLabel:nil whileExecuting:@selector(myProgressTask) onTarget:self];
}

- (IBAction)showWithLabelDeterminateHorizontalBar:(id)sender {
	
	[self.navigationController.view showActivityViewWithMode:RNActivityViewModeDeterminateHorizontalBar label:@"Loading" detailLabel:nil whileExecuting:@selector(myProgressTask) onTarget:self];

}

- (IBAction)showWithCustomView:(id)sender {
	
	[self.navigationController.view showActivityViewWithLabel:@"Completed" image:[UIImage imageNamed:@"37x-Checkmark.png"]];
	[self.navigationController.view hideActivityViewWithAfterDelay:3];
	
}

- (IBAction)showWithLabelMixed:(id)sender {
	
	self.navigationController.view.rn_activityView.labelText = @"Connecting";
	self.navigationController.view.rn_activityView.minSize = CGSizeMake(135.f, 135.f);
	
	[self.navigationController.view.rn_activityView showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
	
}

- (IBAction)showUsingBlocks:(id)sender {

	// Setup to Default Properties Values
	[self.navigationController.view.rn_activityView setupDefaultValues];
	
	[self.navigationController.view showActivityViewWithMode:(RNActivityViewModeIndeterminate) label:@"With a block" detailLabel:nil whileExecutingBlock:^{
		[self myProgressTask];
	}];
}

- (IBAction)showOnWindow:(id)sender {
	
	[self.view.window showActivityViewWithLabel:@"Loading"];
	[self.view.window hideActivityViewWithAfterDelay:2];
}

- (IBAction)showURL:(id)sender {
	NSURL *URL = [NSURL URLWithString:@"http://a1408.g.akamai.net/5/1408/1388/2005110403/1a1a1ad948be278cff2d96046ad90768d848b41947aa1986/sample_iPod.m4v.zip"];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
	
	[self.navigationController.view.rn_activityView setupDefaultValues];
	[self.navigationController.view showActivityView];

}


- (IBAction)showWithGradient:(id)sender {
	// Setup default properties values
	[self.navigationController.view.rn_activityView setupDefaultValues];
	self.navigationController.view.rn_activityView.dimBackground = YES;
	
	// Show the HUD while the provided method executes in a new thread
    [self.navigationController.view.rn_activityView showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (IBAction)showTextOnly:(id)sender {
	
	RNActivityView *hud = [RNActivityView showHUDAddedTo:self.navigationController.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = RNActivityViewModeText;
	hud.labelText = @"Some message...";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}

- (IBAction)showWithColor:(id)sender{
	
	// Set the hud to display with a color
	self.navigationController.view.rn_activityView.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	[self.navigationController.view.rn_activityView showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3);
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.view.rn_activityView.progress = progress;
        });
		usleep(50000);
	}
}

- (void)myMixedTask {
	// Indeterminate mode
	sleep(2);
	// Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.view.rn_activityView.mode = RNActivityViewModeDeterminate;
        self.navigationController.view.rn_activityView.labelText = @"Progress";
    });
	float progress = 0.0f;
	while (progress < 1.0f)
	{
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.view.rn_activityView.progress = progress;
        });
		usleep(50000);
	}
	// Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.view.rn_activityView.mode = RNActivityViewModeIndeterminate;
        self.navigationController.view.rn_activityView.labelText = @"Cleaning up";
    });
	sleep(2);
	// UIImageView is a UIKit class, we have to initialize it on the main thread
	__block UIImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
		imageView = [[UIImageView alloc] initWithImage:image];
        
        self.navigationController.view.rn_activityView.customView = imageView;
        self.navigationController.view.rn_activityView.mode = RNActivityViewModeCustomView;
        self.navigationController.view.rn_activityView.labelText = @"Completed";
	});
	sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
	self.navigationController.view.rn_activityView.mode = RNActivityViewModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	self.navigationController.view.rn_activityView.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.navigationController.view.rn_activityView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	self.navigationController.view.rn_activityView.mode = RNActivityViewModeCustomView;
	[self.navigationController.view hideActivityViewWithAfterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.navigationController.view.rn_activityView hideActivityView];
}


@end
