//
//  OrganizeViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 12..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "OrganizeViewController.h"
#import <objc/runtime.h>


const char alertNumber;

@implementation OrganizeViewController

@synthesize addArray, selectCodeList;
@synthesize tagInfo;
@synthesize selectedRowIndex;




#define kCall 4
#define kMvoip 5

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (id)init
{
		self = [super init];
		if(self != nil)
		{
            subDeptList = [[NSMutableArray alloc]init];
            selectCodeList = [[NSMutableArray alloc]init];
            addArray = [[NSMutableArray alloc]init];
			subPeopleList = [[NSMutableArray alloc]init];
            subList = [[NSMutableArray alloc]init];
            existDeptDictionary = [[NSDictionary alloc]init];

			
            self.view.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"
            

		}
		return self;
}




#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    //    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 31)];
    //    groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    //    [self.view addSubview:groupNameView];
    //    [groupNameView release];
    
//    NSLog(@"tabbar %f",self.tabBarController.tabBar.frame.size.height);
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 28+search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height-groupNameView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
    
    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 0 - 44);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 0 - 44 - 20);
    
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:myTable];
    
    [self setFirstButton];
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"OrganizeView willAppear %f",self.tabBarController.tabBar.frame.size.height);
//    NSLog(@"addArray %@",self.addArray);
//    NSLog(@"TAGINFO %d",tagInfo);
    
    
    [self reloadCheck];
    myTable.contentOffset = CGPointMake(0,0);
    //    [self setFirstButton];
    //		[myTable reloadData];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"OrganizeView viewWillDisappear");
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"OrganizeView viewDidDisappear");
    [super viewDidDisappear:animated];
}


- (void)checkSameLevel:(NSString *)code
{
//    NSLog(@"checkSamelevel %@",code);
	//			id AppID = [[UIApplication sharedApplication]delegate];
    
    expanded = NO;
    self.selectedRowIndex = nil;
    
	[subDeptList removeAllObjects];
	
	NSMutableArray *tempArray = [[NSMutableArray alloc]init];
	[tempArray setArray:[ResourceLoader sharedInstance].deptList];
//    NSLog(@"tempArray %@",tempArray);
//    NSLog(@"tempArray %d",(int)[tempArray count]);
	for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
	{
        
		if([forDic[@"parentdeptcode"] isEqualToString:code])
		{
			
			[subDeptList addObject:forDic];
		}
	}
//    NSLog(@"subDeptList %@",subDeptList);
    
	for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
	{
		if([forDic[@"deptcode"] isEqualToString:code])
		{
			//                    NSArray *array = [[forDicobjectForKey:@"shortname"] componentsSeparatedByString:@","];
			self.title = forDic[@"deptname"];//[arrayobjectatindex:[array count]-1];
		}
	}
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    [tempArray release];
	[subPeopleList removeAllObjects];
	
	for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++) {
		if([[ResourceLoader sharedInstance].contactList[i][@"deptcode"] isEqualToString:code])
		{
			[subPeopleList addObject:[ResourceLoader sharedInstance].contactList[i]];
		}
	}
    
//    NSLog(@"subpeoplelist %@",subPeopleList);
    
    existDept = [self existDeptNumber:code];
//    NSLog(@"existDept %@",existDept?@"YES":@"NO");
    
    if(existDept){
            expanded = YES;
            self.selectedRowIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [myTable reloadData];
	
    
}


- (void)setFirstButton
{
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
//    self.navigationItem.backBarButtonItem = backButton;
//    [backButton release];
//    NSLog(@"setFirstButton");
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    
    
//    [button release];
    
}

- (void)setFirst:(NSString *)first
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 최상위 타이틀을 세팅한다.
     param - first(NSString *) : 조직도 선택했을 때 첫 타이틀
     연관화면 : 조직도
     ****************************************************************/
    
    firstDept = first;
    self.title = first;
		
}


