//
//  ResourceLoader.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "ResourceLoader.h"

@implementation ResourceLoader

+ (ResourceLoader*)sharedInstance
{
	static ResourceLoader *resourceLoader = nil;
	
	if (resourceLoader == nil) {
		@synchronized(self) {
			if (resourceLoader == nil) {
				resourceLoader = [[ResourceLoader alloc] init];
				resourceLoader.deptList = [[NSMutableArray alloc] init];
				resourceLoader.contactList = [[NSMutableArray alloc] init];
				resourceLoader.allContactList = [[NSMutableArray alloc] init];
				resourceLoader.menuList = [[NSMutableArray alloc] init];
//				resourceLoader.favoriteList = [[NSMutableArray alloc] init];
				
//				resourceLoader.myUID = [SharedAppDelegate readPlist:@"myinfo"][@"uid"];
			}
		}
	}
	return resourceLoader;
}


#pragma mark - image

+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb
{
    if(!jsonString || [jsonString length] < 1){
        return nil;
    }
    NSDictionary *dict = [jsonString objectFromJSONString];
    
    NSString *filename;
    if(![dict objectForKey:@"thumbnail"] || [[dict objectForKey:@"thumbnail"] count] < 1 || thumb == NO) {
        if ([dict objectForKey:@"filename"] && [[dict objectForKey:@"filename"] count] > 0) {
            filename = [[dict objectForKey:@"filename"] objectAtIndex:num];
        } else {
            return nil;
        }
    } else {
        filename = [[dict objectForKey:@"thumbnail"] objectAtIndex:num];
    }
    
    NSString *serverAddress = [dict objectForKey:@"server"];
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@%@",[dict objectForKey:@"protocol"],serverAddress,[dict objectForKey:@"dir"],filename];
    NSURL *URL = [NSURL URLWithString:urlStr];
    return URL;
}


#pragma mark - Data Array
- (void)settingContactList
{
	NSLog(@"init Contacts");
	NSMutableArray *contactArray = [SQLiteDBManager getContact];
		
//    for(int j = 0; j < [contactArray count]; j++) {
//		for(NSDictionary *dic in _deptList) {
//            if([contactArray[j][@"deptcode"] isEqualToString:dic[@"deptcode"]]) {
//                NSString *newDeptName = dic[@"deptname"];
//				[contactArray replaceObjectAtIndex:j withObject:[SharedFunctions fromOldToNew:contactArray[j] object:newDeptName key:@"team"]];
//			}
//			
//		}
//    }
    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
	
    [contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];//sort, sortName, nil]];
	[self.contactList setArray:contactArray];
	
//	[contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    [self.allContactList setArray:contactArray];
    NSLog(@"Contacts initializing complete. %d",(int)[self.allContactList count]);

}

- (void)settingMenuList:(NSArray *)array{
    [self.menuList setArray:array];
}
- (void)settingDeptList
{
	NSLog(@"init DeptList");
    NSMutableArray *deptArray = [SQLiteDBManager getDept];

    
    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES selector:@selector(localizedStandardCompare:)];
//    NSSortDescriptor *sortTeamName = [NSSortDescriptor sortDescriptorWithKey:@"deptname" ascending:YES selector:@selector(localizedCompare:)];
    
    NSSortDescriptor *sortTeamName = [NSSortDescriptor sortDescriptorWithKey:@"deptname" ascending:YES];//
    [deptArray sortUsingDescriptors:[NSArray arrayWithObjects:sortTeamName,nil]];//sort, sortTeamName, nil]];
    [self.deptList setArray:deptArray];
}



#pragma mark - Data Search
- (NSArray *)deptRecursiveSearch:(NSString*)myCode
{
    NSLog(@"mycode %@",myCode);
	NSMutableArray *selectedDeptArray = [NSMutableArray array];
	[selectedDeptArray addObject:myCode];
	
	for (NSDictionary *dic in _deptList) {
		if ([dic[@"parentdeptcode"] isEqualToString:myCode]) {
			[selectedDeptArray addObjectsFromArray:[self deptRecursiveSearch:dic[@"deptcode"]]];
		}
	}
	
	return (NSArray*)selectedDeptArray;
}

- (NSString *)searchCode:(NSString *)code
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 공지사항을 받았을 때 조직코드에 맞는 조직이름을 찾아 리턴한다.
     param  - code(NSString *) : 조직코드
     연관화면 : 없음
     ****************************************************************/
    
    NSString *dept = [NSString string];
    for(NSDictionary *forDic in _deptList) {
        if([forDic[@"deptcode"] isEqualToString:code]) {
            dept = forDic[@"deptname"];
			break;
        }
    }
    
    return dept;
}

- (NSString *)getUserName:(NSString *)uid
{
    NSString *userName = [NSString string];
	for(NSDictionary *forDic in _allContactList) {
        if([forDic[@"uid"] isEqualToString:uid]) {
            userName = forDic[@"name"];
			break;
        }
    }
    NSLog(@"returnName %@",userName);
    return userName;
}

@end
