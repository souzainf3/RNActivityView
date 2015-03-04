//
//  UIView+RNActivityView.m
//  HudDemo
//
//  Created by Romilson Nunes on 09/07/14.
//  Copyright (c) 2014 Matej Bukovinski. All rights reserved.
//

#import "UIView+RNActivityView.h"

#import <objc/runtime.h>
#import <objc/message.h>

#define RNLoadingHelperKey @"RNLoadingHelperKey"
#define RNDateLastUpadaKey @"RNDateLastUpadaKey"

@implementation UIView (RNActivityView)

#pragma mark - Setters & Getters

-(RNActivityView *)rn_activityView
{
    RNActivityView *activityView = [self rn_activityViewAssociated];
    if (!activityView)
    {
        activityView = [[RNActivityView alloc] initWithView:self];
        activityView.delegate = self;
        self.rn_activityView = activityView;
        
        [self setRn_activityView:activityView];
    }
    
    if (!activityView.superview)
    {
        [self addSubview:activityView];
    }
    
    return activityView;
}



-(void)setRn_activityView:(RNActivityView *)rn_activityView
{
    RNActivityView *associated_activityView = [self rn_activityViewAssociated];
    
    if (associated_activityView)
    {
        [associated_activityView removeFromSuperview];
        associated_activityView.delegate = nil;
        
        objc_removeAssociatedObjects(associated_activityView);
    }

    objc_setAssociatedObject(self, RNLoadingHelperKey, rn_activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (rn_activityView)
    {
        [self swizzleMethod:NSSelectorFromString(@"didMoveToSuperview") withMethod:@selector(rn_didMoveToSuperview)];
        [self swizzleMethod:NSSelectorFromString(@"willMoveToSuperview") withMethod:@selector(rn_willMoveToSuperview:)];
        [self swizzleMethod:NSSelectorFromString(@"removeFromSuperview") withMethod:@selector(rn_removeFromSuperview)];
    }
}


#pragma mark - Swizzled Methods

- (void) rn_removeFromSuperview
{
    [self destroyActivityView];
    [self rn_removeFromSuperview];
}

- (void)rn_didMoveToSuperview
{
    if (!self.superview || !self.window)
    {
        [self destroyActivityView];
    }
    
    [self rn_didMoveToSuperview];
}

- (void)rn_willMoveToSuperview:(UIView *)newSuperview
{
    
    if (!self.window)
    {
        [self rn_activityViewAssociated].delegate = nil;
        
        [self destroyActivityView];
    }
    
    [self rn_willMoveToSuperview:newSuperview];
}

- (void) destroyActivityView
{
    @synchronized(self)
    {
        if (self.rn_activityViewAssociated)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self.rn_activityViewAssociated];
            self.rn_activityViewAssociated.delegate = nil;
            
            @try
            {
                [self.rn_activityViewAssociated removeFromSuperview];
            }
            @catch (NSException *exception) {}
            
            [self setRn_activityView:nil];
        }
    }
}


-(RNActivityView *) rn_activityViewAssociated
{
    return  objc_getAssociatedObject(self, RNLoadingHelperKey);
}

- (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod([self class],
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod([self class],
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



-(void)showActivityView
{
    [self.rn_activityView show:YES];
}

-(void)showActivityViewWithLabel:(NSString *)text
{
    [self showActivityViewWithLabel:text detailLabel:nil];
}

-(void)showActivityViewWithLabel:(NSString *)text detailLabel:(NSString *)detail
{
    [self showActivityViewWithMode:self.rn_activityView.mode label:text detailLabel:detail];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail;
{
    [self.rn_activityView setupDefaultValues];
    self.rn_activityView.labelText = text;
    self.rn_activityView.detailsLabelText = detail;
    self.rn_activityView.mode = mode;
    self.rn_activityView.dimBackground = YES;
    
    [self showActivityView];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail whileExecuting:(SEL)method onTarget:(id)target
{
    
    [self.rn_activityView setupDefaultValues];
    self.rn_activityView.labelText = text;
    self.rn_activityView.detailsLabelText = detail;
    self.rn_activityView.mode = mode;
    self.rn_activityView.dimBackground = YES;
    
    [self.rn_activityView showWhileExecuting:method onTarget:target withObject:nil animated:YES];
}

-(void)showActivityViewWithMode:(RNActivityViewMode)mode label:(NSString *)text detailLabel:(NSString *)detail whileExecutingBlock:(dispatch_block_t)block
{
    
    [self.rn_activityView setupDefaultValues];
    self.rn_activityView.labelText = text;
    self.rn_activityView.detailsLabelText = detail;
    self.rn_activityView.mode = mode;
    self.rn_activityView.dimBackground = YES;
    
    [self.rn_activityView showAnimated:YES whileExecutingBlock:block];
}


- (void) showActivityViewWithLabel:(NSString *)text image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showActivityViewWithLabel:text customView:imageView];
}


- (void) showActivityViewWithLabel:(NSString *)text customView:(UIView *)view
{
    [self.rn_activityView setupDefaultValues];
    self.rn_activityView.customView = view;
	self.rn_activityView.mode = RNActivityViewModeCustomView;
    self.rn_activityView.labelText = text;
    
    [self showActivityView];
}


- (void) hideActivityView
{
    [self hideActivityViewWithAfterDelay:0];
}

- (void) hideActivityViewWithAfterDelay:(NSTimeInterval)delay
{
    RNActivityView *activityView = [self rn_activityViewAssociated];
    if (activityView)
        [activityView hide:YES afterDelay:delay];
}



#pragma mark -
#pragma mark RNActivityViewDelegate methods

- (void)hudWasHidden:(RNActivityView *)hud
{
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	self.rn_activityView = nil;
}

@end



@implementation UIView (RNActivityViewDeprecated)

#pragma mark -  Getters & Setters

-(RNActivityView *)activityView
{
    return self.rn_activityView;
}

-(void)setActivityView:(RNActivityView *)activityView
{
    self.rn_activityView = activityView;
}



@end
