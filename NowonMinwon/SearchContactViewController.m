//
//  SearchContactViewController.m
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 7..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "SearchContactViewController.h"
#import <objc/runtime.h>


const char alertNumber;


@interface SearchContactViewController ()

@end

@implementation SearchContactViewController

@synthesize selectedRowIndex;

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)close:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button;
    button = [CustomUIKit emptyButtonWithTitle:@"xclosebtn.png" target:self selector:@selector(close:)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    self.view.backgroundColor = RGB(241, 241, 241);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"검색";
    
    int viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44+20;
    } else {
        viewY = 44;
    }
    
    
    UISearchBar *search;
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(5, viewY+10, 300, 33)];
    search.backgroundColor = [UIColor clearColor];
    search.delegate = self;
//    [search setSearchFieldBackgroundImage:[CustomUIKit customImageNamed:@"imageview_emptyfield_background.png"] forState:UIControlStateNormal];
    search.layer.borderWidth = 1;
    
    search.layer.borderColor = [RGB(241,241,241) CGColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(241,241,241);
        }
    }
    else{
        search.tintColor = RGB(241,241,241);
    }
    search.placeholder = @"";
    [self.view addSubview:search];
    
    
//    UIImageView *searchImage = [[UIImageView alloc]init];
//    searchImage.frame = CGRectMake(search.frame.origin.x + search.frame.size.width + 10, search.frame.origin.y + 4, 21, 21);
//    [self.view addSubview:searchImage];
//    searchImage.image = [CustomUIKit customImageNamed:@"button_searchview_search.png"];
//    [searchImage release];
    
    myList = [[NSMutableArray alloc]initWithArray:[ResourceLoader sharedInstance].contactList];
    searchList = [[NSMutableArray alloc]init];
    myTable = [[UITableView alloc]init];
    myTable.frame = CGRectMake(0, search.frame.origin.y + search.frame.size.height+10, 320, self.view.frame.size.height - (search.frame.origin.y + search.frame.size.height+10));
    myTable.dataSource = self;
    myTable.delegate = self;
    [self.view addSubview:myTable];
    myTable.backgroundColor = [UIColor clearColor];
    [myTable release];
    
//    [search becomeFirstResponder];
    expanded = NO;
    self.selectedRowIndex = nil;
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [myTable setTableFooterView:v];
    [v release];
    
    subLabel = [CustomUIKit labelWithText:@"※ 이름, 전화번호, 업무명으로 검색하세요." bold:NO fontSize:14 fontColor:RGB(135, 134, 135) frame:CGRectMake(15, search.frame.origin.y + search.frame.size.height + 15, 280, 20) numberOfLines:1 alignText:UITextAlignmentLeft];
    [self.view addSubview:subLabel];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}

