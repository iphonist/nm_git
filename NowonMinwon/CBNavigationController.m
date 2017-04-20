//
//  CBNavigationController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 5. 16..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//
//  Source URL : http://keighl.com/post/ios7-interactive-pop-gesture-custom-back-button/

#import "CBNavigationController.h"

@implementation CBNavigationController

- (void)viewDidLoad
{
//	NSLog(@"CBViewDidLoaded");
	
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
	{
		__weak UINavigationController *weakSelf = self;

		self.interactivePopGestureRecognizer.delegate = weakSelf;
		self.delegate = weakSelf;
	}
}

#pragma mark - Alternative pop method
- (UIViewController *)popViewControllerWithBlockGestureAnimated:(BOOL)animated
{
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
		self.interactivePopGestureRecognizer.enabled = NO;
	
	return [super popViewControllerAnimated:animated];
}


- (NSArray *)popToViewControllerWithBlockGesture:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
		self.interactivePopGestureRecognizer.enabled = NO;
	
	return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerWithBlockGestureAnimated:(BOOL)animated
{
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
		self.interactivePopGestureRecognizer.enabled = NO;
	
	return [super popToRootViewControllerAnimated:animated];
}


#pragma mark - Hijack the push method

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//	NSLog(@"CB PushViewController");
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
		self.interactivePopGestureRecognizer.enabled = NO;
	
	[super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
	// Enable the gesture again once the new controller is shown
//	NSLog(@"CB didShowViewController");
	if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // disable interactivePopGestureRecognizer in the rootViewController of navigationController
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

@end
