//
//  PhotoSlidingViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 13. 9. 6..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomPageControl.h"
#import "MRScrollView.h"

@interface PhotoTableViewController : UIViewController < UIScrollViewDelegate > {
    NSMutableArray *myList;
    UIScrollView *scrollView;
//    MRScrollView *inScrollView;
   UIPageControl *paging;
    UIViewController *parentVC;
    NSDictionary *myDic;
    NSInteger viewTag;
//    NSMutableArray *imageArray;
    NSInteger pIndex;
	UITapGestureRecognizer *tapGesture;
    UIProgressView *downloadProgress;
    NSMutableArray *imageViewArray;
    UIImage *willSaveImage;
    UILabel *pageLabel;
    UIImageView *pageBackground;
}
- (id)initForDownload:(NSDictionary *)dic parent:(UIViewController *)parent index:(int)i;
//- (id)initForUpload:(NSMutableArray *)array parent:(UIViewController *)parent;
//- (id)initFromActivity:(NSArray *)array parent:(UIViewController *)parent index:(int)i;

@end