- (void)reloadCheck
{
	
    return;
    
		UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 31)];
		groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
		[self.view addSubview:groupNameView];
		groupNameView.userInteractionEnabled = YES;
		
		if (scrollView) {
			[scrollView release];
			scrollView = nil;
		}
		scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 31)];
		scrollView.delegate = self;
		[groupNameView addSubview:scrollView];
    
		int w = 0;
		
		UILabel *addName;
		UIButton *addNameImage;
//		UIImageView *pathImage;
		for(int i = 0; i < [self.addArray count]; i++)
		{
				CGSize size = [self.addArray[i] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 31) lineBreakMode:UILineBreakModeWordWrap];
		
            addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(w, 0, size.width + 15, 31)];
            addNameImage.tag = i;
			[addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:addNameImage];
            [addNameImage release];
            scrollView.contentOffset = CGPointMake(w, 31);
				
				
//				pathImage = [[UIImageView alloc]init];
//				pathImage.image = [CustomUIKit customImageNamed:@"arr_ic.png"];
				
				
				if(i == [self.addArray count]-1)
				{
                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_02.png"] forState:UIControlStateNormal];
                    
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_02.png"];
						
						addName =  [CustomUIKit labelWithText:self.addArray[i] bold:NO fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(3, 0, size.width + 10, 31) numberOfLines:1 alignText:UITextAlignmentCenter];
//						pathImage.hidden = YES;
				}
				else
				{
                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_01.png"] forState:UIControlStateNormal];
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
						
						addName = [CustomUIKit labelWithText:self.addArray[i] bold:NO fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(3, 0, size.width + 10, 31) numberOfLines:1 alignText:UITextAlignmentCenter];
//						pathImage.hidden = NO;
				}
				
				 w += addNameImage.frame.size.width + 5;
				
//				pathImage.frame = CGRectMake(16 + w + 27*i, 7, 10, 14);
				
//				[scrollView addSubview:pathImage];
				scrollView.contentSize = CGSizeMake(w - 5, 31);
				[addNameImage addSubview:addName];
//				[addNameImage release];
//				[pathImage release];
				
		}
		[groupNameView release];
}


- (void)warp:(id)sender
{
//    UIButton *button = (UIButton *)sender;
    
    int temp;
    temp = [self.addArray count]-((int)[sender tag]+1);
    for(int i = 0; i < temp; i++)
    {
        [self upTo];
    }
    [self reloadCheck];
    
}

