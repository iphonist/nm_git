//
//  SharedFunctions.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CustomAddFunction)

+ (NSString *)calculateDate:(NSString *)date;// with:(NSString *)now;
//+ (NSString *)calculateDateDifferNow:(NSString *)date mode:(int)mode;
+ (NSString *)formattingDate:(NSString *)date withFormat:(NSString *)format;
+ (NSString *)stringToLinux:(NSString *)setTime;
//+ (NSString *)convertString:(NSString *)str;

@end


@interface SharedFunctions : NSObject

+ (CGSize)textViewSizeForString:(NSString*)string font:(UIFont*)font width:(CGFloat)width realZeroInsets:(BOOL)zeroInsets;
+ (void)adjustContentOffsetForTextView:(UITextView*)textView;
+ (NSMutableDictionary *)fromOldToNew:(NSDictionary *)dic object:(id)object key:(NSString *)key;
+ (NSString *)minusMe:(NSString *)uidString;
+ (void)setLastUpdate:(NSString*)date;
+ (NSString*)getMIMETypeWithFilePath:(NSString*)filePath;

//+ (NSString*)getDeviceIDForParameter;
//+ (void)saveDeviceToken:(NSString*)token status:(BOOL)status;

//+ (NSDate *)convertLocalDate;

@end
