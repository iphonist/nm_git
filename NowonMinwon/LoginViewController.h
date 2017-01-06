//
//  LoginViewController.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 22..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *_textField;
    UITextField *_variCodeTextField;
    UIView *transView;
    UIButton *okButton;
    UILabel *timerLabel;
    NSTimer *minuteTimer;
    int sec;
    UIButton *requestButton;
}

@end