- (void)backTo
{
//    NSLog(@"backTo");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 최상위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    
	[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}
		
- (void)upTo
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 하위단계에서 좌측 상단 버튼을 눌러 상위로 올라올 때.
     연관화면 : 조직도
     ****************************************************************/
    
//    if(pView)
//    {
//        [pView closePopup];
//        pView = nil;
//        [pView release];
//    }
    
//    NSLog(@"taginfo %d",tagInfo);

		if(tagInfo == 0)
		{
//            NSLog(@"0");
//				[CustomUIKit popupAlertViewOK:nil msg:@"최상위 그룹입니다."];
								return;

		}
    else if(tagInfo == 1)
    {
//        NSLog(@"1");
        [self setFirstButton];
//        NSLog(@"2");
        [self setFirst:firstDept];
//        NSLog(@"3");
    }
//    NSLog(@"4");
    myTable.contentOffset = CGPointMake(0, 0);
		
		[self checkSameLevel:self.selectCodeList[[self.selectCodeList count]-1]];
    
//    NSLog(@"5");
		
		
		
		
    tagInfo --;
//    NSLog(@"6");
    [self.selectCodeList removeLastObject];
//    NSLog(@"7");
    [self.addArray removeLastObject];
//    NSLog(@"8");
    [self reloadCheck];
//    NSLog(@"9");
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



//- (void)scrollViewWillBeginDragging:(UIScrollView *)s
//{
//    
//    
//    if([search isFirstResponder])
//    {
////        [self settingDisableViewOverlay:2];
//        [search resignFirstResponder];
//    }
//    				
//}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.


//    if(searching)
//    {
////        double temp = (double)[copyList count]/2;
//        return [copyList count];
//	}
//    else if(tableView == myTable)
//		{   	
//            int temp3 = [subPeopleList count] + [deptList count];
    
//    NSLog(@"numberof");
    int subPeopleListCount = (int)[subPeopleList count];
    
    if(existDept)
        ++subPeopleListCount;
    
    
            return subPeopleListCount + [subDeptList count];
//		}
//    else {
//        return 0;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"heightForRowAtIndexPath");
    int subPeopleListCount = (int)[subPeopleList count];
    
    if(existDept)
        ++subPeopleListCount;
    
    
    if(indexPath.row < subPeopleListCount)
    {
        if(existDept){
            if(indexPath.row == 0){
                
                if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
                {
                    NSString *info = @"";
                    CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
                    return 55+size.height+7+33+5; // info origin y + info size + button + gap
                    
                }
                else{
                    return 49;
                    
                }
                
            }
            else{
                
                NSString *info = subPeopleList[indexPath.row-1][@"employeinfo"];
                
                
                if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
                {
                    CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
                    return 55+size.height+7+33+5; // info origin y + info size + button + gap
                    
                }
                else{
                    return 49;
                    
                }
            }
        }
        else{
            
            NSString *info = subPeopleList[indexPath.row][@"employeinfo"];
            
            
            if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
            {
                CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
                return 55+size.height+7+33+5; // info origin y + info size + button + gap
                
            }
            else{
                return 49;
                
            }
        }
    }
    else{
        
        return 49;
    
    }
    
    return 49;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
//		NSString *email;
    UILabel *name, *info, *officephone;
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
            

//            team = [[UILabel alloc]init];
//            team.font = [UIFont systemFontOfSize:12];
//            team.textColor = [UIColor grayColor];
//            team.backgroundColor = [UIColor clearColor];
//            team.tag = 2;
//            [cell.contentView addSubview:team];
//            [team release];
            
            info = [[UILabel alloc]init];
            info.font = [UIFont systemFontOfSize:12];
            info.textColor = [UIColor grayColor];
            info.backgroundColor = [UIColor clearColor];
            info.tag = 3;
            info.numberOfLines = 0;
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
//            team = (UILabel *)[cell viewWithTag:2];
            info = (UILabel *)[cell viewWithTag:3];
            call = (UIButton *)[cell viewWithTag:kCall];
            mvoip = (UIButton *)[cell viewWithTag:kMvoip];
            officephone = (UILabel *)[cell viewWithTag:6];
            arrow = (UIImageView *)[cell viewWithTag:7];
            line = (UIImageView *)[cell viewWithTag:8];
        }

    int subPeopleListCount = [subPeopleList count];
    
    if(existDept)
        ++subPeopleListCount;
    

