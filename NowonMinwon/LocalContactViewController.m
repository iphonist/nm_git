//
//  ContactViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "LocalContactViewController.h"
#import <AddressBook/AddressBook.h>


@implementation LocalContactViewController



#pragma mark -
#pragma mark Handle the custom alert




- (id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}




// 섹션에 몇 개의 셀이 있는지.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if([myList count]==0)
        return 1;
    else{
           return [myList count];
		
    
    }
}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = 0;
    
  
        sec = 1;
    
    return sec;
}



// 해당 뷰가 생성될 때 한 번만 호출
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    NSLog(@"viewdidload");
    //
    self.title = @"친구초대하기";
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(closeView)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
	
    CGRect tableFrame;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
	    tableFrame = CGRectMake(0, search.frame.size.height + 0, 320, self.view.frame.size.height - 44 - 20 - 0); // 네비(44px) + 상태바(20px)
	} else {
		tableFrame = CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - 44 - 0); // 네비(44px)
	}
	myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
	myTable.dataSource = self;
	myTable.delegate = self;
	myTable.rowHeight = 50;
	[self.view addSubview:myTable];
    [myTable release];
	//    myTable.scrollsToTop = YES;
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	
	myList = [[NSMutableArray alloc]init];
    
	
}

- (NSArray *)getAllocAddressBook{
   
     NSLog(@"getAllocAddressBook");
//    NSMutableArray *contactList = [[ResourceLoader sharedInstance] allContactList];
    NSMutableArray *phoneNumberList = [[[NSMutableArray alloc]init]autorelease];
//    NSArray *returnList = [[[NSMutableArray alloc]init]autorelease];

    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // Get all contacts in the addressbook
	NSArray *allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    ABMultiValueRef phoneNumbers;
	for (id person in allPeople) {
        
        phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
  
        // If the contact has multiple phone numbers, iterate on each of them
        
        for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
          
            NSString *phoneNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSLog(@"phoneNumber %@",phoneNumber);
//            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+82 " withString:@"0"];
//            phoneNumber = [SharedAppDelegate.root getPureNumbers:phoneNumber];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            NSString *name = [[lastName length]>0?lastName:@"" stringByAppendingString:[firstName length]>0?firstName:@""];
            NSLog(@"name %@",name);
            [phoneNumberList addObject:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"number",name,@"name",nil]];
        }
    }
    
//    NSLog(@"contactList %d",[contactList count]);
//    for(NSDictionary *dic in contactList){
//        NSString *compareNumber = [SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]];
//    for(NSString *number in phoneNumberList){
//        if([number isEqualToString:compareNumber])
//               [(NSMutableArray *)returnList addObject:dic];
//        }
//    }
//    NSLog(@"ReturnList %d",[returnList count]);
//    returnList = [[NSSet setWithArray: returnList] allObjects];
    return phoneNumberList;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
      return nil;
    
}

- (void)closeView
{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}





#define kNotFavorite 1
#define kFavorite 2


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([myList count]==0)
        return;

    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    NSLog(@"[MFMessageComposeViewController canSendText] %@",[MFMessageComposeViewController canSendText]?@"YES":@"NO");
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = @"설치 URL https://blahblah.com";
        controller.recipients = nil;//[NSArray arrayWithObjects:myList[indexPath.row][@"number"], nil];
        controller.messageComposeDelegate = self;
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"성공적으로 전송하였습니다."];
            NSLog(@"Sent");
            
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}





