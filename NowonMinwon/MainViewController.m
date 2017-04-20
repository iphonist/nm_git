//
//  RootViewController.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "MainViewController.h"
#import "SearchContactViewController.h"
#import "NoticeTableViewController.h"
@implementation MainViewController


- (id)init
{
    self = [super init];
    if (self) {
        
        // Creating the controllers

        self.view.backgroundColor = RGB(237, 240, 245);//[UIColor whiteColor];
        self.title = @"노원구 행정전화번호부";
        
//        NSLog(@"init");
    }
    return self;
}


- (void)goWeb:(id)sender{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mw.nowon.kr/"]];

    
    BOOL isInstalled = [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"NowonMobile://"]];
//    NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
    if(isInstalled){
        
//        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"NowonMobile://"]];
    }
    else{
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/kr/app/seumateunowon/id790141091?mt=8"]];
    }
    
}
- (void)searchContact:(id)sender{
    
    SearchContactViewController *search = [[SearchContactViewController alloc]init];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:search];
    [self presentModalViewController:nc animated:YES];
    [search release];
    [nc release];
}


- (void)viewDidLoad{
    [super viewDidLoad];

//    NSLog(@"viewDidLoad");
//    NSLog(@"viewDidLoad %@ %@",self.navigationController,self.navigationController.navigationBar);
    
    UIButton *button;
    button = [CustomUIKit buttonWithTarget:self selector:@selector(goWeb:) frame:CGRectMake(0, 0,30, 32) imageNamedNormal:@"barbutton_main_goweb.png" imageNamedPressed:@""];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    button = [CustomUIKit buttonWithTarget:self selector:@selector(searchContact:) frame:CGRectMake(0, 0, 41, 41) imageNamedNormal:@"barbutton_main_search.png" imageNamedPressed:@""];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    [btnNavi release];
    
    first = [[FirstViewController alloc]init];
    second = [[SecondViewController alloc]init];
    
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
//    scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrollView];
    scrollView.userInteractionEnabled = YES;
    
    noticeView = [[UIView alloc]initWithFrame:CGRectMake(0,0,scrollView.frame.size.width,0)];
    noticeView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:noticeView];
    
//    UILabel *label = [CustomUIKit labelWithText:@"알림" bold:NO fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(10,5,noticeView.frame.size.width-20,18) numberOfLines:1 alignText:UITextAlignmentLeft];
//    [noticeView addSubview:label];
//    
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.backgroundColor = RGB(216, 221, 228);
//    imageView.frame = CGRectMake(0,label.frame.origin.y + label.frame.size.height+3,noticeView.frame.size.width,1);// = [CustomUIKit createImageViewWithOfFiles:@"imageview_organize_expand_line.png" withFrame:CGRectMake(0,label.frame.origin.y + label.frame.size.height,noticeView.frame.size.width,1)];
//    [noticeView addSubview:imageView];
//    
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_main_notice_accessory.png" withFrame:CGRectMake(7,42,3,3)];
//    [noticeView addSubview:imageView];
//    
//    
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"button_main_notice_disclosure.png" withFrame:CGRectMake(noticeView.frame.size.width-10-10,33,10,18)];
//    [noticeView addSubview:imageView];
    
    segmentedImage = [CustomUIKit createImageViewWithOfFiles:@"button_main_segmented_left_selected.png" withFrame:CGRectMake(0, noticeView.frame.origin.y + noticeView.frame.size.height + 10, 320, 36)];
    [scrollView addSubview:segmentedImage];
    segmentedImage.userInteractionEnabled = YES;

    UIButton *leftButton;
    leftButton = [CustomUIKit buttonWithTarget:self selector:@selector(whichView:) frame:CGRectMake(0, 0, 160, 36) imageNamedNormal:@"" imageNamedPressed:@""];
    leftButton.tag = 1;
    [segmentedImage addSubview:leftButton];
    
    UIButton *rightButton;
    rightButton = [CustomUIKit buttonWithTarget:self selector:@selector(whichView:) frame:CGRectMake(160, 0, 160, 36) imageNamedNormal:@"" imageNamedPressed:@""];
    rightButton.tag = 2;
    [segmentedImage addSubview:rightButton];
    
    
    
    
//    UISegmentedControl *segmentedControl;
//    segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"자주 찾는 민원",@"부서별 찾기",nil]];
//    [segmentedControl setFrame:CGRectMake(30, noticeView.frame.origin.y + noticeView.frame.size.height + 10, scrollView.frame.size.width - 60, 40)];
//    [segmentedControl addTarget:self action:@selector(whichView:) forControlEvents:UIControlEventValueChanged];
//    segmentedControl.selectedSegmentIndex = 0;
//    [scrollView addSubview:segmentedControl];
    
    segmentedView = [[UIView alloc]init];
    segmentedView.frame = CGRectMake(0,
                                     segmentedImage.frame.origin.y + segmentedImage.frame.size.height + 10,
                                     scrollView.frame.size.width, [first returnHeight]);
    segmentedView.userInteractionEnabled = YES;
//    NSLog(@"NSStringFrom %@",NSStringFromCGRect(segmentedView.frame));
    
    [scrollView addSubview:segmentedView];
    
    [segmentedView addSubview:second.view];
    [segmentedView addSubview:first.view];
    first.view.hidden = NO;
    first.view.userInteractionEnabled = YES;
    second.view.hidden = YES;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, segmentedView.frame.origin.y + segmentedView.frame.size.height);

