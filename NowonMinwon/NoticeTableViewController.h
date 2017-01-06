//
//  NoticeTableViewController.h
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 14..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewController : UITableViewController{
    NSMutableArray *myList;
}

- (id)initWithArray:(NSMutableArray *)array;

@end
