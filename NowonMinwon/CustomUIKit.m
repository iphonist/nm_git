//
//  CustomUIKit.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 벤치비. All rights reserved.
//

#import "CustomUIKit.h"



@implementation CustomUIKit



+ (UIButton *)buttonWithTarget:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed
{
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	UIImage *imageButtonNormal  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedNormal ofType:nil]]; 
	UIImage *imageButtonPressed = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedPressed ofType:nil]]; 

	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	button.adjustsImageWhenDisabled = YES;
	button.adjustsImageWhenHighlighted = YES;
	
    
	[button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient,
    
	
	// 버튼 이미지 설정
	if (imageNamedNormal) [button setBackgroundImage:imageButtonNormal  forState:UIControlStateNormal];
	if (imageNamedPressed) [button setBackgroundImage:imageButtonPressed forState:UIControlStateHighlighted];
	
	// 버튼 눌린 경우 엑션 설정
	[button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
	

	
	return button;
}



+ (UILabel *)labelWithText:(NSString *)title bold:(BOOL)bold fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(UITextAlignment)alignText
{
	UILabel *label = [[[UILabel alloc] initWithFrame:frame]autorelease];
	
	label.text = title;
	label.textAlignment = alignText; // UITextAlignmentCenter;
	label.numberOfLines = numberOfLines;
	label.textColor = fontColor;
	[label setBackgroundColor:[UIColor clearColor]];
//	[label setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]]; // Helvetica-Bold
    if(bold)
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    else
		label.font = [UIFont systemFontOfSize:fontSize];
	return label;
}


+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg
{
    if([title length]<1)
        title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:@"확인", nil];
	[alert show];
    
}

+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg delegate:(UIViewController *)con tag:(int)t
{
    if([title length]<1)
        title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:con
										  cancelButtonTitle:@"아니오"
										  otherButtonTitles:@"예", nil];
    alert.tag = t;
	[alert show];
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame keyboardType:(UIKeyboardType)ktype placeholder:(NSString *)placeholder text:(NSString *)text clearButtonMode:(UITextFieldViewMode)cmode
{
    
    UITextField *textField = [[[UITextField alloc]initWithFrame:frame]autorelease]; // 180
    textField.keyboardType = ktype;
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeholder;
    textField.text = text;
	textField.clearButtonMode = cmode;

    return textField;
    
}


+ (UIImage *)customImageNamed:(NSString *)name
{
    UIImage *img;
	NSString *imagePath;
	
	imagePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
	img = [UIImage imageWithContentsOfFile:imagePath];

    
	return img;
}

+ (void)customImageNamed:(NSString *)name block:(void(^)(UIImage *image))block
{

	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		
        //load image
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
			
            //cache the image
//            [cache setObject:image forKey:path];

            //return the image
            block(image);
        });
    });
}

+ (UIImageView *) createImageViewWithOfFiles:(NSString *)imgName withFrame:(CGRect)frame
{
	UIImage *img;
	NSString *imagePath;
	UIImageView *imageView;
	
	imagePath = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
	img = [UIImage imageWithContentsOfFile:imagePath];
	imageView = [[[UIImageView alloc] initWithImage:img]autorelease];
	
	imageView.frame = frame;
	
	return imageView;
}



+ (UIButton *)backButtonWithTitle:(NSString *)num target:(id)target selector:(SEL)selector{

    NSLog(@"setBackButton %@",num);
    
    NSString *back;
    

    back = @"";
    
    CGSize size = [back sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"size.width %f",size.width);
    
    UIImageView *backImageView = [[[UIImageView alloc]init]autorelease];
    backImageView.frame = CGRectMake(0, 0, 11, 18);
    UIImage *backImage = [CustomUIKit customImageNamed:@"barbutton_navigtaionbar_back.png"];//[[CustomUIKit customImageNamed:@"barbutton_navigtaionbar_back.png"]stretchableImageWithLeftCapWidth:32-3 topCapHeight:0];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = backImageView.frame;
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel *label = [[UILabel alloc]init];
//    label.textColor = RGB(41,41,41);//[UIColor whiteColor];
////    label.shadowOffset = CGSizeMake(0, -1);
////    label.shadowColor = [UIColor darkGrayColor];
//    label.numberOfLines = 0;
//    label.lineBreakMode = UILineBreakModeWordWrap;
//    label.font = [UIFont boldSystemFontOfSize:15];
//    label.frame = CGRectMake(28,6,size.width,size.height);
//    label.text = back;
//    label.backgroundColor = [UIColor clearColor];
//    [button addSubview:label];
    
    return button;
}

+ (UIButton *)emptyButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 36, 36);
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];

    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return button;
}

@end
