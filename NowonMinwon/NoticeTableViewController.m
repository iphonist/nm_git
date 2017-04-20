//
//  NoticeTableViewController.m
//  NowonMinwon
//
//  Created by Hyemin Kim on 2014. 11. 14..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "PhotoTableViewController.h"

@interface NoticeTableViewController ()

@end

@implementation NoticeTableViewController

- (id)initWithArray:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        // Custom initialization
        myList = [[NSMutableArray alloc]initWithArray:array];
    }
    return self;
}

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"알림";
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    
    UIButton *button = [CustomUIKit emptyButtonWithTitle:@"xclosebtn.png" target:self selector:@selector(cancel)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"cellForRow");
    static NSString *CellIdentifier = @"Cell";
    //		NSString *email;
    UILabel *title, *date;
    UITextView *content;
    UIImageView *titlebackground, *contentbackground, *contentImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease]; // ######## inimage 때메 재사용 안 했는데 좀 더 체크
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
        titlebackground = [[UIImageView alloc]init];
        titlebackground.image = [[CustomUIKit customImageNamed:@"imageview_fullnotice_background_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 31-17, 17)];
        titlebackground.tag = 11;
        [cell.contentView addSubview:titlebackground];
        [titlebackground release];
        
        
        contentbackground = [[UIImageView alloc]init];
        contentbackground.image = [[CustomUIKit customImageNamed:@"imageview_fullnotice_background_middle.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 17, 53-17, 17)];
        contentbackground.tag = 12;
        [cell.contentView addSubview:contentbackground];
        [contentbackground release];
    
    
        
        title = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor grayColor];
        title.numberOfLines = 0;
        title.tag = 1;
        [titlebackground addSubview:title];
        [title release];
        
    
    content = [[UITextView alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:14];
    content.textColor = [UIColor grayColor];
    content.dataDetectorTypes = UIDataDetectorTypeLink;
    content.tag = 2;
          [content setEditable:NO];
    [contentbackground addSubview:content];
    [content release];
    
    
    
        date = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        date.backgroundColor = [UIColor clearColor];
        date.font = [UIFont systemFontOfSize:12];
        date.textColor = [UIColor grayColor];
        date.numberOfLines = 1;
        date.tag = 3;
        date.textAlignment = UITextAlignmentRight;
        [contentbackground addSubview:date];
        [date release];
        
        
        contentImage = [[UIImageView alloc]init];
        contentImage.tag = 4;
        [contentbackground addSubview:contentImage];
        [contentImage release];
        
//    }
//    else{
//        title = (UILabel *)[cell viewWithTag:1];
//        content = (UILabel *)[cell viewWithTag:2];
//        date = (UILabel *)[cell viewWithTag:3];
//        titlebackground = (UIImageView *)[cell viewWithTag:11];
//        contentbackground = (UIImageView *)[cell viewWithTag:12];
//        contentImage = (UIImageView *)[cell viewWithTag:4];
//        
//    }
    
//    cell.userInteractionEnabled = YES;
    
    NSDictionary *dic = [myList[indexPath.row][@"content"]objectFromJSONString];
    title.text = dic[@"title"];
    content.text = dic[@"msg"];
//    NSLog(@"content.text %@",content.text);
    
    CGSize size = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:UILineBreakModeWordWrap];
    title.frame = CGRectMake(10, 8 , 280, size.height);
    titlebackground.frame = CGRectMake(8, 7, 304, size.height+15);
   
    date.text = myList[indexPath.row][@"writetime"];
    date.frame = CGRectMake(10, 5, 280, 20);
    NSString *imageString = dic[@"image"];
      contentImage.image = nil;
    contentImage.frame = CGRectMake(10, date.frame.origin.y+date.frame.size.height, 0, 0);
    if(imageString != nil && [imageString length]>0)
    {
        contentImage.userInteractionEnabled = YES;
        //        contentImageView.hidden = NO;
//        NSLog(@"imageString %@",imageString);
        
        
        NSArray *imageArray = [imageString objectFromJSONString][@"thumbnail"];
        CGFloat imageHeight = 0.0f;
        for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
            NSDictionary *sizeDic;
            if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
            else
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
//            NSLog(@"sizeDic %@",sizeDic);
            CGFloat imageScale = 0.0f;
            imageScale = 280/[sizeDic[@"width"]floatValue];
            
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(0,imageHeight,280,imageScale * [sizeDic[@"height"]floatValue]);
            imageHeight += inImageView.frame.size.height + 10;
//            NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
            inImageView.backgroundColor = [UIColor blackColor];
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
            [inImageView setClipsToBounds:YES];
                  NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:YES];
            dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                           {
                               NSData * data = [[[NSData alloc] initWithContentsOfURL:imgURL] autorelease];
                               UIImage * image = [[[UIImage alloc] initWithData:data] autorelease];
                               dispatch_async( dispatch_get_main_queue(), ^(void){
                                   if( image != nil )
                                   {
                                       inImageView.image = image;
                                   } else {
                                   }
                               });
                           });


            [contentImage addSubview:inImageView];
            inImageView.userInteractionEnabled = YES;
            
            UIButton *viewImageButton = [[UIButton alloc]initWithFrame:
                                         CGRectMake(titlebackground.frame.origin.x + contentImage.frame.origin.x + inImageView.frame.origin.x,
                                                    titlebackground.frame.origin.y + titlebackground.frame.size.height + contentImage.frame.origin.y + inImageView.frame.origin.y,
                                                    inImageView.frame.size.width,inImageView.frame.size.height)];
//            viewImageButton.backgroundColor = [UIColor grayColor];
//            viewImageButton.userInteractionEnabled = YES;
//                                    [viewImageButton setBackgroundImage:[UIImage imageNamed:@"barbutton_close.png"] forState:UIControlStateNormal];
            [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
            viewImageButton.tag = i+1;
            viewImageButton.titleLabel.text = imageString;
            [cell.contentView addSubview:viewImageButton];
            [viewImageButton release];
            [inImageView release];
//            NSLog(@"viewImageButton %@ tag %d",viewImageButton,i);
            
            //                    contentImageView.backgroundColor = [UIColor blackColor];
            //                        viewImageButton.backgroundColor = [UIColor redColor];
            
            
        }
        contentImage.frame = CGRectMake(10, date.frame.origin.y+date.frame.size.height, 280, imageHeight);
        
        

        
    }
    
 
    
    
    CGSize csize = [content.text sizeWithFont:content.font constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:UILineBreakModeWordWrap];
    content.frame = CGRectMake(10, contentImage.frame.origin.y + contentImage.frame.size.height, 280, csize.height+10);
    contentbackground.frame = CGRectMake(titlebackground.frame.origin.x, titlebackground.frame.origin.y + titlebackground.frame.size.height, titlebackground.frame.size.width, content.frame.origin.y + content.frame.size.height+15);
    
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float height = 0;
    
    NSDictionary *dic = [myList[indexPath.row][@"content"]objectFromJSONString];
    NSString *title = dic[@"title"];
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:UILineBreakModeWordWrap];
    height += 7 + size.height + 15;
    
