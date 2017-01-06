//
//  SearchContactViewController.h
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 7..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchContactViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *myList;
        NSMutableArray *searchList;
    UITableView *myTable;

    BOOL expanded;
    UILabel *subLabel;
}
@property (nonatomic, strong) NSIndexPath *selectedRowIndex;
@end
