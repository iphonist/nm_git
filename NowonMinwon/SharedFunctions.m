//
//  SharedFunctions.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "SharedFunctions.h"



@implementation NSString (CustomAddFunction)


+ (NSString *)stringToLinux:(NSString *)setTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [formatter dateFromString:setTime];
    [formatter release];
	NSString *identify = [NSString stringWithFormat:@"%.0f",[dateFromString timeIntervalSince1970]];
    return identify;
}
+ (NSString *)calculateDate:(NSString *)date;{// with:(NSString *)now{
    NSDate *now2 = [NSDate date];
    NSLog(@"date int %d",[date intValue]);
    NSString *nowString = [NSString stringWithFormat:@"%.0f",[now2 timeIntervalSince1970]];
    NSLog(@"nowString %@",nowString);
    //    NSString *diffString = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    //    NSLog(@"diffsTring %@",diffString);
    NSString *interval;
    int valueInterval = [nowString intValue] - [date intValue];
    NSLog(@"valueInterval %d",valueInterval);
    if(valueInterval < 0)
    {
        int intervalPerMinute = (-valueInterval)/60;
        if(intervalPerMinute<1)
        {
            interval = @"지금곧";
        }
        else if(intervalPerMinute < 60)
        {
            interval = [NSString stringWithFormat:@"%d분후",intervalPerMinute];
        }
        else if(intervalPerMinute/60 < 24)
        {
            interval = [NSString stringWithFormat:@"%d시간후",intervalPerMinute/60];
        }
        else if(intervalPerMinute/60/24 < 100){
            interval = [NSString stringWithFormat:@"%d일후",intervalPerMinute/60/24];
            
        }
        else
            interval = @"나중에";
        
    }
    else{
        int intervalPerMinute = valueInterval/60;
        if(intervalPerMinute<1)
        {
            interval = @"방금전";
        }
        else if(intervalPerMinute < 60)
        {
            interval = [NSString stringWithFormat:@"%d분전",intervalPerMinute];
        }
        else if(intervalPerMinute/60 < 24)
        {
            interval = [NSString stringWithFormat:@"%d시간전",intervalPerMinute/60];
        }
        else if(intervalPerMinute/60/24 < 100){
            interval = [NSString stringWithFormat:@"%d일전",intervalPerMinute/60/24];
            
        }
        else
            interval = @"오래전";
    }
    return interval;
}


#define kStart 1
#define kIng 2
#define kEnd 3

//+ (NSString *)calculateDateDifferNow:(NSString *)date mode:(int)mode{// with:(NSString *)now{
//    NSDate *now2 = [NSDate date];
//    NSLog(@"date int %d",[date intValue]);
//    NSString *nowString = [NSString stringWithFormat:@"%.0f",[now2 timeIntervalSince1970]];
//    NSLog(@"nowString %@",nowString);
//    //    NSString *diffString = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
//    //    NSLog(@"diffsTring %@",diffString);
//    
//    NSString *addingString = @"";
//    
//    if(mode == kStart)
//        addingString = @"후";
//    else if(mode == kIng)
//        addingString = @"째";
//    else if(mode == kEnd)
//        addingString = @"전";
//    
//    NSString *interval;
//    int valueInterval = [nowString intValue] - [date intValue];
//    NSLog(@"valueInterval %d",valueInterval);
//    
//    
// if(valueInterval < 0)
// {
//     valueInterval = -valueInterval;
// }
//    
//        int intervalPerMinute = valueInterval/60;
//        if(intervalPerMinute<1)
//        {
//            if(mode == kStart)
//                interval = @"곧시작";
//            else if(mode == kIng)
//                interval = @"방금시작";
//            else if(mode == kEnd)
//                interval = @"방금전";
//            
//        }
//        else if(intervalPerMinute < 60)
//        {
//            interval = [NSString stringWithFormat:@"%d분%@",intervalPerMinute,addingString];
//        }
//        else if(intervalPerMinute/60 < 24)
//        {
//            interval = [NSString stringWithFormat:@"%d시간%@",intervalPerMinute/60,addingString];
//        }
//        else if(intervalPerMinute/60/24 < 1000)
//        {
//            interval = [NSString stringWithFormat:@"%d일%@",intervalPerMinute/60/24,addingString];
//            
//        }
//        else{
//            if(mode == kStart)
//                interval = @"먼미래";
//            else if(mode == kIng)
//                interval = @"오랫동안";
//            else if(mode == kEnd)
//                interval = @"오래전";
//            
//        }
////        else
////            interval = @"오래";
//
//    return interval;
//}

