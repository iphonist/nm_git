//
//  FirstViewController.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "ContactViewController.h"
#import <objc/runtime.h>
//#import "LocalContactViewController.h"


const char alertNumber;

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"viewDidLoad");
    
    
    self.view.backgroundColor = RGB(237, 240, 245);
    
    // Do any additional setup after loading the view.
    
//    UIButton *button = [[UIButton alloc]init];
//    button.frame = CGRectMake();

    
}

- (void)setSubview:(NSArray *)array{
    
    self.view.userInteractionEnabled = YES;
//    NSArray *array = [SharedAppDelegate readPlist:@"menu"];
    int sequence = 0;
    
    
    
// left
    
    UIButton *button0th;
    button0th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(10, 0, 144, 30+100) imageNamedNormal:@"" imageNamedPressed:@""];
    button0th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button0th];
    
    UIImageView *coverimageView;
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_administration_top.png" withFrame:CGRectMake(0,0, button0th.frame.size.width, 30)];
    [button0th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_administration.png" withFrame:CGRectMake(3, 30, 138, button0th.frame.size.height-30)];
    [button0th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_job_middle.png" withFrame:CGRectMake(0, 30, 144, button0th.frame.size.height-30)];
    [button0th addSubview:coverimageView];
    
    UIImageView *imageView;
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(2, button0th.frame.origin.y + button0th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
    
    
//    UILabel *label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button0th.frame.size.width,button0th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button0th addSubview:label];
    
    sequence++;
    
    UIButton *button1st;
    button1st = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button0th.frame.origin.x, button0th.frame.origin.y + button0th.frame.size.height + 21, button0th.frame.size.width, 29+100) imageNamedNormal:@"" imageNamedPressed:@""];
    button1st.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button1st];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_health_top.png" withFrame:CGRectMake(0,0, button1st.frame.size.width, 29)];
    [button1st addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_health.png" withFrame:CGRectMake(3, 29, 138, button1st.frame.size.height-29)];
    [button1st addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_health_middle.png" withFrame:CGRectMake(0, 29, 144, button1st.frame.size.height-29)];
    [button1st addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(2, button1st.frame.origin.y + button1st.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button1st.frame.size.width,button1st.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button1st addSubview:label];
    
    sequence++;

    UIButton *button5th;
    button5th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button1st.frame.origin.x, button1st.frame.origin.y + button1st.frame.size.height + 21, button1st.frame.size.width, 29+58) imageNamedNormal:@"" imageNamedPressed:@""];
    button5th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button5th];

    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_environment_top.png" withFrame:CGRectMake(0,0, button5th.frame.size.width, 29)];
    [button5th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_environment.png" withFrame:CGRectMake(3, 29, 138, button5th.frame.size.height-29)];
    [button5th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_environment_middle.png" withFrame:CGRectMake(0, 29, 144, button5th.frame.size.height-29)];
    [button5th addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(2, button5th.frame.origin.y + button5th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button5th.frame.size.width,button5th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button5th addSubview:label];
    
    sequence++;
    
    UIButton *button6th;
    button6th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button5th.frame.origin.x, button5th.frame.origin.y + button5th.frame.size.height + 21, button5th.frame.size.width, 30+66) imageNamedNormal:@"" imageNamedPressed:@""];
    button6th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button6th];

    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_traffic_top.png" withFrame:CGRectMake(0,0, button6th.frame.size.width, 30)];
    [button6th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_traffic.png" withFrame:CGRectMake(3, 30, 138, button6th.frame.size.height-30)];
    [button6th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_book_middle.png" withFrame:CGRectMake(0, 30, 144, button6th.frame.size.height-30)];
    [button6th addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(2, button6th.frame.origin.y + button6th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button6th.frame.size.width,button6th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button6th addSubview:label];
    
    sequence++;
    
    UIButton *button2nd;
    button2nd = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button0th.frame.origin.x + button0th.frame.size.width + 12, button0th.frame.origin.y, 144, 30+42) imageNamedNormal:@"" imageNamedPressed:@""];
    button2nd.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button2nd];
   
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_nowon_top.png" withFrame:CGRectMake(0,0, button2nd.frame.size.width, 30)];
    [button2nd addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_nowon.png" withFrame:CGRectMake(3, 30, 138, button2nd.frame.size.height-30)];
    [button2nd addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_economy_middle.png" withFrame:CGRectMake(0, 30, 144, button2nd.frame.size.height-30)];
    [button2nd addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(self.view.frame.size.width-157-2, button2nd.frame.origin.y + button2nd.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
    
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button2nd.frame.size.width,button2nd.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button2nd addSubview:label];
    
    sequence++;
    
    UIButton *button3rd;
    button3rd = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button2nd.frame.origin.x, button2nd.frame.origin.y + button2nd.frame.size.height + 21, button2nd.frame.size.width, 30+69) imageNamedNormal:@"" imageNamedPressed:@""];
    button3rd.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button3rd];

    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_economy_top.png" withFrame:CGRectMake(0,0, button3rd.frame.size.width, 30)];
    [button3rd addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_economy.png" withFrame:CGRectMake(3, 30, 138, button3rd.frame.size.height-30)];
    [button3rd addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_traffic_middle.png" withFrame:CGRectMake(0, 30, 144, button3rd.frame.size.height-30)];
    [button3rd addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(self.view.frame.size.width-157-2, button3rd.frame.origin.y + button3rd.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button3rd.frame.size.width,button3rd.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button3rd addSubview:label];
    
    sequence++;
    UIButton *button4th;
    button4th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button3rd.frame.origin.x, button3rd.frame.origin.y + button3rd.frame.size.height + 21, button3rd.frame.size.width, 27+43) imageNamedNormal:@"" imageNamedPressed:@""];
    button4th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button4th];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_welfare_top.png" withFrame:CGRectMake(0,0, button4th.frame.size.width, 27)];
    [button4th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_welfare.png" withFrame:CGRectMake(3, 27, 138, button4th.frame.size.height-27)];
    [button4th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_welfare_middle.png" withFrame:CGRectMake(0, 27, 144, button4th.frame.size.height-27)];
    [button4th addSubview:coverimageView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(self.view.frame.size.width-157-2, button4th.frame.origin.y + button4th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button4th.frame.size.width,button4th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button4th addSubview:label];
    
    
    sequence++;
    UIButton *button7th;
    button7th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button4th.frame.origin.x, button4th.frame.origin.y + button4th.frame.size.height + 21, button4th.frame.size.width, 30+89) imageNamedNormal:@"" imageNamedPressed:@""];
    button7th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button7th];

    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_education_top.png" withFrame:CGRectMake(0,0, button0th.frame.size.width, 30)];
    [button7th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_education.png" withFrame:CGRectMake(3, 30, 138, button7th.frame.size.height-30)];
    [button7th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_administration_middle.png" withFrame:CGRectMake(0, 30, 144, button7th.frame.size.height-30)];
    [button7th addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(self.view.frame.size.width-157-2, button7th.frame.origin.y + button7th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button7th.frame.size.width,button7th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button7th addSubview:label];
    
    sequence++;
    
    UIButton *button8th;
    button8th = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button7th.frame.origin.x, button7th.frame.origin.y + button7th.frame.size.height + 21, button7th.frame.size.width, 21+46) imageNamedNormal:@"" imageNamedPressed:@""];
    button8th.tag = [array[sequence][@"sequence"]intValue];
    [self.view addSubview:button8th];

    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_etc_top.png" withFrame:CGRectMake(0,0, button8th.frame.size.width, 21)];
    [button8th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_etc.png" withFrame:CGRectMake(3, 21, 138, button8th.frame.size.height-21)];
    [button8th addSubview:coverimageView];
    
    coverimageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_education_middle.png" withFrame:CGRectMake(0, 21, 144, button8th.frame.size.height-21)];
    [button8th addSubview:coverimageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_contentshadow.png" withFrame:CGRectMake(self.view.frame.size.width-157-2, button8th.frame.origin.y + button8th.frame.size.height, 157, 21)];
    [self.view addSubview:imageView];
//    label = [CustomUIKit labelWithText:array[sequence][@"dept_cat"] bold:YES fontSize:20 fontColor:[UIColor whiteColor] frame:CGRectMake(0,0,button8th.frame.size.width,button8th.frame.size.height) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [button8th addSubview:label];
    
    UIView *bottomView;
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, button6th.frame.origin.y + button6th.frame.size.height + 21 + 10, self.view.frame.size.width, 105+22+10)];
    bottomView.backgroundColor = RGB(112, 134, 61);
    [self.view addSubview:bottomView];
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"구청 대표번호 :" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0,10,158,15) numberOfLines:1 alignText:UITextAlignmentRight];
    [bottomView addSubview:label];
    
    label = [CustomUIKit labelWithText:@"02-2116-3114" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(165,10,90,15) numberOfLines:1 alignText:UITextAlignmentCenter];
    label.backgroundColor = RGB(83, 109, 26);
    label.layer.cornerRadius = 3.0; // rounding label
    label.clipsToBounds = YES;
    [bottomView addSubview:label];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTarget:self selector:@selector(callNumber:) frame:CGRectMake(165,10,90,15) imageNamedNormal:@"" imageNamedPressed:@""];
    button.titleLabel.text = @"02-2116-3114";
    [bottomView addSubview:button];
    
    label = [CustomUIKit labelWithText:@"보건소 대표번호 :" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0,32,158,15) numberOfLines:1 alignText:UITextAlignmentRight];
    [bottomView addSubview:label];
    
    label = [CustomUIKit labelWithText:@"02-2116-3115" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(165,32,90,15) numberOfLines:1 alignText:UITextAlignmentCenter];
    label.backgroundColor = RGB(83, 109, 26);
    label.layer.cornerRadius = 3.0; // rounding label
    label.clipsToBounds = YES;
    [bottomView addSubview:label];
    
    button = [CustomUIKit buttonWithTarget:self selector:@selector(callNumber:) frame:CGRectMake(165,32,90,15) imageNamedNormal:@"" imageNamedPressed:@""];
    button.titleLabel.text = @"02-2116-3115";
    [bottomView addSubview:button];
    
    label = [CustomUIKit labelWithText:@"보건지소 대표번호 :" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0,54,158,15) numberOfLines:1 alignText:UITextAlignmentRight];
    [bottomView addSubview:label];
    
    label = [CustomUIKit labelWithText:@"02-2116-3116" bold:NO fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(165,54,90,15) numberOfLines:1 alignText:UITextAlignmentCenter];
    label.backgroundColor = RGB(83, 109, 26);
    label.layer.cornerRadius = 3.0; // rounding label
    label.clipsToBounds = YES;
    [bottomView addSubview:label];
    
    button = [CustomUIKit buttonWithTarget:self selector:@selector(callNumber:) frame:CGRectMake(165,54,90,15) imageNamedNormal:@"" imageNamedPressed:@""];
    button.titleLabel.text = @"02-2116-3116";
    [bottomView addSubview:button];

    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_bottom_line.png" withFrame:CGRectMake(0, 85, 320, 1)];
    [bottomView addSubview:imageView];

    
