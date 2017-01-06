//
//  SecondViewController.h
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *contactList;
    NSMutableArray *myList;
    UITableView *myTable;
}

- (float)returnHeight;

@end
