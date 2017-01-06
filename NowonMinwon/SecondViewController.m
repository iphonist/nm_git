//
//  SecondViewController.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidLoad");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    deptList = [];
    
//    self.tableView.bounces = NO;
//    self.tableView.alwaysBounceVertical = NO;
//    self.tableView.backgroundColor = [UIColor grayColor];
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 28+search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height-groupNameView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.bounces = NO;
    myTable.alwaysBounceVertical = NO;
    myTable.scrollEnabled = NO;
    
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:myTable];
    
    myList = [[NSMutableArray alloc]init];
    
    
    [myList removeAllObjects];
    for(NSDictionary *dic in [ResourceLoader sharedInstance].deptList){
        if([dic[@"parentdeptcode"]isEqualToString:@"1"]){
            [myList addObject:dic];
        }
    }
    
    int viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 20;
    } else {
    }
    
        myTable.frame = CGRectMake(0, 0, 320, [self returnHeight]-viewY);
    myTable.backgroundColor = [UIColor grayColor];
    NSLog(@"mytable frame %@",NSStringFromCGRect(myTable.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [myList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIImageView *arrow;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    else{
        
    }
    
    arrow = [[UIImageView alloc]init];
    arrow.frame = CGRectMake(320-20, 17, 9, 13);
    arrow.tag = 7;
    arrow.image = [CustomUIKit customImageNamed:@"imageview_organize_cell_accessory_enter.png"];
    [cell.contentView addSubview:arrow];
    [arrow release];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = myList[indexPath.row][@"deptname"];
    
    return cell;
}

- (float)returnHeight{
    
    return 44*[myList count]+20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect");
    NSString *listName = [[ResourceLoader sharedInstance] searchCode:myList[indexPath.row][@"deptcode"]];
    [SharedAppDelegate.root.organize.selectCodeList removeAllObjects];
    [SharedAppDelegate.root.organize.selectCodeList addObject:myList[indexPath.row]];
    [SharedAppDelegate.root.organize.addArray removeAllObjects];
    [SharedAppDelegate.root.organize.addArray addObject:listName];
    //    NSLog(@"org addarray %@ addobject %@",organizeController.addArray,listName);
//    NSLog(@"organize %@ %@",SharedAppDelegate.root.mainViewController,SharedAppDelegate.root.mainViewController.navigationController);
    [SharedAppDelegate.root.mainViewController.navigationController pushViewController:SharedAppDelegate.root.organize animated:YES];
    [SharedAppDelegate.root.organize setFirst:listName];
    [SharedAppDelegate.root.organize checkSameLevel:myList[indexPath.row][@"deptcode"]];
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
