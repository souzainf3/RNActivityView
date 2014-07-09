
#import <UIKit/UIKit.h>
#import "RNActivityView.h"

@interface HudDemoViewController : UIViewController {

	long long expectedLength;
	long long currentLength;
}

- (IBAction)showSimple:(id)sender;
- (IBAction)showWithLabel:(id)sender;
- (IBAction)showWithDetailsLabel:(id)sender;
- (IBAction)showWithLabelDeterminate:(id)sender;
- (IBAction)showWIthLabelAnnularDeterminate:(id)sender;
- (IBAction)showWithLabelDeterminateHorizontalBar:(id)sender;
- (IBAction)showWithCustomView:(id)sender;
- (IBAction)showWithLabelMixed:(id)sender;
- (IBAction)showUsingBlocks:(id)sender;
- (IBAction)showOnWindow:(id)sender;
- (IBAction)showURL:(id)sender;

- (void)myTask;
- (void)myProgressTask;
- (void)myMixedTask;

@end

