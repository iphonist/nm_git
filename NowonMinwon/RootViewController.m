//
//  RootViewController.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 22..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "RootViewController.h"
#import "ring.h"

@interface RootViewController ()

@end


@implementation RootViewController

@synthesize mainViewController, loginViewController;
@synthesize organize;
@synthesize callManager;
@synthesize contact;

- (id)init
{
    self = [super init];
    if (self) {
        
        organize = [[OrganizeViewController alloc]init];
        mainViewController = [[MainViewController alloc]init];//[[CBNavigationController alloc]initWithRootViewController:[MainViewController new]];
        callManager = [[CallManager alloc]init];
        contact = [[ContactViewController alloc]init];
        [[ResourceLoader sharedInstance] settingDeptList];
        [[ResourceLoader sharedInstance] settingContactList];
        
        if([[SharedAppDelegate readPlist:@"sessionkey"]length]>0 && ![[SharedAppDelegate readPlist:@"lastupdate"]isEqualToString:@"0000-00-00 00:00:00"]){
        
//            [self settingLogin];
            [self settingMain];
        }
        else{

            [self settingLogin];
        }
        
        

    }
    return self;
}



#pragma mark - setting first view

- (void)settingLogin{
    if(mainViewController){
        [mainViewController.view removeFromSuperview];
        mainViewController = nil;
    }
    if(loginViewController){
        [loginViewController.view removeFromSuperview];
        loginViewController = nil;
    }
    loginViewController = [[LoginViewController alloc]init];
    [self.view addSubview:loginViewController.view];
    
}

- (void)settingMain{
    
    if(mainViewController){
        [mainViewController.view removeFromSuperview];
        mainViewController = nil;
    }
    if(loginViewController){
        [loginViewController.view removeFromSuperview];
        loginViewController = nil;
    }
    mainViewController = [[MainViewController alloc]init];
     UINavigationController *nvc = [[CBNavigationController alloc]initWithRootViewController:mainViewController];
    [self.view addSubview:nvc.view];
}

#pragma  mark - sound file

- (void)playRingSound {
    
    NSLog(@"playRingSound");//
    //    NSLog(@"playRingSound %@",isPlaying?@"YES":@"NO");
    //    if(isPlaying)
    //        return;
    //
    //    isPlaying = YES;
    NSString *bell = [SharedAppDelegate readPlist:@"bell"];
    if ([bell length] < 1) {
        bell = @"1.wav";
        [SharedAppDelegate writeToPlist:@"bell" value:bell];
    }
    NSString *sndPath = [[NSBundle mainBundle]pathForResource:bell ofType:nil inDirectory:NO];
    CFURLRef sndURL = (CFURLRef)[NSURL fileURLWithPath:sndPath];
    AudioServicesCreateSystemSoundID(sndURL, &ringSound);
    
    [self setAudioRoute:YES];
    //    sip_ring_start();
    AudioServicesPlaySystemSound(ringSound);
    sip_ring_init();
    
}

- (void)stopRingSound{
    
    NSLog(@"stopRingSound");// %@",isPlaying?@"YES":@"NO");
    //    if(!isPlaying)
    //        return;
    //
    //    isPlaying = NO;
    //        [self setAudioRoute:NO];
    AudioServicesDisposeSystemSoundID(ringSound);
    
    sip_ring_stop();
    sip_ring_deinit();
    // AudioServicesDisposeSystemSoundID
}
#pragma mark - audio