//    NSLog(@"subPeopleListCount %d",subPeopleListCount);
        if(indexPath.row < subPeopleListCount)
        {
            arrow.frame = CGRectMake(320-22, 20, 13, 8);
            if(existDept){
                
            if(indexPath.row == 0){
                
                name.frame = CGRectMake(10, 15, 150, 20);
                name.text = @"대표번호";//[NSString stringWithFormat:@"%@",dic[@"name"]];
                
                
                officephone.frame = CGRectMake(320-30-130, 14, 130, 20);
                
                NSString *office = [NSString stringWithFormat:@"%@",existDeptDictionary[@"dept_phone"]];
                officephone.text = office;
        
                if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
                {
                    line.frame = CGRectMake(0,49,self.view.frame.size.width,1);
                    info.text = @"";//[dic[@"employeinfo"]objectFromJSONString][@"msg"];
                    
                    CGSize size = [info.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
                    info.frame = CGRectMake(10, 55, 300, size.height);
                    call.frame = CGRectMake(25, info.frame.origin.y + info.frame.size.height + 7, 127, 33);
                    mvoip.frame = CGRectMake(call.frame.origin.x + call.frame.size.width + 16, call.frame.origin.y, call.frame.size.width, call.frame.size.height);
                    call.titleLabel.text = officephone.text;
                    mvoip.titleLabel.text = officephone.text;
                    info.hidden = NO;
                    call.hidden = NO;
                    mvoip.hidden = NO;
//                    arrow.text = @"△";
                    arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_fold.png"];
                }
                else{
                    line.frame = CGRectMake(0,49,self.view.frame.size.width,0);
                    info.hidden = YES;
                    call.hidden = YES;
                    mvoip.hidden = YES;
                    //                    arrow.text = @"▽";
                    arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_expand.png"];
                }
            
            }
            else{
                
                NSDictionary *dic = subPeopleList[indexPath.row-1];
                
                name.frame = CGRectMake(10, 15, 150, 20);
                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                
                //            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 3, name.frame.size.width, 15);
                //            team.text = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] searchCode:dic[@"deptcode"]]];
                
                officephone.frame = CGRectMake(320-30-130, 14, 130, 20);
                officephone.text = [NSString stringWithFormat:@"%@",dic[@"officephone"]];
                
                
                if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
                {
                    
                    line.frame = CGRectMake(0,49,self.view.frame.size.width,1);
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
                    //                arrow.text = @"△";
                    
                    arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_fold.png"];
                }
                else{
                    line.frame = CGRectMake(0,49,self.view.frame.size.width,0);
                    info.hidden = YES;
                    call.hidden = YES;
                    mvoip.hidden = YES;
                    //                arrow.text = @"▽";
                    
                    arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_expand.png"];
                }
                
            }
            }
            
            else{
            NSDictionary *dic = subPeopleList[indexPath.row];
            
            name.frame = CGRectMake(10, 15, 150, 20);
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
            
//            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 3, name.frame.size.width, 15);
//            team.text = [NSString stringWithFormat:@"%@",[[ResourceLoader sharedInstance] searchCode:dic[@"deptcode"]]];
                
                officephone.frame = CGRectMake(320-30-130, 14, 130, 20);
                officephone.text = [NSString stringWithFormat:@"%@",dic[@"officephone"]];
                
                
            if(selectedRowIndex && indexPath.row == selectedRowIndex.row)
            {
                
                line.frame = CGRectMake(0,49,self.view.frame.size.width,1);
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
//                arrow.text = @"△";
                
                arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_fold.png"];
            }
            else{
                line.frame = CGRectMake(0,49,self.view.frame.size.width,0);
                info.hidden = YES;
                call.hidden = YES;
                mvoip.hidden = YES;
//                arrow.text = @"▽";
                
                arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_expand.png"];
            }
            }
            
            
        }
        else{
            line.frame = CGRectMake(0,49,self.view.frame.size.width,0);
            arrow.frame = CGRectMake(320-20, 17, 9, 13);
            name.frame = CGRectMake(10, 15, 300, 20);
//            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height+5, name.frame.size.width, 0);
//            team.text = @"";
            int subRow = indexPath.row - subPeopleListCount;
            name.text = subDeptList[subRow][@"deptname"];
            
            officephone.frame = CGRectMake(320-30-130, 14, 130, 0);
            officephone.text = @"";

            
            info.hidden = YES;
            call.hidden = YES;
            mvoip.hidden = YES;
//            arrow.text = @"▷";
            
            arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_enter.png"];
        }
    
//    }
     return cell;
}

- (BOOL)existDeptNumber:(NSString *)code{

//    NSLog(@"existDeptNumber %@",code);
    BOOL returnExistValue = NO;
//    NSLog(@"existDeptDictionary %@",existDeptDictionary);
    if(existDeptDictionary){
        existDeptDictionary = nil;
    }
    existDeptDictionary = [[NSDictionary alloc]init];
    returnExistValue = NO;
    
    for(NSDictionary *dic in [ResourceLoader sharedInstance].deptList){
        if([dic[@"deptcode"]isEqualToString:code]){
//            NSLog(@"dic %@",dic);
            if([dic[@"dept_phone"]length]>0){
            existDeptDictionary = dic;
                returnExistValue = YES;
        }
        }
    }
//    NSLog(@"existDeptDictionary %@",existDeptDictionary);
    
    return returnExistValue;
}

