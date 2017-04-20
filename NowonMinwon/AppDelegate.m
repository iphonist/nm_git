//
//  AppDelegate.m
//  NowonCustomerTest
//
//  Created by Hyemin Kim on 2014. 10. 21..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
@implementation AppDelegate

@synthesize root;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initPlist];
    [SQLiteDBManager initDB];
    [Crashlytics startWithAPIKey:@"a0e93fdaf82dfab37e7a75f3914ff871900b7c81"];
    
    NSDictionary *myInfo = (NSDictionary*)[self readPlist:@"myinfo"];
    if ([myInfo objectForKey:@"uid"]) {
        [[Crashlytics sharedInstance]setObjectValue:myInfo[@"uid"] forKey:@"uid"];
    }
    if([myInfo objectForKey:@"name"]){
        [[Crashlytics sharedInstance]setObjectValue:myInfo[@"name"] forKey:@"name"];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        [[UINavigationBar appearance] setBackgroundImage:[CustomUIKit customImageNamed:@"image_navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    } else {
        
        [UINavigationBar appearance].barTintColor = RGB(166, 205, 68);//[UIColor lightGrayColor];
    }
        
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    
    
    // push
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                             (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
//    [[Fabric sharedSDK] setDebug:YES];
    
    [self.window makeKeyAndVisible];
    
    root = [[RootViewController alloc] init];
    self.window.rootViewController = root;
    
    
    
    return YES;
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
//    NSLog(@"userinfo %@",userInfo);
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    NSDictionary *aps = userInfo[@"aps"];
//    NSLog(@"userInfo alert %@",aps[@"alert"]);
//    NSLog(@"userInfo badge %@",aps[@"badge"]);
//    NSLog(@"userInfo idx %@",aps[@"idx"]);
//    NSLog(@"userInfo ptype %@",aps[@"ptype"]);
//    NSLog(@"userInfo sound %@",aps[@"sound"]);
    
    if([aps[@"ptype"]isEqualToString:@"n"]){
    if(application.applicationState == UIApplicationStateActive) {
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,64)];
//        view.backgroundColor = [UIColor blackColor];
//        [self.window addSubview:view]; // ok
//        [CustomUIKit popupAlertViewOK:aps[@"idx"] msg:aps[@"alert"]];
        [SharedAppDelegate.root.mainViewController showNotice:aps];
    }
    else{
        [SharedAppDelegate.root.mainViewController fullNotice];
    }
        // push notice
    }
 
    
    
  
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
//	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
    
    NSMutableString *deviceTokenString = [NSMutableString string];
    const unsigned char *ptr = (const unsigned char *)[deviceToken bytes];
    for(int i =0; i <32; i++)
    {
        [deviceTokenString appendFormat:@"%02x", ptr[i]];
    }
//    NSLog(@"deviceTokenString %@",deviceTokenString);
    [SharedAppDelegate writeToPlist:@"devicetoken" value:deviceTokenString];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
//    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    [SharedAppDelegate writeToPlist:@"devicetoken" value:@"dummydeviceid"];
}
// return push on off
-(BOOL)pushNotificationOnOrOff{
    
    BOOL pushEnabled=NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            pushEnabled=YES;
        }
        else
            pushEnabled=NO;
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication]        enabledRemoteNotificationTypes];
        if (types & UIRemoteNotificationTypeAlert)
            pushEnabled=YES;
        else
            pushEnabled=NO;
    }
    
    return pushEnabled;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    NSLog(@"root.loginViewController %@",root.loginViewController);
    if([[self readPlist:@"sessionkey"]length] > 0 && ![[SharedAppDelegate readPlist:@"lastupdate"]isEqualToString:@"0000-00-00 00:00:00"])
    {
       [root startup];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) initPlist {
	
//    NSLog(@"initPlist");
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![documentsDirectory hasSuffix:@"/"]) {
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    if (NO == [fileManager fileExistsAtPath:filePath]) {
        NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"myPlist.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
    }
    
	filePath = [documentsDirectory stringByAppendingPathComponent:@"SoundList.plist"];
	if (NO == [fileManager fileExistsAtPath:filePath]) {
		NSString *filePathFromApp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SoundList.plist"];
        [fileManager copyItemAtPath:filePathFromApp toPath:filePath error:nil];
	}
}



- (void)writeToPlist:(NSString *)key value:(id)value
{
//    NSLog(@"key %@ value %@",key,value);
    
    if([value isKindOfClass:[NSNull class]] || value == nil)
        return;
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDict setObject:value forKey:key];
    [plistDict writeToFile:filePath atomically: YES];
    [plistDict release];
    
}


- (id)readPlist:(NSString *)key{
    
    //    NSLog(@"key %@",key);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myPlist.plist"];
    
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    id result = plistDict[key];
    
//    NSLog(@"key %@ result %@",key,result);
    //    NSLog(@"result %@",result);
    
    
    return result;
    /* You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key. */
}



@end
