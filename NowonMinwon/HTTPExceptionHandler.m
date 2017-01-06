//
//  HTTPExceptionHandler.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 2. 21..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import "HTTPExceptionHandler.h"

@implementation HTTPExceptionHandler
@synthesize sharedAlertView;

+ (instancetype)sharedInstance
{
    static HTTPExceptionHandler* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] init]; });
	return sharedInstance;
}

+ (void)handlingByError:(NSError*)error {
	switch (error.code) {
		case NSURLErrorSecureConnectionFailed:
		case NSURLErrorServerCertificateHasBadDate:
		case NSURLErrorServerCertificateHasUnknownRoot:
		case NSURLErrorServerCertificateNotYetValid:
		case NSURLErrorServerCertificateUntrusted:
		case NSURLErrorClientCertificateRejected:
		case NSURLErrorClientCertificateRequired:
		case NSURLErrorCannotLoadFromNetwork:
		{
			// Countly Custom Event
//			NSDictionary *myInfo = [SharedAppDelegate readPlist:@"myinfo"];
//			NSString *companyCode = [SharedAppDelegate readPlist:@"custid"];
//			NSLog(@"AppVersion:%@ CompanyCode:%@ UID:%@",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"],companyCode,myInfo[@"uid"]);
//			[[Countly sharedInstance] recordEvent:@"ssl_cert_verify_error" segmentation:@{@"app_version": [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"], @"company_code":companyCode, @"uid": myInfo[@"uid"]} count:1];
	
			[[self sharedInstance] showAlertWithTag:error.code
											message:@"신뢰할 수 없는 서버로 연결되어\n접속을 해제합니다.\n보안에 문제가 있으므로 앱을 종료하시고\n서비스 담당자에게 문의 바랍니다."];
			break;
		}
		default:
			break;
	}
	
	if ([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

- (void)showAlertWithTag:(NSInteger)tag message:(NSString*)message
{
	if (!self.sharedAlertView) {
		self.sharedAlertView = [[UIAlertView alloc] initWithTitle:@"오류" message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
	}

	if (sharedAlertView.isVisible && sharedAlertView.tag == tag) {
		return;
	}
	
	sharedAlertView.message = message;
	sharedAlertView.tag = tag;
	[sharedAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	sharedAlertView.tag = 0;
}
@end