- (NSString *)getOfficeNumber:(NSString *)code{
    
    NSString *returnString = @"";
    
    for(NSDictionary *dic in [ResourceLoader sharedInstance].deptList){
        if([dic[@"deptcode"]isEqualToString:code]){
            if([dic[@"dept_phone"]length]>0){
//                NSLog(@"exist");
                returnString = dic[@"dept_phone"];
            }
        }
    }
    
    return returnString;
}

- (void)cmdButton:(id)sender{
    NSString *phonenumber = [[sender titleLabel]text];
//    NSLog(@"phonenumber %@",phonenumber);
    
    
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

//- (void)saveImage:(NSDictionary *)dic
//{
//
//               NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[dicobjectForKey:@"path"]];
//    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dicobjectForKey:@"urlString"]]];
//   
//    [imgData writeToFile:filePath atomically:YES];
//    
//    [imageThread cancel];
//    
////    if(imageThread)
////        SAFE_RELEASE(imageThread);
//}


- (void)selectList:(int)rowOfButton
{
    
//    NSLog(@"selectList");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직을 선택할 때마다 새로 세팅을 해 준다.
     param - sender(id) : tag를 이용해 몇 번째 조직인지 넘긴다.
     연관화면 : 조직도
     ****************************************************************/
    
		
//		int rowOfButton = [sender tag];
    myTable.contentOffset = CGPointMake(0, 0);
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(upTo)];
//    self.navigationItem.backBarButtonItem = backButton;
//    [backButton release];
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(upTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    NSDictionary *dic = subDeptList[rowOfButton];
    self.title = dic[@"deptname"];
		[self.addArray addObject:self.title];
		[self reloadCheck];
		
	[subList removeAllObjects];
				
		
		NSMutableArray *tempArray = [[NSMutableArray alloc]init];
		[tempArray setArray:[ResourceLoader sharedInstance].deptList];
		
		
		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
				if([forDic[@"parentdeptcode"] isEqualToString:dic[@"deptcode"]])
				{
						[subList addObject:forDic];
				}
		}
		 [self.selectCodeList addObject:dic[@"parentdeptcode"]];
		
		[tempArray setArray:[ResourceLoader sharedInstance].contactList];
		
		
	[subPeopleList removeAllObjects];
		
		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
				
				if([forDic[@"deptcode"] isEqualToString:dic[@"deptcode"]])
				{
						[subPeopleList addObject:forDic];
				}
		}
    [tempArray release];

		
		[subDeptList removeAllObjects];
    [subDeptList setArray:subList];
    existDept = [self existDeptNumber:dic[@"deptcode"]];
		
		tagInfo++;
    
    if(existDept){
        expanded = YES;
        self.selectedRowIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
		[myTable reloadData];

}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    int subPeopleListCount = [subPeopleList count];
//    NSLog(@"existDept %@",existDept?@"YES":@"NO");
    if(existDept)
        ++subPeopleListCount;
    
    if(indexPath.row < subPeopleListCount)
    {
        if(self.selectedRowIndex.row == indexPath.row && expanded){
//        NSLog(@"here");
        self.selectedRowIndex = nil;
        expanded = NO;
        
        
        
    }
    else{
//        NSLog(@"here expand");
        self.selectedRowIndex = indexPath;
        expanded = YES;
    }
        
        [tableView reloadData];
    }
    else{
        self.selectedRowIndex = nil;
           expanded = NO;
        
        
        int subRow = indexPath.row - subPeopleListCount;
//        NSLog(@"subRow %d",subRow);
        [self selectList:subRow];
    }
    

}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
//    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	if (scrollView) {
		[scrollView release];
	}
	[subDeptList release];
	[search release];
	[myTable release];
	[subList release];
	[subPeopleList release];
    [selectCodeList release];
    [addArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}


@end