+ (NSString *)formattingDate:(NSString *)date withFormat:(NSString *)format{
    //    NSLog(@"date %@ format %@",date,format);
    NSDate *dateStr = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:dateStr]];
	[formatter release];
    return strTime;
    
    
}
//
//+ (NSString *)convertString:(NSString *)str{
//    NSLog(@"str %@",str);
//
//    NSDictionary *dic = [[str objectFromJSONString]objectForKey:@"chatmsg"];
//    NSLog(@"dic %@",dic);
//
//    return [dicobjectForKey:@"chatmsg"];
//}

//+ (NSString *)calculateDate:(NSDate *)date {
//NSString *interval;
//int diffSecond = (int)[date timeIntervalSinceNow];
//
//if (diffSecond < 0) { //입력날짜가 과거
//
//    //날짜 차이부터 체크
//    int valueInterval;
//    int valueOfToday, valueOfTheDate;
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaultsobjectForKey:@"AppleLanguages"];
//    NSString *currentLanguage = [languagesobjectatindex:0];
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] ];
//    [formatter setDateFormat:@"yyyyMMdd"];
//
//    NSDate *now = [SharedFunctions convertLocalDate];
//    valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘날짜
//    valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력날짜
//    valueInterval = valueOfToday - valueOfTheDate; //두 날짜 차이
//
//    if(valueInterval == 1)
//        interval = @"어제";
//    else if(valueInterval == 2)
//        interval = @"2일전";
//    else if(valueInterval == 3)
//        interval = @"3일전";
//    else if(valueInterval > 3) { //4일 이상일때는 그냥 요일, 날짜 표시
//        if ([currentLanguage compare:@"ko"] == NSOrderedSame)
//            [formatter setDateFormat:@"yyyy.MM.d a h:mm"]; //locale 한국일 경우 "년, 일" 붙이기
//        else
//            [formatter setDateFormat:@"yyyy.MM.d a h:mm"];
//        interval = [formatter stringFromDate:date];
//    } else { //날짜가 같은경우 시간 비교
//
//        [formatter setDateFormat:@"HH"];
//
//        valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘시간
//        valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력시간
//        valueInterval = valueOfToday - valueOfTheDate; //두 시간 차이
//
//        if(valueInterval == 1)
//            interval = @"1시간전";
//        else if(valueInterval >= 2)
//            interval = [NSString stringWithFormat:@"%i시간전", valueInterval];
//        else { //시간이 같은 경우 분 비교
//
//            [formatter setDateFormat:@"mm"];
//
//            valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘분
//            valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력분
//            valueInterval = valueOfToday - valueOfTheDate; //두 분 차이
//
//            if(valueInterval == 1)
//                interval = @"1분전";
//            else if(valueInterval >= 2)
//                interval = [NSString stringWithFormat:@"%i분전", valueInterval];
//            else //분이 같은 경우 차이가 1분 이내
//                interval = @"방금 전";
//            
//        }
//        
//    }
//}
//else { //입력날짜가 미래
//    NSLog(@"%s, 입력된 날짜가 미래임", __func__);
//    interval = @"방금 전";
//}
//
//
//return interval;
//}

@end


@implementation SharedFunctions

//+ (NSDate *)convertLocalDate{
//    NSDate *currentDate = [NSDate date];
//    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
//    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
//    
//    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
//    NSDate *nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
//    NSLog(@"nowDate %@",nowDate);
//    return nowDate;
//}