- (void)setAudioRoute:(BOOL)speaker
{
    NSLog(@"setAudioRoute %@",speaker?@"YES":@"NO");
    
    
    //    	AudioSessionInitialize(NULL, NULL, NULL, NULL);
    //    UInt32 audioRouteOverride;
    //    if(speaker == YES) audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    //    else
    //    audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    //
    //    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    //    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    //    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    //    	AudioSessionSetActive(TRUE);
    
    if(speaker == YES){
        BOOL success = NO;
        NSError *error = nil;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        success = [session setCategory:AVAudioSessionCategoryAmbient error:&error];
        if (!success) {
            NSLog(@"%@ Error setting category: %@",
                  NSStringFromSelector(_cmd), [error localizedDescription]);
            
        }
        
        success = [session setActive:YES error:&error];
        NSLog(@"success %@", success?@"YES":@"NO");
        if (!success) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
    else{
        NSError *deactivationError = nil;
        BOOL success = [[AVAudioSession sharedInstance] setActive:NO error:&deactivationError];
        NSLog(@"success %@", success?@"YES":@"NO");
        if (!success) {
            NSLog(@"%@", [deactivationError localizedDescription]);
        }
        
    }
    
    
}

- (NSString *)getPureNumbers:(NSString *)originalString
{
    
    
    //    NSString *numberString = [[originalString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789*#abcdefghijklmnopqrstuvwxyz"] invertedSet]] componentsJoinedByString:@""];
    
    
    
    
    NSString *numberString = [originalString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    
    
    return numberString;
}


#define kUpdate 2
#define kForceUpdate 3


- (void)startup{
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@",@"nowon.lemp.co.kr"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1){
        [SharedAppDelegate writeToPlist:@"lastupdate" value:@"0000-00-00 00:00:00"];
        [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요." maskType:SVProgressHUDMaskTypeBlack];
    }
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [SharedAppDelegate readPlist:@"phone_number"],@"phone_number",
                           oscode,@"oscode",
                           [SharedAppDelegate readPlist:@"devicetoken"],@"deviceid",
                                [SharedAppDelegate readPlist:@"lastupdate"],@"lastupdate",
                                [SharedAppDelegate readPlist:@"sessionkey"],@"sessionkey",
                                nil];
    
    
    NSLog(@"shared readplist session %@",[SharedAppDelegate readPlist:@"sessionkey"]);
    NSLog(@"param %@",param);
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
 
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/nowon/minwon_startup.lemp" parametersJson:jsonString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSString *isSuccess = resultDic[@"result"];
        if (![isSuccess isEqualToString:@"0"]) {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            if([isSuccess isEqualToString:@"0001"]){
                [self settingLogin];
            }
        }
        else {
            
            NSLog(@"server ver %@ app ver %@",resultDic[@"appver"],[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
            if ([resultDic[@"appver"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"updategogogogo");
                UIAlertView *alert;
                
//                if ([resultDic[@"updatever"] compare:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] options:NSNumericSearch] == NSOrderedDescending) {
                    alert = [[UIAlertView alloc] initWithTitle:@"필수 업데이트" message:@"필수 업데이트가 있습니다. 업데이트를 하셔야 정상적인 서비스 이용이 가능합니다." delegate:self cancelButtonTitle:@"지금 업데이트" otherButtonTitles:nil];
                    alert.tag = kForceUpdate;
//                } else {
//                    alert = [[UIAlertView alloc] initWithTitle:@"업데이트" message:@"새로운 업데이트가 있습니다. 기능의 원활한 이용을 위해 최신 버전으로 지금 바로 업데이트해 보세요!" delegate:self cancelButtonTitle:@"나중에" otherButtonTitles:@"지금 업데이트", nil];
//                    alert.tag = kUpdate;
//                }
                
                [alert show];
                [alert release];
                //                return;
            } else {
                NSLog(@"loghorizon");
            }
            
//            [SharedAppDelegate writeToPlist:@"menu" value:resultDic[@"menu"]];
            [SharedAppDelegate writeToPlist:@"was" value:resultDic[@"serverinfo"][@"was"]];
            [SharedAppDelegate writeToPlist:@"sip_domain" value:resultDic[@"serverinfo"][@"sip_domain"]];
            [SharedAppDelegate writeToPlist:@"mvoip" value:resultDic[@"serverinfo"][@"mvoip"]];
            [SharedAppDelegate writeToPlist:@"sip_trunk" value:resultDic[@"serverinfo"][@"sip_trunk"]];
                        NSString *lastDate = [NSString stringWithString:resultDic[@"lastsynctime"]];
            if([[SharedAppDelegate readPlist:@"lastupdate"] isEqualToString:@"0000-00-00 00:00:00"]){ // init contact
                
                NSLog(@"resultDic %@",resultDic);
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                NSMutableArray *deptArray = resultDic[@"dept"];
                
                
                if(deptArray != nil && [deptArray count]>0){
                    NSLog(@"addDept 2nd");
                    [SQLiteDBManager removeDeptWithCode:@"0" all:YES];
                    deptUpdateComplete = [SQLiteDBManager addDept:deptArray];
                } else {
                    deptUpdateComplete = YES;
                }
                [[ResourceLoader sharedInstance] settingDeptList];
                
                
                NSMutableArray *contactArray = resultDic[@"contact"];
                
                
                if(contactArray != nil && [contactArray count]>0){
                    NSLog(@"addContact 2nd");
                    [SQLiteDBManager removeContactWithUid:@"0" all:YES];
                    contactUpdateComplete = [SQLiteDBManager addContact:contactArray init:YES];
                    
                    
                } else {
                    contactUpdateComplete = YES;
                }
                [[ResourceLoader sharedInstance] settingContactList];
                
                NSLog(@"dept %@ contact %@",deptUpdateComplete?@"OK":@"NO",contactUpdateComplete?@"OK":@"NO");
                if (deptUpdateComplete && contactUpdateComplete) {
                    [SharedFunctions setLastUpdate:lastDate];
                }
            
                
                [self settingMain];
                
                [self.mainViewController setMenu:resultDic[@"menu"]];
                [[ResourceLoader sharedInstance] settingMenuList:resultDic[@"menu"]];
                [self.mainViewController setNotice:resultDic[@"notice"]];
                
                
                [SVProgressHUD showSuccessWithStatus:@"성공적으로 받아왔습니다."];
            
                
                if([SharedAppDelegate readPlist:@"initContact"] == nil || [[SharedAppDelegate readPlist:@"initContact"]length]<1){
                    [SVProgressHUD dismiss];
                    [SharedAppDelegate writeToPlist:@"initContact" value:@"YES_ios9"];
                }
            
            }
            else{
                NSLog(@"resultDic %@",resultDic);
                
                [self.mainViewController setMenu:resultDic[@"menu"]];
                [[ResourceLoader sharedInstance] settingMenuList:resultDic[@"menu"]];
                [self.mainViewController setNotice:resultDic[@"notice"]];
                
                BOOL deptUpdateComplete = NO;
                BOOL contactUpdateComplete = NO;
                BOOL passThru = YES;
                
                if([resultDic[@"dept"] count] > 0){
                    
                    deptUpdateComplete = [self compareDept:resultDic[@"dept"]];
                    [[ResourceLoader sharedInstance] settingDeptList];
                    passThru = NO;
                } else {
                    deptUpdateComplete = YES;
                }
                if([resultDic[@"contact"] count] > 0){
                    
                    contactUpdateComplete = [self compareCompany:resultDic[@"contact"]];
                    [[ResourceLoader sharedInstance] settingContactList];
                    passThru = NO;
                } else {
                    contactUpdateComplete = YES;
                }
                
                if (deptUpdateComplete && contactUpdateComplete && !passThru) {
                    [SharedFunctions setLastUpdate:lastDate];
                }
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        
        [CustomUIKit popupAlertViewOK:@"오류" msg:@"네트워크 접속이 원활하지 않습니다.\n요청한 동작이 수행되지 않을 수 있습니다.\n잠시 후 다시 시도해주세요."];
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}


#pragma mark - alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
 if(alertView.tag == kUpdate){
        if(buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];//@"itms-services://?action=download-manifest&url=http://app.thinkbig.co.kr:62230/file/ios/wjtb_teacher.plist"]];
        }
    }
    else if(alertView.tag == kForceUpdate){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
        
    }
}



#pragma mark - detect whether contact or dept is exist or not

- (BOOL)compareCompany:(NSMutableArray *)aContact{
    

    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableArray *updateArray = [NSMutableArray array];
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in aContact)//int i = 0;i < [list count]; i++)
    {
//            NSDictionary *mydic = [SharedAppDelegate readPlist:@"myinfo"];
        
            if([self checkUpdate:listDic] == YES)
            {
                NSLog(@" update data");
                
                [updateArray addObject:listDic];
            }
            
            else
            {
                
                NSLog(@" add data");
                [addArray addObject:listDic];
            }
            
        
        
    }
    
    BOOL removeContact = NO;
    BOOL addContact = NO;
    BOOL updateContact = NO;
    
    if ([deleteArray count]>0) {
        removeContact = [SQLiteDBManager removeContact:deleteArray];
    } else {
        removeContact = YES;
    }
    if([addArray count]>0) {
        //        [self addContact:addArray];
        addContact = [SQLiteDBManager addContact:addArray init:NO];
    } else {
        addContact = YES;
    }
    if([updateArray count]>0) {
        //		[self updateContactArray:updateArray];
        updateContact = [SQLiteDBManager updateContactArray:updateArray];
    } else {
        updateContact = YES;
    }
    
    return (removeContact && addContact && updateContact);
}

- (BOOL)checkUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 주소록 배열에서 딕셔너리 사번과 비교해 주소록에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 주소록 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkUpdate = NO;
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].contactList)
    {
        
        if([forDic[@"uniqueid"]isEqualToString:checkDic[@"uid"]])
        {
            checkUpdate = YES;
            break;
        }
    }
    
    return checkUpdate;
}




