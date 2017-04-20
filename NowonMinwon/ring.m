//
//  ring.m
//  bSampler
//
//  Created by 백인구 on 11. 6. 28..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "ring.h"

/* Ringtones                US	       UK  */
#define RINGBACK_FREQ1	    440	    /* 400 */
#define RINGBACK_FREQ2	    480	    /* 450 */
#define RINGBACK_ON         2000    /* 400 */
#define RINGBACK_OFF        4000    /* 200 */
#define RINGBACK_CNT        1       /* 2   */
#define RINGBACK_INTERVAL   4000    /* 2000 */

#define RING_FREQ1	  800
#define RING_FREQ2	  640
#define RING_ON		    200
#define RING_OFF	    100
#define RING_CNT	    3
#define RING_INTERVAL	3000

static void sip_ring_callback(CFRunLoopTimerRef timer, void *info)
{
//    NSLog(@"sip_ring_callback");
//    AudioServicesPlayAlertSound(ring_id);
}
static void sip_vib_callback(CFRunLoopTimerRef timer, void *info)
{
//    NSLog(@"sip_vib_callback");
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void sip_ring_init()//(NSString *bell)
{
//    NSLog(@"sip_ring_init %@",ring_vib_timer);
    if(ring_vib_timer)
        return;
    
//    ring_timer = NULL;
	ring_vib_timer = NULL;
	ring_cnt = 0;
//
//    /* It is easier to use pjsua_player_create/pjsua_player_destroy
//     * but it is not possible to know if the user has configured the Settings
//     * application to vibrate on ring or not.
//     */
//    CFURLRef soundFileURLRef;
//    SystemSoundID aSoundID;
//    OSStatus oStatus;
//    // Get the main bundle for the app
//	CFBundleRef mainBundle = CFBundleGetMainBundle ();
//    // Get the URL to the sound file to play
//	soundFileURLRef  =	CFBundleCopyResourceURL (mainBundle,  (CFStringRef)bell,
//                                                 CFSTR ("wav"), NULL);
//    oStatus = AudioServicesCreateSystemSoundID (soundFileURLRef, &aSoundID);
//    //  if (oStatus == kAudioServicesNoError)
//    ring_id = aSoundID;
//    //  else
//    //    ring_id = kSystemSoundID_Vibrate;
//    CFRelease(soundFileURLRef);
    sip_ring_start();
}

void sip_ring_start()
{
//    NSLog(@"sip_ring_start %@",ring_vib_timer);
    if (++ring_cnt == 1)
    {
        
//		char *app_config; // KIKU CHECK
//        //AudioServicesPlayAlertSound(app_config->ring_id);
//        //UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
//        //AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
//        //                         sizeof(route), &route);
//        
//        CFRunLoopTimerContext context = {0, (void *)app_config, NULL, NULL, NULL};
//        
//        NSLog(@"ring_timer");
//        ring_timer = CFRunLoopTimerCreate(kCFAllocatorDefault,
//                                          CFAbsoluteTimeGetCurrent(),
//                                          2.,
//                                          0, 0, sip_ring_callback,
//                                          &context);
//        
//        CFRunLoopAddTimer(CFRunLoopGetMain(), ring_timer, kCFRunLoopCommonModes);
        
        
        char *app_config_vib;
        CFRunLoopTimerContext context_vib = {0, (void *)app_config_vib, NULL, NULL, NULL};
        
//        NSLog(@"ring_vib_timer");
        ring_vib_timer = CFRunLoopTimerCreate(kCFAllocatorDefault,
                                              CFAbsoluteTimeGetCurrent(),
                                              2.,
                                              0, 0, sip_vib_callback,
                                              &context_vib);
        
        CFRunLoopAddTimer(CFRunLoopGetMain(), ring_vib_timer, kCFRunLoopCommonModes);
        
    }
}

void sip_ring_stop()
{
//    NSLog(@"sip_ring_stop");
	if (--ring_cnt == 0)
	{
		// UInt32 route = kAudioSessionOverrideAudioRoute_None;
		// AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
		//                          sizeof(route), &route);
//		CFRunLoopTimerInvalidate(ring_timer);
//		CFRelease(ring_timer);
//		ring_timer = NULL;
		
		CFRunLoopTimerInvalidate(ring_vib_timer);
		CFRelease(ring_vib_timer);
		ring_vib_timer = NULL;
	}
}

void sip_ring_deinit()
{
//    NSLog(@"sip_ring_deinit");
//    if (ring_timer)
//    {
//        NSLog(@"ring_timer");
//        CFRunLoopRemoveTimer (CFRunLoopGetMain(), ring_timer,
//                              kCFRunLoopCommonModes);
//        CFRelease(ring_timer);
//        ring_timer = NULL;
//    }
    if (ring_vib_timer)
    {
//        NSLog(@"ring_vib_timer");
        CFRunLoopRemoveTimer (CFRunLoopGetMain(), ring_vib_timer, 
                              kCFRunLoopCommonModes);
        CFRelease(ring_vib_timer);
        ring_vib_timer = NULL;	  
    }
//    if (ring_id != kSystemSoundID_Vibrate)
//        AudioServicesDisposeSystemSoundID (ring_id);
}
