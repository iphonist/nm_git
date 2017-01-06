//
//  PhotoSlidingViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 9. 6..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "PhotoTableViewController.h"

@interface PhotoTableViewController ()

@end

@implementation PhotoTableViewController





- (id)initForDownload:(NSDictionary *)dic parent:(UIViewController *)parent index:(int)i{
    self = [super init];//WithStyle:style];
    if (self) {
   
        NSLog(@"initForDownload");
        
 
    
        
        parentVC = parent;
        NSLog(@"myDic %@",dic);
        myDic = [[NSDictionary alloc]initWithDictionary:dic];
        self.title = @"사진 보기";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];

        pIndex = i;
        // Custom initialization
    }
    return self;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;

    self.view.backgroundColor = [UIColor blackColor];
    
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    NSLog(@"self.view.frame size.heigh %f",self.view.bounds.size.height+20+44);
    [self.view addSubview:scrollView];
    [scrollView release];
    
    paging = [[UIPageControl alloc]init];//
    
 
    
		pageBackground = [[UIImageView alloc]init];
		pageBackground.frame = CGRectMake(15,15,40,26);
		if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
			pageBackground.frame = CGRectMake(15,15+44,40,26);
		}
		pageBackground.image = [[CustomUIKit customImageNamed:@"photonumbering.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:13];
		
		pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pageBackground.frame.size.width,pageBackground.frame.size.height)];
		pageLabel.textAlignment = NSTextAlignmentCenter;
		pageLabel.backgroundColor = [UIColor clearColor];
		pageLabel.textColor = RGB(225, 223, 224);
		pageLabel.font = [UIFont systemFontOfSize:15.0];
				
		[pageBackground addSubview:pageLabel];
		[self.view addSubview:pageBackground];
		
		
        scrollView.frame = CGRectMake(0,0-20-44-30,320,self.view.bounds.size.height+20+44+30);
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            scrollView.frame = CGRectMake(0,0-20-20,320,self.view.bounds.size.height+20+20);
        }
		UIButton *button =  [CustomUIKit buttonWithTarget:self selector:@selector(cancel) frame:CGRectMake(0, 0, 36, 36) imageNamedNormal:@"xclosebtn.png" imageNamedPressed:@""];
    
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
        [btnNavi release];
    
    
//        NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
    
       
        myList = [[NSMutableArray alloc]initWithArray:myDic[@"filename"]];
    
        NSLog(@"myDic %@",myDic);
        NSLog(@"mylist %@",myList);
        
        
        int page = [myList count];
        scrollView.contentSize = CGSizeMake(320*page,self.view.bounds.size.height+20+44);
        paging.frame = CGRectMake(10, self.view.frame.size.height - 35 - 50, 0, 0);
        paging.numberOfPages = page;
        
        paging.currentPage = pIndex;
        NSLog(@"paging.current %d",(int)paging.currentPage);
        pageLabel.text = [NSString stringWithFormat:@"%d/%d",(int)paging.currentPage+1,(int)paging.numberOfPages];
		
		[self adjustPageLabelSize];

		
        scrollView.contentOffset = CGPointMake(320*pIndex, scrollView.contentOffset.y);
        NSLog(@"scrollView.contentoffset.x %f",scrollView.contentOffset.x);
        
        imageViewArray = [[NSMutableArray alloc]init];
        
        
        for(int i = 0; i < page; i++){
            
            MRScrollView *inScrollView = [[MRScrollView alloc]initWithFrame:CGRectMake(320*i,0,self.view.bounds.size.width,self.view.bounds.size.height+20+44)];
            UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTapGesture setNumberOfTapsRequired:2];
            [inScrollView addGestureRecognizer:doubleTapGesture];
            [scrollView addSubview:inScrollView];
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
            [inScrollView addGestureRecognizer:tapGesture];
            [tapGesture release];
            [doubleTapGesture release];            
            [imageViewArray addObject:inScrollView];
            [inScrollView release];
        }
    
        [self downloadImage:pIndex];
         
    
        [self.view addSubview:pageBackground];
        [pageBackground release];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.wantsFullScreenLayout = NO;
	SharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"navibar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
		[self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(226, 226, 226);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        
    }
    
    
	
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
	
	SharedAppDelegate.window.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //		[self.navigationController.navigationBar setBackgroundImage:[CustomUIKit customImageNamed:@"photoviewbarbg_ios7.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = RGB(37, 37, 37);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(225, 223, 224)}];
        
    }
    
}

- (void)adjustPageLabelSize
{
	CGFloat width;
	if([pageLabel.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
		width = [pageLabel.text boundingRectWithSize:pageLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: pageLabel.font} context:nil].size.width + 20.0;
	} else {
		width = [pageLabel.text sizeWithFont:pageLabel.font].width + 20.0;
	}
	
	CGRect pageBackgrounFrame = pageBackground.frame;
	pageBackgrounFrame.size.width = width;
	pageBackground.frame = pageBackgrounFrame;
	
	CGRect pageIndicateFrame = pageLabel.frame;
	pageIndicateFrame.size.width = width;
	pageLabel.frame = pageIndicateFrame;
	
}



