//
//  FirstViewController.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FirstViewController : UIViewController<MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>{
    UIScrollView *scrollView;
}


- (float)returnHeight;

@end
