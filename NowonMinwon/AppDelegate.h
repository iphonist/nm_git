//
//  AppDelegate.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *root;


- (void)writeToPlist:(NSString *)key value:(id)value;
- (id)readPlist:(NSString *)key;

@end
