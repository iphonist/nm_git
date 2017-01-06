//
//  CustomUIKit.h
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 벤치비. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface CustomUIKit : NSObject {
}



+ (UIButton *)emptyButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

+ (UIButton *)backButtonWithTitle:(NSString *)num target:(id)target selector:(SEL)selector;

+ (UIImageView *) createImageViewWithOfFiles:(NSString *)imgName withFrame:(CGRect)frame;

+ (void)customImageNamed:(NSString *)name block:(void(^)(UIImage *image))block;

+ (UIImage *)customImageNamed:(NSString *)name;

+ (UITextField *)textFieldWithFrame:(CGRect)frame keyboardType:(UIKeyboardType)ktype placeholder:(NSString *)placeholder text:(NSString *)text clearButtonMode:(UITextFieldViewMode)cmode;

+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg delegate:(UIViewController *)con tag:(int)t;

+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg;

+ (UILabel *)labelWithText:(NSString *)title bold:(BOOL)bold fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(UITextAlignment)alignText;

+ (UIButton *)buttonWithTarget:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed;

@end
