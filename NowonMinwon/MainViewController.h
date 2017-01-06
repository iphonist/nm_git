//
//  RootViewController.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface MainViewController : UIViewController{
    UIScrollView *scrollView;
    UIView *segmentedView;
    UIView *noticeView;
     FirstViewController *first;
    SecondViewController *second;
    NSArray *noticeArray;
//    UIScrollView *fullNoticeView;
    UIImageView *segmentedImage;
}


@end
