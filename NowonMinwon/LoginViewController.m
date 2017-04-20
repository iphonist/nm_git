//
//  LoginViewController.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 22..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "LoginViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/sysctl.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


#define kPhonenumber 1
#define kVaricode 2
#define kRequestvaricode 3
#define kRequestvaricodeAgain 4

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self inputPhoneNumber];
}

- (void)inputPhoneNumber{
    if(transView){
        [transView removeFromSuperview];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:transView];
    
    
    UILabel *titleLabel;
    titleLabel = [CustomUIKit labelWithText:@"전화번호 인증" bold:YES fontSize:20 fontColor:RGB(70, 97, 168) frame:CGRectMake(0,40,self.view.frame.size.width,30) numberOfLines:1 alignText:UITextAlignmentCenter];
    [transView addSubview:titleLabel];
    
    UILabel *subLabel;
    subLabel = [CustomUIKit labelWithText:@"휴대전화번호를 입력해 주세요.\n'확인'을 누르면 입력하신 번호로 인증\n번호가 발송됩니다." bold:NO fontSize:16 fontColor:RGB(140, 140, 140) frame:CGRectMake(25, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, self.view.frame.size.width - 50, 70) numberOfLines:3 alignText:UITextAlignmentLeft];
    [transView addSubview:subLabel];
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, subLabel.frame.origin.y + subLabel.frame.size.height + 10, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_emptyfield_background.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    _textField = [CustomUIKit textFieldWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6) keyboardType:UIKeyboardTypeNumberPad placeholder:@"" text:@"" clearButtonMode:UITextFieldViewModeAlways];
    _textField.delegate = self;
    _textField.tag = kPhonenumber;
    [textFieldImageView addSubview:_textField];
    [_textField becomeFirstResponder];
    [textFieldImageView release];
    
    okButton = [CustomUIKit buttonWithTarget:self selector:@selector(checkPhoneNumber:) frame:CGRectMake(90, self.view.frame.size.height - 270, 139, 33) imageNamedNormal:@"button_login_done.png" imageNamedPressed:@""];
    okButton.tag = kRequestvaricode;
    [transView addSubview:okButton];
    okButton.enabled = NO;
    
    
//    UILabel *label;
//    label = [CustomUIKit labelWithText:@"확인" bold:YES fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,okButton.frame.size.width,okButton.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [okButton addSubview:label];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
 
    

    if(textField.tag == kPhonenumber){
	if (newLength > 10) {
        okButton.enabled = YES;
        if(newLength > 11)
            return NO;
	}
    else{
        okButton.enabled = NO;
    }
    }
    else if(textField.tag == kVaricode){
        if (newLength > 0) {
            okButton.enabled = YES;
            if(newLength > 11)
                return NO;
        }
        else{
            okButton.enabled = NO;
        }
    }

	return YES;
}
- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    okButton.enabled = NO;
    
    return YES;
}

- (void)checkPhoneNumber:(id)sender{
    
    if(![_textField.text hasPrefix:@"01"]){
        [CustomUIKit popupAlertViewOK:@"" msg:@"정확한 전화번호를 입력하세요."];
        _textField.text = nil;
        return;
    }
    
    [self requestVaricode:sender];
}
- (void)requestVaricode:(id)sender{
    
    
    // connection code
    [SharedAppDelegate writeToPlist:@"phone_number" value:_textField.text];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"https://nowon.lemp.co.kr"]]];//[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                            _textField.text,@"cellphone",
                           oscode,@"oscode",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/nowon/minwon_register.lemp" parametersJson:jsonString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
//            if([sender tag] == kRequestvaricode){
//                
//                [self inputVaricode];
//            }
//            else if([sender tag] == kRequestvaricodeAgain){
            
                [self inputVaricode];
//            }
//            else{
//                
//            }
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
//            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    

    
}

