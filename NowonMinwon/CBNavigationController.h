//
//  CBNavigationController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 5. 16..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBNavigationController : UINavigationController <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

- (UIViewController *)popViewControllerWithBlockGestureAnimated:(BOOL)animated;
- (NSArray *)popToViewControllerWithBlockGesture:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToRootViewControllerWithBlockGestureAnimated:(BOOL)animated;

@end