//    label = [CustomUIKit labelWithText:@"친구초대하기" bold:NO fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(50,95,320-100,30) numberOfLines:1 alignText:UITextAlignmentCenter];
//    label.backgroundColor = RGB(143, 144, 146);
//    label.layer.cornerRadius = 3.0; // rounding label
//    label.clipsToBounds = YES;
//    [bottomView addSubview:label];
    
    button = [CustomUIKit buttonWithTarget:self selector:@selector(invite:) frame:CGRectMake((320-147)/2,95,147,35) imageNamedNormal:@"button_invite_friends.png" imageNamedPressed:@""];
    [bottomView addSubview:button];
    
    [bottomView release];
    
    
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_bottomnumber.png" withFrame:CGRectMake(89, 10, 142, 49)];
//    [bottomView addSubview:imageView];
    
    
//    UIButton *button = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(button7th.frame.origin.x, button7th.frame.origin.y + button7th.frame.size.height + 21, button7th.frame.size.width, 21+45) imageNamedNormal:@"" imageNamedPressed:@""];
//        [numberView addSubview:button8th];

    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = [self returnHeight];
    self.view.frame = viewFrame;
}

- (void)invite:(id)sender{
//    NSLog(@"invite");
    
//    LocalContactViewController *localController = [[LocalContactViewController alloc] init];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:localController];
//    [SharedAppDelegate.root.mainViewController presentViewController:nc animated:YES completion:nil];
//    [localController release];
//    [nc release];
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
//    NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = @"노원구 행정전화번호부 설치 URL : http://app.lemp.kr/nowon/";
        controller.recipients = nil;//[NSArray arrayWithObjects:myList[indexPath.row][@"number"], nil];
        controller.messageComposeDelegate = self;
        controller.delegate = self;
        [SharedAppDelegate.root.mainViewController presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"전송을 취소하였습니다."];
//            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"전송을 실패하였습니다."];
//            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
//            NSLog(@"Sent");
            
            break;
        default:
            break;
    }
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)callNumber:(id)sender{
//    NSLog(@"callNumber");
    
    NSString *number = [[sender titleLabel]text];
        
        UIAlertView *alert;
        NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 연결하시겠습니까?",number];
        alert = [[UIAlertView alloc] initWithTitle:@"일반통화" message:msg delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
        objc_setAssociatedObject(alert, &alertNumber, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
        [alert release];
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        NSString *number = objc_getAssociatedObject(alertView, &alertNumber);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
        
        
    }
    
}
- (void)cmdButton:(id)sender{
    
//    NSLog(@"cmdButton %d",(int)[sender tag]);
    NSArray *array = [ResourceLoader sharedInstance].menuList[[sender tag]-1][@"dept_info"];
    NSString *title = [ResourceLoader sharedInstance].menuList[[sender tag]-1][@"dept_cat"];
    [SharedAppDelegate.root.contact settingList:array withTitle:title];
    [SharedAppDelegate.root.mainViewController.navigationController pushViewController:SharedAppDelegate.root.contact animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (float)returnHeight{
//    NSLog(@"first Return height");
    return 30+100+21+29+100+21+29+58+21+30+66+21+10+105+22+10;
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