- (void)inputVaricode{
    
//    NSLog(@"inputVariCode");
    
    if(transView){
        [transView removeFromSuperview];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:transView];
    
    UILabel *titleLabel;
    titleLabel = [CustomUIKit labelWithText:@"전화번호 인증" bold:YES fontSize:20 fontColor:RGB(70, 97, 168) frame:CGRectMake(0,40,self.view.frame.size.width,30) numberOfLines:1 alignText:UITextAlignmentCenter];
    [transView addSubview:titleLabel];
    
    
    UILabel *subLabel;
    subLabel = [CustomUIKit labelWithText:@"인증번호를 입력해 주세요." bold:NO fontSize:16 fontColor:RGB(140, 140, 140) frame:CGRectMake(25 + 15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, self.view.frame.size.width - 50, 25) numberOfLines:1 alignText:UITextAlignmentLeft];
    [transView addSubview:subLabel];
   
    
    UIImageView *accessory = [[UIImageView alloc]initWithFrame:CGRectMake(25, subLabel.frame.origin.y + 10, 6, 6)]; // 180
    accessory.image = [CustomUIKit customImageNamed:@"imageview_main_notice_accessory.png"];
    [transView addSubview:accessory];
    [accessory release];

//    subLabel = [CustomUIKit labelWithText:@"인증번호 재발송" bold:NO fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(25 + 100, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20 + 20, self.view.frame.size.width - 50 - 100, 20) numberOfLines:1 alignText:UITextAlignmentRight];
//    [transView addSubview:subLabel];
    
//    UIButton *button;
//    button = [CustomUIKit buttonWithTarget:self selector:@selector(requestVaricode:) frame:subLabel.frame imageNamedNormal:@"" imageNamedPressed:@""];
//    button.tag = kRequestvaricodeAgain;
//        [transView addSubview:button];
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, subLabel.frame.origin.y + subLabel.frame.size.height + 10, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"imageview_emptyfield_background.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
    
    _variCodeTextField = [CustomUIKit textFieldWithFrame:CGRectMake(8, 4, textFieldImageView.frame.size.width - 12, textFieldImageView.frame.size.height - 6) keyboardType:UIKeyboardTypeNumberPad placeholder:@"" text:@"" clearButtonMode:UITextFieldViewModeAlways];
    _variCodeTextField.delegate = self;
    _variCodeTextField.tag = kVaricode;
    [textFieldImageView addSubview:_variCodeTextField];
    [textFieldImageView release];
    [_variCodeTextField becomeFirstResponder];
    
    float gap = 10;
    if(IS_HEIGHT568)
        gap = 20;
    
    requestButton = [CustomUIKit buttonWithTarget:self selector:@selector(requestVaricode:) frame:CGRectMake(106, textFieldImageView.frame.origin.y + textFieldImageView.frame.size.height + gap, 107, 50) imageNamedNormal:@"button_login_requestvaricode_off.png" imageNamedPressed:@""];
    requestButton.tag = kRequestvaricodeAgain;
    [transView addSubview:requestButton];
    requestButton.enabled = NO;
    
    sec = 60;
    timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, requestButton.frame.size.width, 20)];
    timerLabel.font = [UIFont systemFontOfSize:15];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.text = @"1:00";
    timerLabel.textColor = [UIColor grayColor];
    timerLabel.textAlignment = UITextAlignmentCenter;
    timerLabel.numberOfLines = 1;
    [requestButton addSubview:timerLabel];
    
//    NSLog(@"minuteTimer %@",minuteTimer);
    
    if (minuteTimer && [minuteTimer isValid]) {
//        NSLog(@"1");
        [minuteTimer invalidate];
        minuteTimer = nil;
    }
    
