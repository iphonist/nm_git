//
//  AESExtention.h
//  SecurityTest
//
//  Created by csa2 on 13. 1. 17..
//  Copyright (c) 2013년 FLK By Ohsw. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AES128_KEY @"키값을 넣어주세요"

@interface AESExtention : NSObject

//AES128
+ (NSString*)aesEncryptString:(NSString*)textString;
+ (NSString*)aesDecryptString:(NSString*)textString;
+ (NSData*)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data;
+ (NSData*)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data;
+ (NSString*)hexEncode:(NSData *)data;
+ (NSData*) decodeHexString : (NSString *)hexString;

//SHA1
+ (NSString*)sha1:(NSString*)input;
@end
