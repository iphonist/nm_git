//
//  ResourceLoader.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceLoader : NSObject

+ (ResourceLoader*)sharedInstance;

- (void)settingContactList;
- (void)settingDeptList;

- (NSString *)searchCode:(NSString *)code;
- (NSArray *)deptRecursiveSearch:(NSString*)myCode;
- (NSString *)getUserName:(NSString *)uid;

@property (nonatomic, retain) NSMutableArray *deptList;
@property (nonatomic, retain) NSMutableArray *contactList;
@property (nonatomic, retain) NSMutableArray *allContactList;
@property (nonatomic, retain) NSMutableArray *menuList;
//@property (nonatomic, retain) NSMutableArray *favoriteList;
//@property (nonatomic, retain) NSString *myUID;
+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb;
@end