- (BOOL)compareDept:(NSMutableArray *)list
{
    NSLog(@"list %@",list);
    
    //    NSLog(@"reGetOrganizing",list);
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //
    NSMutableArray *updateArray = [NSMutableArray array];
    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableArray *deleteArray = [NSMutableArray array];
    
    for(NSDictionary *listDic in list)//int i = 0;i < [list count]; i++)
    {
      
            if([self checkOrganizingUpdate:listDic] == YES)
            {
                NSLog(@"update organize");
                [updateArray addObject:listDic];
            }
            else
            {
                NSLog(@"add organize");
                [addArray addObject:listDic];
            }
            
        
        
    }
    
    BOOL removeDept = NO;
    BOOL addDept = NO;
    BOOL updateDept = NO;
    if ([deleteArray count]>0) {
        removeDept = [SQLiteDBManager removeDept:deleteArray];
    } else {
        removeDept = YES;
    }
    if([addArray count]>0) {
        addDept = [SQLiteDBManager addDept:addArray];
    } else {
        addDept = YES;
    }
    if([updateArray count]>0) {
        updateDept = [SQLiteDBManager updateDeptArray:updateArray];
    } else {
        updateDept = YES;
    }
    
    return (removeDept && addDept && updateDept);

}


- (BOOL)checkOrganizingUpdate:(NSDictionary *)checkDic
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 DB에서 가져온 조직도 배열에서 딕셔너리 mycode와 비교해 조직도에 있는 딕셔너리인지 아닌지 구분한다.
     param  - dic(NSDictionary *) : 조직도 딕셔너리
     연관화면 : 없음
     ****************************************************************/
    
    
    BOOL checkOrganizingUpdate = NO;
    
    for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
        if([forDic[@"mycode"]isEqualToString:checkDic[@"deptcode"]]) {
            checkOrganizingUpdate = YES;
            break;
        }
    }
    return checkOrganizingUpdate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
