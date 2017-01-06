//
//  RootViewController.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 22..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "OrganizeViewController.h"
#import "CallManager.h"
#import "ContactViewController.h"

@interface RootViewController : UIViewController{
    
	SystemSoundID ringSound;
    OrganizeViewController *organize;
}

@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) OrganizeViewController *organize;
@property (nonatomic, strong) CallManager *callManager;
@property (nonatomic, strong) ContactViewController *contact;


- (void)settingMain;
- (void)settingLogin;

- (void)playRingSound;
- (void)stopRingSound;
- (void)setAudioRoute:(BOOL)speaker;
- (NSString *)getPureNumbers:(NSString *)originalString;


@end