// 뷰가 나타날 때마다 호출
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    [self fetchList];
}
- (void)fetchList{
    fetching = NO;
    [SVProgressHUD showWithStatus:@"주소록 불러오는중"];

    progressing = NO;
    
    NSLog(@"fetchList");

    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                NSLog(@"granted");
                [myList setArray:[self getAllocAddressBook]];
                fetching = YES;
                [myTable reloadData];
                
                [SVProgressHUD dismiss];//showSuccessWithStatus:@"완료"];
                NSLog(@"myList %@",myList);
            } else {
                NSLog(@"NOTgranted");
                [CustomUIKit popupAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요."];
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        
        NSLog(@"authorized");
        [myList setArray:[self getAllocAddressBook]];
        fetching = YES;
        [myTable reloadData];
        
        [SVProgressHUD dismiss];//showSuccessWithStatus:@"완료"];
        NSLog(@"myList %@",myList);
    }
    else {
        NSLog(@"denied");
        [CustomUIKit popupAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요."];
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    

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

// 셀 정의 함수.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UILabel *name, *number;//, *lblStatus;
//    UIButton *invite;
//    UIImageView *profileView, *disableView;
//    UIImageView *checkView;
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
//        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(40,0,50,50)];
//        profileView.tag = 1;
//        [cell.contentView addSubview:profileView];
//        [profileView release];
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(5, 15, 150, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:14];
        //        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
        [name release];

        
        number = [[UILabel alloc]initWithFrame:CGRectMake(160, 15, 150, 20)];
        number.font = [UIFont systemFontOfSize:14];
        number.textColor = [UIColor grayColor];
        number.backgroundColor = [UIColor clearColor];
        number.tag = 3;
        number.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:number];
        [number release];
//
//        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
//        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
//        
//        //        disableView.backgroundColor = RGBA(0,0,0,0.64);
//        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
//        [profileView addSubview:disableView];
//        disableView.tag = 11;
//        [disableView release];
//        
//        lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
//        lblStatus.font = [UIFont systemFontOfSize:12];
//        lblStatus.textColor = [UIColor whiteColor];
//        lblStatus.textAlignment = UITextAlignmentCenter;
//        lblStatus.backgroundColor = [UIColor clearColor];
//        lblStatus.tag = 6;
//        [disableView addSubview:lblStatus];
//        [lblStatus release];
//        
//        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
//        checkView.tag = 5;
//        [cell.contentView addSubview:checkView];
//        [checkView release];
        
//        invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 8, 57, 32)];
//        [invite setBackgroundImage:[CustomUIKit customImageNamed:@"installplz_btn.png"] forState:UIControlStateNormal];
//        [invite addTarget:SharedAppDelegate.root action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
//        invite.tag = 4;
//        [cell.contentView addSubview:invite];
//        [invite release];
    }
    else{
//        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];
//        //            position = (UILabel *)[cell viewWithTag:3];
        number = (UILabel *)[cell viewWithTag:3];
//        disableView = (UIImageView *)[cell viewWithTag:11];
//        lblStatus = (UILabel *)[cell viewWithTag:6];
//        checkView = (UIImageView *)[cell viewWithTag:5];
//        invite = (UIButton *)[cell viewWithTag:4];
    }

    
    
//	profileView.image = nil;
//
//
////        profileView.image = nil;
//        
//        name.textAlignment = UITextAlignmentCenter;
//        name.frame = CGRectMake(15, 9, 290, 34);
//        name.font = [UIFont systemFontOfSize:13];
//        team.text = @"";
////        invite.hidden = YES;
//        lblStatus.text = @"";
//        checkView.image = nil;
//        disableView.hidden = YES;

if([myList count]==0){
        if(fetching){
            name.frame = CGRectMake(10, 15, 300, 20);
            name.textAlignment = UITextAlignmentCenter;
            name.text = @"휴대폰 주소록과 일치하는 멤버가 없습니다.";
            number.text = @"";
        }
        else{
            name.text = @"";
            number.text = @"";
        }
}
else{
    name.frame = CGRectMake(10, 15, 140, 20);
    name.textAlignment = UITextAlignmentLeft;
    NSDictionary *dic = myList[indexPath.row];
    name.text = dic[@"name"];
    number.text = dic[@"number"];
    
}
//
//    }
//    else{
//        NSDictionary *dic = nil;
//    if(searching)
//    {
//        dic = copyList[indexPath.row];
//        
//           }
//    else
//    {
//        
//            if([myList count]>0){
//                dic = myList[indexPath.row];
//            
//                                       
//                                       
//                                       }
//        
//        
//        
//    }
//        if(dic != nil){
//            
//            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//            name.frame = CGRectMake(40+55, 5, 320-100, 20);
//            name.textAlignment = UITextAlignmentLeft;
//        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//        //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
//        
//        if([dic[@"grade2"]length]>0)
//        {
//            if([dic[@"team"]length]>0)
//                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
//            else
//                team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
//        }
//        else{
//            if([dic[@"team"]length]>0)
//                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
//        }
//        
//        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
//        
//        
//        if([dic[@"available"]isEqualToString:@"0"])
//        {
//            disableView.hidden = NO;
//            lblStatus.text = @"미설치";
//            
//        }
//        else if([dic[@"available"]isEqualToString:@"4"]){
//            lblStatus.text = @"로그아웃";
//            disableView.hidden = NO;
//            //            invite.hidden = YES;
//        }
//        else
//        {
//            disableView.hidden = YES;
//            //            invite.hidden = YES;
//			lblStatus.text = @"";
//        } //            lblStatus.text = @"";
//        
//        if([dic[@"favorite"]isEqualToString:@"1"]){
//            
//            checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
//        }
//        else{
//            
//            checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
//        }
//    }
//    }
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //		[myTable release];
    [myList release];
    
}


- (void)dealloc {
    
    
    [super dealloc];
}

@end