//    NSLog(@"first.view %@",first.view);
}

- (void)setMenu:(NSArray *)array{
    [first setSubview:array];
}


- (void)showNotice:(NSDictionary *)dic{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,64)]autorelease];
    view.backgroundColor = [UIColor blackColor];
//    NSLog(@"dic %@",dic);
    [SharedAppDelegate.window addSubview:view];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTarget:self selector:@selector(fullNotice) frame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageNamedNormal:@"" imageNamedPressed:@""];
    [view addSubview:button];
}
- (void)setNotice:(NSArray *)array{
//    NSLog(@"setNotice %@",array);
//    if(noticeArray){
//        [noticeArray release];
//        noticeArray = nil;
//    }
//    noticeArray = [[NSArray alloc]initWithArray:array];
//    
//    UILabel *label = [CustomUIKit labelWithText:[array[0][@"content"]objectFromJSONString][@"title"] bold:NO fontSize:12 fontColor:RGB(159, 162, 166) frame:CGRectMake(15,33,noticeView.frame.size.width-20-25,20) numberOfLines:1 alignText:UITextAlignmentLeft];
//    [noticeView addSubview:label];
//        NSLog(@"cgrect %@",NSStringFromCGRect(label.frame));
//
//    
//    
//    UIButton *button;
//    button = [CustomUIKit buttonWithTarget:self selector:@selector(fullNotice) frame:CGRectMake(0, 0, noticeView.frame.size.width, noticeView.frame.size.height) imageNamedNormal:@"" imageNamedPressed:@""];
//    [noticeView addSubview:button];
}

- (void)fullNotice{//:(id)sender{
//    int viewY = 0;
//    
//    fullNoticeView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, viewY+10, self.view.frame.size.width - 20, self.view.frame.size.height-viewY-20)];
//    fullNoticeView.backgroundColor = [UIColor blackColor];
//    int contentHeight = 0;
//       for(int i = 0; i < [noticeArray count]; i++){
//           UILabel *label = [CustomUIKit labelWithText:[noticeArray[i][@"content"]objectFromJSONString][@"msg"] bold:NO fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(10,5,fullNoticeView.frame.size.width-20,0) numberOfLines:0 alignText:UITextAlignmentLeft];
//                CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(fullNoticeView.frame.size.width-20, 1000) lineBreakMode:UILineBreakModeWordWrap];
//           NSLog(@"size %@",NSStringFromCGSize(size));
//           label.frame = CGRectMake(10,5+contentHeight,fullNoticeView.frame.size.width-20,size.height);
//    
//           [fullNoticeView addSubview:label];
//           contentHeight += size.height+30;
//           NSLog(@"fullnotice cgrect %@",NSStringFromCGRect(label.frame));
//       }
//    fullNoticeView.contentSize = CGSizeMake(fullNoticeView.frame.size.width, contentHeight);
//    
//    UIButton *button;
//    button = [CustomUIKit buttonWithTarget:self selector:@selector(closeFullNotice:) frame:CGRectMake(fullNoticeView.frame.size.width - 70, 10, 60, 60) imageNamedNormal:@"" imageNamedPressed:@""];
//    button.backgroundColor = [UIColor whiteColor];
//    [fullNoticeView addSubview:button];
//    
//    [SharedAppDelegate.window addSubview:fullNoticeView];
    
    NoticeTableViewController *noticeTable = [[NoticeTableViewController alloc]initWithArray:noticeArray];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:noticeTable];
    [self presentModalViewController:nc animated:YES];
    [noticeTable release];
    [nc release];
}
- (void)closeFullNotice:(id)sender{
    
//    [fullNoticeView removeFromSuperview];
    
}
- (void)whichView:(id)sender{
    
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//    NSLog(@"which? %d",segmentedControl.selectedSegmentIndex);
    
//    NSLog(@"FIRST %@ second %@",first,second);
    if([sender tag] == 1){
        first.view.hidden = NO;
        first.view.userInteractionEnabled = YES;
        second.view.hidden = YES;
        segmentedView.frame = CGRectMake(0,
                                         segmentedImage.frame.origin.y + segmentedImage.frame.size.height + 10,
                                         scrollView.frame.size.width, [first returnHeight]);
        segmentedImage.image = [CustomUIKit customImageNamed:@"button_main_segmented_left_selected.png"];
 
    }
    else{
        first.view.hidden = YES;
        second.view.hidden = NO;
        second.view.userInteractionEnabled = YES;
        segmentedView.frame = CGRectMake(0,
                                         segmentedImage.frame.origin.y + segmentedImage.frame.size.height + 10,
                                         scrollView.frame.size.width, [second returnHeight]+70);
        segmentedImage.image = [CustomUIKit customImageNamed:@"button_main_segmented_right_selected.png"];
        
    }
//    NSLog(@"segmentedview %@",NSStringFromCGRect(segmentedView.frame));
//    second.view.backgroundColor = [UIColor blackColor];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, segmentedView.frame.origin.y + segmentedView.frame.size.height);
//    NSLog(@"scrollView.contentSize %@",NSStringFromCGSize(scrollView.contentSize));
    
}

@end
