//
//  UIView+RNActivityView.m
//  HudDemo
//
//  Created by Romilson Nunes on 09/07/14.
//  Copyright (c) 2014 Matej Bukovinski. All rights reserved.
//

#import "UIView+RNActivityView.h"

#import <objc/runtime.h>

#define RNLoadingHelperKey @"RNLoadingHelperKey"
#define RNDateLastUpadaKey @"RNDateLastUpadaKey"

@implementation UIView (RNActivityView)


-(RNActivityView *)activityView {
    RNActivityView *activityView = objc_getAssociatedObject(self, RNLoadingHelperKey);
    
    if (!activityView) {
        activityView = [[RNActivityView alloc] initWithView:self];
        activityView.delegate = self;
        [self setActivityView:activityView];
    }
    if (!activityView.superview) {
        [self addSubview:activityView];
    }
    return activityView;
}

-(void)setActivityView:(RNActivityView *)activityView {
    objc_setAssociatedObject(self, RNLoadingHelperKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)showActivityView {
    [self.activityView show:YES];
}

-(void)showActivityViewWithLabel:(NSString *)text {
    [self showActivityViewWithLabel:text detailLabel:nil];
}

-(void)showActivityViewWithLabel:(NSString *)text detailLabel:(NSString *)detail {
    [self showActivityViewWithMode:self.activityView.mode label:text detailLabel:detail];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail; {
    
    [self.activityView setupDefaultValues];
    self.activityView.labelText = text;
    self.activityView.detailsLabelText = detail;
    self.activityView.mode = mode;
    self.activityView.dimBackground = YES;
    
    [self showActivityView];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail whileExecuting:(SEL)method onTarget:(id)target {
    
    [self.activityView setupDefaultValues];
    self.activityView.labelText = text;
    self.activityView.detailsLabelText = detail;
    self.activityView.mode = mode;
    self.activityView.dimBackground = YES;

    [self.activityView showWhileExecuting:method onTarget:target withObject:nil animated:YES];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail whileExecutingBlock:(dispatch_block_t)block {
   
    [self.activityView setupDefaultValues];
    self.activityView.labelText = text;
    self.activityView.detailsLabelText = detail;
    self.activityView.mode = mode;
    self.activityView.dimBackground = YES;
    
    [self.activityView showAnimated:YES whileExecutingBlock:block];
}


- (void) showActivityViewWithLabel:(NSString *)text image:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showActivityViewWithLabel:text customView:imageView];
}


- (void) showActivityViewWithLabel:(NSString *)text customView:(UIView *)view {
    [self.activityView setupDefaultValues];
    self.activityView.customView = view;
	self.activityView.mode = RNActivityViewModeCustomView;
    self.activityView.labelText = text;
    
    [self showActivityView];
}


- (void) hideActivityView {
    [self hideActivityViewWithAfterDelay:0];
}

- (void) hideActivityViewWithAfterDelay:(NSTimeInterval)delay {
    [self.activityView hide:YES afterDelay:delay];
}



#pragma mark -
#pragma mark RNActivityViewDelegate methods

- (void)hudWasHidden:(RNActivityView *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	self.activityView = nil;
}



@end