#pragma mark - searchbar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [searchList removeAllObjects];
    
    
    
    if([searchText length]>0)
    {
        subLabel.hidden = YES;
        NSDictionary *searchDic;
        myTable.userInteractionEnabled = YES;
//        searching = YES;
        
        if([searchText hasPrefix:@"0"] || [searchText hasPrefix:@"1"] || [searchText hasPrefix:@"2"] || [searchText hasPrefix:@"3"] || [searchText hasPrefix:@"4"] || [searchText hasPrefix:@"5"] || [searchText hasPrefix:@"6"] || [searchText hasPrefix:@"7"] || [searchText hasPrefix:@"8"] || [searchText hasPrefix:@"9"]){
            NSLog(@"firstCharacter number");
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = [NSMutableDictionary dictionaryWithDictionary:myList[i]];
                if([[SharedAppDelegate.root getPureNumbers:searchDic[@"officephone"]] rangeOfString:searchText].location != NSNotFound)
                {
//                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [searchList addObject:searchDic];
                    
                }
            }
        }
        else{
            NSLog(@"firstCharacter else");
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = [NSMutableDictionary dictionaryWithDictionary:myList[i]];
                NSString *name = searchDic[@"name"];
                NSString *info = searchDic[@"employeinfo"];
                if(info != nil && [info rangeOfString:searchText].location != NSNotFound)
                {
//                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [searchList addObject:searchDic];
                    
                }
                else if([name rangeOfString:searchText].location != NSNotFound){
                    
//                    searchDic = [NSMutableDictionary dictionaryWithDictionary:searchDic];
                    [searchList addObject:searchDic];
                }
            }
            
        }
    }
    
    else
    {
        subLabel.hidden = NO;
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
        myTable.userInteractionEnabled = NO;
//        searching = NO;
        
    }
    
    [myTable reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    [searchBar setShowsCancelButton:YES animated:YES];
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [searchList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
        if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
        {
            
            NSString *info = searchList[indexPath.row][@"employeinfo"];
            CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
            return 55+size.height+7+33+5;  // info origin y + info size + button + gap
        }
        else
            return 49;
   
    
}



#define kCall 4
#define kMvoip 5

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    //		NSString *email;
    UILabel *name, *team, *info, *officephone;
    UIButton *call, *mvoip;
    UIImageView *arrow, *line;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:17];
        name.tag = 1;
        [cell.contentView addSubview:name];
        [name release];
        
        
        team = [[UILabel alloc]init];
        team.font = [UIFont systemFontOfSize:12];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 2;
        [cell.contentView addSubview:team];
        [team release];
        
        info = [[UILabel alloc]init];
        info.font = [UIFont systemFontOfSize:12];
        info.textColor = [UIColor grayColor];
        info.backgroundColor = [UIColor clearColor];
        info.tag = 3;
        [cell.contentView addSubview:info];
        [info release];
        
        
        
        call = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(0, 0, 0, 0) imageNamedNormal:@"button_organize_call.png" imageNamedPressed:@""];
        call.tag = kCall;
        [cell.contentView addSubview:call];
        
        mvoip = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(0, 0, 0, 0) imageNamedNormal:@"button_organize_mvoip.png" imageNamedPressed:@""];
        mvoip.tag = kMvoip;
        [cell.contentView addSubview:mvoip];
        
        
        officephone = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        officephone.backgroundColor = [UIColor clearColor];
        officephone.font = [UIFont systemFontOfSize:14];
        officephone.textColor = [UIColor grayColor];
        officephone.tag = 6;
        officephone.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:officephone];
        [officephone release];
        
        arrow = [[UIImageView alloc]init];
        arrow.tag = 7;
        [cell.contentView addSubview:arrow];
        [arrow release];
        
        line = [[UIImageView alloc]init];
        line.tag = 8;
        [cell.contentView addSubview:line];
        line.image = [CustomUIKit customImageNamed:@"imageview_organize_expand_line.png"];
        [line release];
        
        
    }
    else{
        name = (UILabel *)[cell viewWithTag:1];
        team = (UILabel *)[cell viewWithTag:2];
        info = (UILabel *)[cell viewWithTag:3];
        call = (UIButton *)[cell viewWithTag:kCall];
        mvoip = (UIButton *)[cell viewWithTag:kMvoip];
        officephone = (UILabel *)[cell viewWithTag:6];
        arrow = (UIImageView *)[cell viewWithTag:7];
        line = (UIImageView *)[cell viewWithTag:8];
    }
    
    
    
    
    arrow.frame = CGRectMake(320-22, 19, 13, 8);
            NSDictionary *dic = searchList[indexPath.row];
            
            name.frame = CGRectMake(10, 5, 150, 20);
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 3, name.frame.size.width, 15);
            team.text = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] searchCode:dic[@"deptcode"]]];
            
            officephone.frame = CGRectMake(320-30-130, 14, 130, 20);
            officephone.text = [NSString stringWithFormat:@"%@",dic[@"officephone"]];
            
            
            if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
            {
                
                line.frame = CGRectMake(0,50,self.view.frame.size.width,1);
                info.text = dic[@"employeinfo"];
                CGSize size = [info.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap]; 
                info.frame = CGRectMake(10, 55, 300, size.height);
                call.frame = CGRectMake(25, info.frame.origin.y + info.frame.size.height + 7, 127, 33);
                mvoip.frame = CGRectMake(call.frame.origin.x + call.frame.size.width + 16, call.frame.origin.y, call.frame.size.width, call.frame.size.height);
                call.titleLabel.text = officephone.text;
                mvoip.titleLabel.text = officephone.text;
                info.hidden = NO;
                call.hidden = NO;
                mvoip.hidden = NO;
                arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_fold.png"];
                
            }
            else{
                line.frame = CGRectMake(0,50,self.view.frame.size.width,0);
                info.hidden = YES;
                call.hidden = YES;
                mvoip.hidden = YES;
                arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_expand.png"];
            }
    
        
   
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

        if(self.selectedRowIndex.row == indexPath.row && expanded){
            NSLog(@"here");
            self.selectedRowIndex = nil;
            expanded = NO;
            
            
            
        }
        else{
            NSLog(@"here expand");
            self.selectedRowIndex = indexPath;
            expanded = YES;
        }
    [self.view endEditing:YES];
        [tableView reloadData];
    
    
    
}
- (void)cmdButton:(id)sender{
    NSString *phonenumber = [[sender titleLabel]text];
    NSLog(@"phonenumber %@",phonenumber);
    
    
    if([sender tag] == kCall){
        
        
        UIAlertView *alert;
        NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 연결하시겠습니까?",phonenumber];
        alert = [[UIAlertView alloc] initWithTitle:@"일반통화" message:msg delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
        objc_setAssociatedObject(alert, &alertNumber, phonenumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
        [alert release];
        
        
    }
    else if([sender tag] == kMvoip){
        [SharedAppDelegate.window addSubview:[SharedAppDelegate.root.callManager setFullOutgoing:phonenumber]];
        //        [SharedAppDelegate.root.callManager mvoipOutgoingWith:phonenumber];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        NSString *number = objc_getAssociatedObject(alertView, &alertNumber);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
        
        
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