//    NSString *date = myList[indexPath.row][@"writetime"];
    height += 5 + 20;
    
    NSString *imageString = dic[@"image"];
    
    if(imageString != nil && [imageString length]>0)
    {
        
        NSArray *imageArray = [imageString objectFromJSONString][@"thumbnail"];
        CGFloat imageHeight = 0.0f;
        for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
            NSDictionary *sizeDic;
            if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
            else
                sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
            
            
            CGFloat imageScale = 0.0f;
            imageScale = 280/[sizeDic[@"width"]floatValue];
            
                        imageHeight += imageScale * [sizeDic[@"height"]floatValue] + 10;
            
        }
        height += imageHeight;
        
        
    }
    else{
        
    }
    
    NSString *content = dic[@"msg"];
    CGSize csize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:UILineBreakModeWordWrap];
    height += csize.height + 15+10;
    
    
    
    
    return height;
    
    
}
- (void)viewImage:(id)sender{
    
//    NSLog(@"viewImage");
    NSString *imageString = [[sender titleLabel]text];
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]-1]];
//    NSLog(@"imgUrl %@",imgUrl);
    
    UIViewController *photoCon;
    
    
            photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:[sender tag]-1];
  
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
    [self presentModalViewController:nc animated:YES];
    //    [SharedAppDelegate.root anywhereModal:nc];
    [nc release];
    [photoCon release];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didSelect");
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
