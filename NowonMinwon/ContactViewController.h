//
//  ContactViewController.h
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 7..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    
    NSMutableArray *myList;
    UITableView *myTable;
    
    UILabel *titleLabel;
}

- (void)settingList:(NSArray *)array withTitle:(NSString *)title;

@end
