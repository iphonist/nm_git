//
//  MRScrollView.h
//  BProject
//
//  Created by Riky.G Kim on 10. 6. 3..
//  Copyright 2010 마이리키닷넷. All rights reserved.
//

#import <UIKit/UIKit.h>

// 사진보기 시 확대,축소 처리 클래스
@interface MRScrollView : UIScrollView <UIScrollViewDelegate> {
    UIView        *imageView;
    NSUInteger     index;
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

@end