- (void)downloadImage:(int)index{
    
    MRScrollView *view = imageViewArray[index];
    NSLog(@"inscrollview %@",NSStringFromCGRect(view.frame));
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
        [downloadProgress release];
        downloadProgress = nil;
    }
    
    downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [downloadProgress setFrame:CGRectMake(30, 340, 260, 10)];
    [view addSubview:downloadProgress];
//    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",myDic[@"server"],myDic[@"dir"],myDic[@"filename"][index]];

  
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         [downloadProgress setProgress:(float)totalBytesRead / totalBytesExpectedToRead];
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        

        if(downloadProgress){
            [downloadProgress removeFromSuperview];
            [downloadProgress release];
            downloadProgress = nil;
        }
//         [downloadProgress release];
        UIImage *img = [UIImage imageWithData:operation.responseData];
//        [imageArray addObject:@{@"image" : img, @"index" : [NSString stringWithFormat:@"%d",index]}];
//        imageView.image = img;
        [view displayImage:img];
        willSaveImage = img;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
		[HTTPExceptionHandler handlingByError:error];

    }];
    [operation start];
    

}




-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer  {
    
//    NSLog(@"handleDoubleTap %f",inScrollView.zoomScale);
    MRScrollView *view = imageViewArray[paging.currentPage];
	if(view.zoomScale == view.maximumZoomScale)
		[view setZoomScale:view.minimumZoomScale animated:YES];
	else
		[view setZoomScale:view.maximumZoomScale animated:YES];
}



- (void)handleGesture:(UIGestureRecognizer*)gesture {
    
    NSLog(@"handleGesture %@",NSStringFromCGRect(scrollView.frame));
    
                         [[UIApplication sharedApplication] setStatusBarHidden:![[UIApplication sharedApplication] isStatusBarHidden] withAnimation:UIStatusBarAnimationNone];
                         [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
                         paging.hidden = !paging.hidden;
    pageBackground.hidden = !pageBackground.hidden;
    
    
    if(paging.hidden) {
        
        scrollView.frame = CGRectMake(0,0-20-10,320,self.view.bounds.size.height+20+10);
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        scrollView.frame = CGRectMake(0,0-20,320,self.view.bounds.size.height+20);
        }
    }
    else{
        
        scrollView.frame = CGRectMake(0,0-20-44-30,320,self.view.bounds.size.height+20+44+30);
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
            scrollView.frame = CGRectMake(0,0-20-20,320,self.view.bounds.size.height+20+20);
        }
    }
    [self.view setNeedsDisplay];

	
}







- (void) scrollViewDidScroll:(UIScrollView *)sender {
	paging.currentPage = (scrollView.contentOffset.x/320);
    pageLabel.text = [NSString stringWithFormat:@"%d/%d",(int)paging.currentPage+1,(int)paging.numberOfPages];
	[self adjustPageLabelSize];
    [paging updateCurrentPageDisplay];
    
    
    if(downloadProgress){
        [downloadProgress removeFromSuperview];
        [downloadProgress release];
        downloadProgress = nil;
    }
    
//    [self downloadImage:paging.currentPage];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");

    
 [self downloadImage:(int)paging.currentPage];
}

//- (void)changePage{
//    NSLog(@"changePage");
//}
//- (void)updateCurrentPageDisplay{
//    NSLog(@"updateCurrentPageDisplay");
//}


- (void)backTo{
    [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)cancel
{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [myList count];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *img = myList[indexPath.row];
//    return 300.0f/img.size.width*img.size.height + 20;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
//    
//    UIImageView *imageView;
//    UIButton *closeButton;
//    
//    if(cell == nil)
//    {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        imageView = [[UIImageView alloc]init];
//        [cell.contentView addSubview:imageView];
//        imageView.tag = 1;
//        [imageView release];
//        
//        
//        
//    }
//    else{
//        imageView = (UIImageView *)[cell viewWithTag:1];
//    }
//    
//    
//    UIImage *img = myList[indexPath.row];
//    imageView.image = img;
//    imageView.frame = CGRectMake(10, 10, 300, 300.0f/img.size.width*img.size.height);
//    imageView.userInteractionEnabled = YES;
//    
////    closeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deleteImage:) frame:CGRectMake(300 - 49, 0, 49, 49) imageNamedBullet:nil imageNamedNormal:@"profilepop_closebtn.png" imageNamedPressed:nil];
////    closeButton.tag = indexPath.row;
////    [imageView addSubview:closeButton];
//    
//    return cell;
//}

//- (void)deleteImage:(id)sender{
//    [myList removeObjectAtIndex:[sender tag]];
//    [self.tableView reloadData];
//}

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