//+ (NSString*)getDeviceIDForParameter
//{
//	NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"];
//	if (deviceToken == nil || [deviceToken length] < 1) {
//		// DeviceID가 존재하지 않음
//		[SharedFunctions saveDeviceToken:nil status:NO];
//		deviceToken = @"dummydeviceid";
//	}
//	
//	return deviceToken;
//}
//
//+ (void)saveDeviceToken:(NSString*)token status:(BOOL)status
//{
//	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//
//	if (token == nil || [token length] < 1) {
//		if ([def objectForKey:@"PushAlertLastToken"] == nil) {
//			[def setObject:@"dummydeviceid" forKey:@"PushAlertLastToken"];
//		}
//		[def setBool:NO forKey:@"PushAlertLastStatus"];
//	} else {
//		[def setBool:status forKey:@"PushAlertLastStatus"];
//		[def setObject:token forKey:@"PushAlertLastToken"];
//	}
//	[def synchronize];
//}

+ (CGSize)textViewSizeForString:(NSString*)string font:(UIFont*)font width:(CGFloat)width realZeroInsets:(BOOL)zeroInsets
{
    UITextView *calculationView = [[UITextView alloc] init];
	
	if ([calculationView respondsToSelector:@selector(setAttributedText:)]) {
		NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
																			   attributes:@{NSFontAttributeName: font}];
		[calculationView setAttributedText:attributedString];
		[attributedString release];
	} else {
		[calculationView setText:string];
		[calculationView setFont:font];
	}
	
	CGFloat extraWidth = 0.0;
	CGFloat adjustPoint = 0.0;
	if (zeroInsets) {
		if ([calculationView respondsToSelector:@selector(textContainer)]) {
			calculationView.textContainer.lineFragmentPadding = 0.0;
			[calculationView setTextContainerInset:UIEdgeInsetsZero];
		} else {
			[calculationView setContentInset:UIEdgeInsetsMake(-8, -8, -8, -8)];
			extraWidth = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX)].width;
			adjustPoint = 16.0;
		}
	} else {
		[calculationView setContentInset:UIEdgeInsetsZero];
	}
	
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width+adjustPoint, FLT_MAX)];
	size.height -= adjustPoint;
	if (extraWidth != 0.0) {
		size.width = extraWidth;
	}

	[calculationView release];
    return size;
}

+ (void)adjustContentOffsetForTextView:(UITextView*)textView
{
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
		return;
	}
	
	CGRect line = [textView caretRectForPosition:
				   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
	- ( textView.contentOffset.y + textView.bounds.size.height
	   - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
		// We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
		// Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
		// Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

+ (NSMutableDictionary *)fromOldToNew:(NSDictionary *)dic object:(id)object key:(NSString *)key
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : mutable하지 않은 배열에서 특정 dictionary의 key에 맞는 object를 바꿔줄 때 이용한다.
     param  - dic(NSDictionary *) : 원래 dictionary
     - object(NSString *) : 바꿀 object
     - key(NSString *) : 원래 dictionary의 key
     연관화면 : 없음
     ****************************************************************/
    
    NSMutableDictionary *newDic = [[[NSMutableDictionary alloc]init]autorelease];
    NSDictionary *oldDic = (NSDictionary *)dic;
 //  		NSLog(@"oldDic %@",oldDic);
    [newDic addEntriesFromDictionary:oldDic];
    [newDic setObject:object forKey:key];
 //      NSLog(@"newDic %@",newDic);
    return newDic;
}



+ (void)setLastUpdate:(NSString*)date
{
	NSLog(@"setLastUpdate");
	if (date == nil || [date length] < 1) {
		return;
	}
    [SharedAppDelegate writeToPlist:@"lastupdate" value:date];
}

//+ (NSString*)getMIMETypeWithFilePath:(NSString*)filePath
//{
//	CFStringRef fileExtension = (__bridge CFStringRef)[filePath pathExtension];
//	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
//	CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
//	NSLog(@"mime %@",(NSString*)mimeType);
//	if (UTI != NULL) {
//		CFRelease(UTI);
//	}
//	
//	NSString *mimeTypeString = (NSString *)mimeType;
//	
//	if (mimeTypeString == nil || [mimeTypeString length] < 1) {
//		return @"application/octet-stream";
//	}
//	return mimeTypeString;
//}
@end
