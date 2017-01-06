//
//  HTTPExceptionHandler.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 2. 21..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPExceptionHandler : NSObject < UIAlertViewDelegate >

+ (instancetype)sharedInstance;
+ (void)handlingByError:(NSError*)error;

@property (nonatomic, retain) UIAlertView *sharedAlertView;
@end