//    NSLog(@"2");
    
    minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(callTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
//    NSLog(@"3");
    
    
    gap = 15;
    if(IS_HEIGHT568)
        gap = 0;
    
    
    UIButton *beforeButton;
    beforeButton = [CustomUIKit buttonWithTarget:self selector:@selector(inputPhoneNumber) frame:CGRectMake(28, self.view.frame.size.height - 280 + 10 + gap, 127, 33) imageNamedNormal:@"button_login_before.png" imageNamedPressed:@""];
    [transView addSubview:beforeButton];
//    
//    UILabel *label;
//    label = [CustomUIKit labelWithText:@"이전" bold:YES fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,beforeButton.frame.size.width,beforeButton.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [beforeButton addSubview:label];
    
    okButton = [CustomUIKit buttonWithTarget:self selector:@selector(checkVaricode:) frame:CGRectMake(28 + 127 + 10, beforeButton.frame.origin.y, 127, 33) imageNamedNormal:@"button_login_next.png" imageNamedPressed:@""];
    [transView addSubview:okButton];
    okButton.enabled = NO;
//    
//    label = [CustomUIKit labelWithText:@"다음" bold:YES fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,okButton.frame.size.width,okButton.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [okButton addSubview:label];
    
    
//    NSLog(@"4");
    
    
}

- (void)callTimer:(NSTimer *)_timer{
//    NSLog(@"timer on");
    
    --sec;
    timerLabel.text = [NSString stringWithFormat:@"00:%02d",sec];
    
    if(sec < 1){
        requestButton.enabled = YES;
        [requestButton setBackgroundImage:[UIImage imageNamed:@"button_login_requestvaricode_on.png"] forState:UIControlStateNormal];
        
        if (minuteTimer && [minuteTimer isValid]) {
            [minuteTimer invalidate];
            minuteTimer = nil;
        }
        
        return;
    }
}
- (void)checkVaricode:(id)sender{
//    NSLog(@"checkvaricode");
    // connection

    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"https://nowon.lemp.co.kr"]]];//[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
//    NSLog(@"client %@",client);
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           _textField.text,@"cellphone",
                           _variCodeTextField.text,@"verifykey",
                           nil];
    
    
//    NSLog(@"param %@",param);
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/nowon/minwon_certificate.lemp" parametersJson:jsonString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            if (minuteTimer && [minuteTimer isValid]) {
                [minuteTimer invalidate];
                minuteTimer = nil;
                
            }
            [self install];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
//            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            _variCodeTextField.text = nil;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    [operation start];
    

    
}

- (void)install{
    
    if(transView){
        [transView removeFromSuperview];
        transView = nil;
    }
    
    transView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:transView];
    
    [SVProgressHUD showWithStatus:@"정보를 받아오는 중..."];
    
    CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size + 4);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine]; //1.2 add
    free(machine);
    
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *osver = [dev systemVersion];
    NSString *devicetoken = [SharedAppDelegate readPlist:@"devicetoken"];
    if(devicetoken == nil || [devicetoken length]<1){
        [SharedAppDelegate writeToPlist:@"devicetoken" value:@"dummydeviceid"];
        devicetoken = @"dummydeviceid";
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"https://nowon.lemp.co.kr"]]];//[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           _textField.text,@"phone_number",
                           oscode,@"oscode",
                           devicetoken,@"deviceid",
                           platform,@"devicemodel",
                           osver,@"osver",
                           [carrier mobileCountryCode]?[carrier mobileCountryCode]:@"000",@"mcc",
                           [carrier mobileNetworkCode]?[carrier mobileNetworkCode]:@"00",@"mnc",
                           @"nowon_minwon",@"app",
                           [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],@"appver",
                           nil];
    
//    NSLog(@"param %@",param);
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
//    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/nowon/minwon_install.lemp" parametersJson:jsonString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate writeToPlist:@"sessionkey" value:resultDic[@"sessionkey"]];
            [SharedAppDelegate writeToPlist:@"lastupdate" value:@"0000-00-00 00:00:00"];
            [SharedAppDelegate.root startup];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
//            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
         
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
//        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
    }];
    
    [operation start];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
