//
//  ContactViewController.m
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 7..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "ContactViewController.h"
#import <objc/runtime.h>


const char alertNumber;
@interface ContactViewController ()

@end

@implementation ContactViewController

- (id)init//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)backTo
{
    NSLog(@"backTo");
    [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    int viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44+20;
    } else {
        viewY = 44;
    }
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    UIView *infoView;
    infoView = [[UIView alloc]init];
    infoView.frame = CGRectMake(0, viewY, 320, 35);
//    infoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoView];
    
    NSString *msg = @"";
    UILabel *infoLabel;
    infoLabel = [CustomUIKit labelWithText:msg bold:NO fontSize:12 fontColor:RGB(106, 106, 106) frame:CGRectMake(15, 10, infoView.frame.size.width-15-10-93-10, 25) numberOfLines:3 alignText:UITextAlignmentLeft];
    [infoView addSubview:infoLabel];
    
    button = [CustomUIKit buttonWithTarget:self selector:@selector(showActionSheet:) frame:CGRectMake(320-10-93, 10, 93, 25) imageNamedNormal:@"button_favoritecontact_dropdown.png" imageNamedPressed:@""];
    [infoView addSubview:button];
    
    [infoView release];
    
    titleLabel = [CustomUIKit labelWithText:self.title bold:NO fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(5, 3, 93-10, 18) numberOfLines:1 alignText:UITextAlignmentLeft];
    [button addSubview:titleLabel];
    
    myTable = [[UITableView alloc]init];
    myTable.frame = CGRectMake(0, infoView.frame.origin.y + infoView.frame.size.height, 320, self.view.frame.size.height - (infoView.frame.origin.y + infoView.frame.size.height+5));
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTable];
    myTable.backgroundColor = [UIColor clearColor];
    [myTable release];
    
    
}

- (void)settingList:(NSArray *)array withTitle:(NSString *)title{
    self.title = title;
    
    NSLog(@"array %@",array);
    if(myList){
        [myList release];
        myList = nil;
    }
    myList = [[NSMutableArray alloc]init];
    [myList setArray:array];
    [myTable reloadData];
    myTable.contentOffset = CGPointMake(0,0);
    titleLabel.text = title;
}

- (void)showActionSheet:(id)sender{
    
    NSArray *array = [[[NSArray alloc] initWithArray:[ResourceLoader sharedInstance].menuList]autorelease];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    // ObjC Fast Enumeration
    for (NSDictionary *dic in array) {
        [actionSheet addButtonWithTitle:dic[@"dept_cat"]];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"취소"];
    
    [actionSheet showInView:SharedAppDelegate.window];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if(buttonIndex == [[ResourceLoader sharedInstance].menuList count])
        return;
    
    NSArray *array = [ResourceLoader sharedInstance].menuList[buttonIndex][@"dept_info"];
    NSString *title = [ResourceLoader sharedInstance].menuList[buttonIndex][@"dept_cat"];
    [SharedAppDelegate.root.contact settingList:array withTitle:title];
    myTable.contentOffset = CGPointMake(0,0);
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
    
    return [myList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        
    NSString *info = myList[indexPath.row][@"dept_desc"];
    CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
        return 7+10 + size.height + 3 + 15 + 12 + 15 + 15;
    
    
}



#define kCall 4
#define kMvoip 5

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    //		NSString *email;
    UILabel *name, *officephone;
    UIButton *call, *mvoip;
    UIImageView *backgroundImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        backgroundImage = [[UIImageView alloc]init];
        backgroundImage.image = [[CustomUIKit customImageNamed:@"imageview_favoritecontact_cellbackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 84-30, 30)];
           backgroundImage.tag = 10;
        [cell.contentView addSubview:backgroundImage];
        backgroundImage.userInteractionEnabled = YES;
        [backgroundImage release];
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = [UIColor grayColor];
        name.numberOfLines = 0;
        name.tag = 1;
        [backgroundImage addSubview:name];
        [name release];
        
        
        call = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(0, 0, 0, 0) imageNamedNormal:@"button_favoritecontact_call.png" imageNamedPressed:@""];
        call.tag = kCall;
        [backgroundImage addSubview:call];
        
        mvoip = [CustomUIKit buttonWithTarget:self selector:@selector(cmdButton:) frame:CGRectMake(0, 0, 0, 0) imageNamedNormal:@"button_favoritecontact_mvoip.png" imageNamedPressed:@""];
        mvoip.tag = kMvoip;
        [backgroundImage addSubview:mvoip];
        
        
        officephone = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        officephone.backgroundColor = [UIColor clearColor];
        officephone.font = [UIFont systemFontOfSize:14];
        officephone.textColor = [UIColor grayColor];
        officephone.tag = 6;
        [backgroundImage addSubview:officephone];
        [officephone release];
        
        
    }
    else{
        name = (UILabel *)[cell viewWithTag:1];
        call = (UIButton *)[cell viewWithTag:kCall];
        mvoip = (UIButton *)[cell viewWithTag:kMvoip];
        officephone = (UILabel *)[cell viewWithTag:6];
        backgroundImage = (UIImageView *)[cell viewWithTag:10];
    }
    
    
    
    
    NSDictionary *dic = myList[indexPath.row];
    
    name.text = [NSString stringWithFormat:@"%@",dic[@"dept_desc"]];
        CGSize size = [name.text sizeWithFont:name.font constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
       name.frame = CGRectMake(13, 10, 280, size.height);
    
    
    officephone.frame = CGRectMake(name.frame.origin.x, name.frame.origin.x + name.frame.size.height+3, name.frame.size.width, 15);
    officephone.text = [NSString stringWithFormat:@"%@",dic[@"dept_phone"]];
        call.frame = CGRectMake(officephone.frame.origin.x, officephone.frame.origin.y + officephone.frame.size.height + 12, 55, 15);
        mvoip.frame = CGRectMake(152 + 10, call.frame.origin.y, call.frame.size.width, call.frame.size.height);
        call.titleLabel.text = officephone.text;
        mvoip.titleLabel.text = officephone.text;
    
    
    backgroundImage.frame = CGRectMake(7, 7, 305, 10 + size.height + 3 + 15 + 12 + 15 + 15);
    NSLog(@"backgroundImage %@",NSStringFromCGRect(backgroundImage.frame));
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
    // Configure the cell...
 
    return cell;
}
*/

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
