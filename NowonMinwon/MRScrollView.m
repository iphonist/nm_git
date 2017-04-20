//
//  MRScrollView.m
//  BProject
//
//  Created by Riky.G Kim on 10. 6. 3..
//  Copyright 2010 마이리키닷넷. All rights reserved.
//

#import "MRScrollView.h"

@implementation MRScrollView
@synthesize index;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.scrollsToTop = NO;
    }
    return self;
}

- (void)dealloc
{
    [imageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
        
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

- (void)displayImage:(UIImage *)image
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 이미지를 뷰에 셋팅
	 param	- image(UIImage*) : 보여줄 이미지
	 연관화면 : 채팅 - 사진보기, 사진선택
	 ****************************************************************/

	if(image == nil)
		return;

	[imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    
//    self.zoomScale = 1.0;
    
    imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    [self configureForImageSize:[image size]];
}

- (void)configureForImageSize:(CGSize)imageSize 
{
//    NSLog(@"size %@",NSStringFromCGSize(imageSize));
	CGSize boundsSize = [self bounds].size;
	
	CGFloat xScale = boundsSize.width / imageSize.width;
	CGFloat yScale = boundsSize.height / imageSize.height;
//    NSLog(@"xcale %f yscale %f",xScale,yScale);

	CGFloat minScale = MIN(xScale, yScale);
//	CGFloat scrScale = 0.5; //1.0 / [[UIScreen mainScreen] scale];
	
	CGFloat zoomScale = minScale;
	CGFloat maxScale;
	
	minScale = MIN(minScale, 1.0);
//	if(minScale > scrScale)
//		minScale = scrScale;

//	if (zoomScale > scrScale)	// 화면보다 작은 이미지
//		maxScale = zoomScale * 1.4;
//	else						// 화면보다 큰 이미지
//		maxScale = scrScale * 1.7;
//    
//    minScale = MIN(xScale,yScale);
//
//	NSLog(@"min %f max %f",minScale,maxScale);

    if(xScale < 1.0 || yScale < 1.0)
		maxScale = MAX(1.0/xScale, 1.0/yScale) * 3.0;
	else
		maxScale = MAX(xScale, yScale) * 3.0;
    
//	NSLog(@"calc-maxScale %f",maxScale);
	
    maxScale = MIN(maxScale, 2.2);
    
//    NSLog(@"RESULT minScale %f maxScale %f",minScale,maxScale);
    
	self.contentSize = imageSize;
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = zoomScale;
}

@end
