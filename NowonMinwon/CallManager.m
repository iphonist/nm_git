//
//  CallManager.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 2. 5..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "CallManager.h"
#import <objc/runtime.h>
#import "ring.h"
#import "VoIPSingleton.h"


const char alertNumber;

@implementation CallManager
@synthesize audioPlayer;
@synthesize fromName;
@synthesize toName;
//@synthesize savedNum;

- (void)closeAllCallView{
    NSLog(@"closeAllCallView \n out %@ \n income %@ \n call %@",fullOutgoingView,fullIncomingView,fullCallingView);
    
//    [SharedAppDelegate.root stopRingSound];
//    if(outgoingView)
    //        [self cancelSideOutgoing];
    if(fullOutgoingView){
//        [self cancelFullOutgoing];
        [fullOutgoingView removeFromSuperview];
//        [fullOutgoingView release];
        fullOutgoingView = nil;
    }
//    if(incomingView)
//        [self cancelSideIncoming];
    if(fullIncomingView){
//        sip_ring_stop();
//        sip_ring_deinit();
 [SharedAppDelegate.root stopRingSound];
        //        [self cancelFullOutgoing];
        [fullIncomingView removeFromSuperview];
//        [fullIncomingView release];
        fullIncomingView = nil;
    }
//    if(callingView)
//        [self cancelSideCalling];
    if(fullCallingView){
        //        [self cancelFullOutgoing];
        [fullCallingView removeFromSuperview];
//        [fullCallingView release];
        fullCallingView = nil;
    }
//      [[VoIPSingleton sharedVoIP] callSpeaker:NO];
//	[SharedAppDelegate.root setAudioRoute:NO];
//    sip_ring_stop();
//    sip_ring_deinit();
    
    [SharedAppDelegate.root setAudioRoute:NO];
    [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    [self isCallingByPush:NO];
    viewShown = NO;
//  



    
}

- (void)callAlert:(NSString *)number{
    
    NSLog(@"number %@",number);
    
    UIAlertView *alert;
    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 연결하시겠습니까?",number];
    alert = [[UIAlertView alloc] initWithTitle:@"일반통화" message:msg delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    objc_setAssociatedObject(alert, &alertNumber, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    
    if(buttonIndex == 1)
    {
        NSString *number = objc_getAssociatedObject(alertView, &alertNumber);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
            
        
    }
    
}

#pragma mark - sount output

- (void)playDialingSound
{
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"lemp_ringbacktone" ofType:@"wav" inDirectory:NO];
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:soundPath] error:nil];
	newPlayer.numberOfLoops = -1;
	
	self.audioPlayer = newPlayer;
	
	[audioPlayer prepareToPlay];
	[audioPlayer play];
}


- (void)stopDialingSound
{
	if ([audioPlayer isPlaying]) {
		[audioPlayer stop];
    }
    if(self.audioPlayer){
        self.audioPlayer = nil;
    }
}

#pragma mark - mvoip

- (void)mvoipOutgoingWith:(NSString *)num{
    
    NSLog(@"mvoipOutgoingWith %@",num);
    
 
    NSString *myPhone = [SharedAppDelegate readPlist:@"phone_number"];
    NSString *peerPhone = [SharedAppDelegate.root getPureNumbers:num];
    NSString *userPassword = [NSString stringWithFormat:@"min%@jun", myPhone];
    
	[VoIPSingleton sharedVoIP].bSendCall = YES;
	[VoIPSingleton sharedVoIP].szServerIP = [SharedAppDelegate readPlist:@"mvoip"];
	[VoIPSingleton sharedVoIP].nServerPort = [NSNumber numberWithUnsignedInt:62234];
	[VoIPSingleton sharedVoIP].szServerDomain = [SharedAppDelegate readPlist:@"sip_domain"];
	[VoIPSingleton sharedVoIP].szUserKey = myPhone;// userKey;
    [VoIPSingleton sharedVoIP].szUserName = myPhone;// userName;
    [VoIPSingleton sharedVoIP].szPeerPhone = peerPhone;
    [VoIPSingleton sharedVoIP].szUserPhone = myPhone;// userPhone;
    [VoIPSingleton sharedVoIP].szUserPwd = userPassword;
    
    NSLog(@"myphone %@ peerphone %@ userpassword %@",myPhone,peerPhone, userPassword);
    
    [cancel setEnabled:YES];
    
    NSLog(@"1");
	[VoIPSingleton sharedVoIP].call_target = self;
    
    NSLog(@"IP:%@ domain:%@",[SharedAppDelegate readPlist:@"voip"],[SharedAppDelegate readPlist:@"sip_domain"]);
    
    NSLog(@"2");
	if ([[VoIPSingleton sharedVoIP] callStatus] == CALL_WAIT)
    {
        NSLog(@"3");
		if ([[VoIPSingleton sharedVoIP] callStart:DCODEC_ALAW] == NO)
        {
            NSLog(@"4");
			return;
		}
	}
    
}



- (void)eventStatus:(NSInteger)status_type status_Code:(NSInteger)status_code
{
	if (status_type == DEVENT_DIALING)
	{
		// do nothing
		NSLog(@"DEVENT_DIALING\n");
		[self playDialingSound];
	}
	else if (status_type == DEVENT_RINGING)
	{
		//TODO play Ringback Tone....
		NSLog(@"DEVENT_RINGING\n");
		[answer setEnabled:YES]; 
	}
	else if (status_type == DEVENT_CALL)
	{
		// do nothing
		NSLog(@"DEVENT_CALL\n");
		[self stopDialingSound];
        [SharedAppDelegate.window addSubview:[self setFullCalling]];
        //		[self showCalling];
		
	}
	else if (status_type == DEVENT_HOLD)
	{
		// do nothing
		NSLog(@"DEVENT_HOLD\n");
	}
	else if (status_type == DEVENT_HANGUP)
	{
		NSLog(@"DEVENT_HANGUP\n");
		[self stopDialingSound];
        [self closeAllCallView];

		[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
		[[VoIPSingleton sharedVoIP] callDestroy];
		
		NSLog(@"fromName %@ toName %@",self.fromName,self.toName);
        NSString *szByte = @"";//[[NSString alloc]init];
        
        if(status_code == DHANGUP_BUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOANSWER)
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받지않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_REJECT && [self.fromName isEqualToString:@""])
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받을 수 없는 상황입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_FAILURE)
            szByte = [NSString stringWithFormat:@"전화를 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_RTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TORTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"상대방 네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_CONGESTION)
            szByte = [NSString stringWithFormat:@"통화량이 많아 서비스가 제공되지 않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOPERMIT)
            szByte = [NSString stringWithFormat:@"해당 번호로 전화를 걸 권한이 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_INCOMINGTIMEOUT)
            szByte = [NSString stringWithFormat:@"수신대기 시간을 초과하였습니다. (%d)",(int)status_code];
        else if(status_code > 29 && status_code < 40)
            szByte = [NSString stringWithFormat:@"mVoIP 서버에 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == 43)
            szByte = [NSString stringWithFormat:@"mVoIP 연동이 되어 있지 않습니다. (%d)",(int)status_code];
        else if(status_code > 39 && status_code < 50)
            szByte = [NSString stringWithFormat:@"mVoIP 계정에 문제가 있어 발신이 제한됐습니다. (%d)",(int)status_code];
        else if(status_code > 49 && status_code < 70 && status_code != 56 && status_code != 57)
            szByte = [NSString stringWithFormat:@"mVoIP 관리서버 연결에 문제가 있습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASCALEEBUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASNOCALLER)
            szByte = [NSString stringWithFormat:@"발신자가 전화를 끊은 상태입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TO3GCALL)
            szByte = [NSString stringWithFormat:@"상대방에게 3G 전화가 와서 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_MPDND)
            szByte = [NSString stringWithFormat:@"상대방이 수신거부를 설정해놓았습니다. (%d)",(int)status_code];
        
        NSLog(@"status_code %d",(int)status_code);
        NSLog(@"szByte %@",szByte);
        
        if(szByte != nil && [szByte length]>0)
        {
            [CustomUIKit popupAlertViewOK:nil msg:szByte];
        }
	} else {
		[self stopDialingSound];
	}
}


- (void)alreadyHangup{
//	[SharedAppDelegate.root setAudioRoute:NO];
    [CustomUIKit popupAlertViewOK:nil msg:@"이미 종료된 전화입니다."];
    [self closeAllCallView];
}

- (void)checkPush{
    if(callingByPush){
        [self alreadyHangup];
    }
}

- (void)isCallingByPush:(BOOL)yn{
    callingByPush = yn;
}

- (void)isViewShown:(BOOL)yn{
    viewShown = yn;
}




- (void)cancelFullOutgoing{
    NSLog(@"cancelFullOutgoing");

    fullOutgoingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_CANCEL];

    [self closeAllCallView];

//    if(fullOutgoingView == nil)
//        return;
//    
//    [fullOutgoingView removeFromSuperview];
//    [fullOutgoingView release];
//    fullOutgoingView = nil;
    
}



#pragma mark - calling UI

- (UIView *)setFullOutgoing:(NSString *)number
{
    
    NSLog(@"SetFulloutgoing %@",number);
    if(fullOutgoingView)
        return nil;
    
    if ([number length]<1 || number == nil) {
        return nil;
    }
    
    bIncoming = NO;
    
    NSString *myPhone = [SharedAppDelegate readPlist:@"phone_number"];
  
    
    self.fromName = myPhone;//@"";
    self.toName = number;//[[NSString alloc]initWithFormat:@"%@",dic[@"name"]];
   
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    
    fullOutgoingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullOutgoingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
    
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    [coverImageView setImage:defaultImage];
    [fullOutgoingView addSubview:coverImageView];
    [coverImageView release];
    //    [imageView release];
    
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
    
    
    
    
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
    [fullOutgoingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
    [fullOutgoingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" bold:NO fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:UITextAlignmentCenter];//labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:UITextAlignmentCenter];
    [fullOutgoingView addSubview:label];
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView;
    profileView = [CustomUIKit createImageViewWithOfFiles:@"call_nophoto.png" withFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
    [fullOutgoingView addSubview:profileView];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
  
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, 320, fullOutgoingView.frame.size.height - coverImageView.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    [fullOutgoingView addSubview:imageView];
   
    
    if(IS_HEIGHT568)
        gap = 20;
    
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTarget:self selector:@selector(speakerOnOff:) frame:CGRectMake(122, coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - gap, 75, 75) imageNamedNormal:@"button_call_speaker_on.png" imageNamedPressed:@""];//buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerOnOff:) frame:CGRectMake(122, coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - gap, 75, 75) imageNamedBullet:nil imageNamedNormal:@"button_call_speaker_on.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:speaker];
    [speaker release];
    
    if(IS_HEIGHT568)
        gap = 15;
    UILabel *toLabel;
    toLabel = [CustomUIKit labelWithText:self.toName bold:YES fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:UITextAlignmentCenter];//labelWithText:toName fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:UITextAlignmentCenter];
    [fullOutgoingView addSubview:toLabel];
    
//    UILabel *positionLabel;
//    positionLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]] fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:UITextAlignmentCenter];
//    [fullOutgoingView addSubview:positionLabel];
    
    
    
    cancel = [CustomUIKit buttonWithTarget:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:@""];//buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    [cancel setEnabled:NO];
    [cancel release];
    
    label = [CustomUIKit labelWithText:@"발신전화" bold:YES fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:UITextAlignmentCenter];//labelWithText:@"발신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:UITextAlignmentCenter];
//    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
    
    [self mvoipOutgoingWith:number];
    
    return fullOutgoingView;
}

- (UIView *)setFullCalling{//:(NSDictionary *)dic{//(NSString *)num name:(NSString *)name{
    
//    NSLog(@"setFullCalling %@",self.savedNum);
    
    if(fullCallingView)
        return nil;    
    

    
    if(fullOutgoingView){
    [fullOutgoingView removeFromSuperview];
    [fullOutgoingView release];
    fullOutgoingView = nil;
    }

    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    
//    talkingTime = @"";
    fullCallingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullCallingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_01.png" withFrame:CGRectMake(0, 0, 320, 98)];
    [fullCallingView addSubview:imageView];
//    [imageView release];
    
    UIImageView *profileView;
    profileView = [CustomUIKit createImageViewWithOfFiles:@"call_nophoto.png" withFrame:CGRectMake(13, 13, 71, 71)];
    [fullCallingView addSubview:profileView];
//    [profileView release];
    
    
    UIImageView *coverView;
    coverView = [CustomUIKit createImageViewWithOfFiles:@"call_photocover.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    [profileView addSubview:coverView];
//    [coverView release];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_02.png" withFrame:CGRectMake(0, 98, 320, 26)];
    [fullCallingView addSubview:imageView];
//    [imageView release];

    
        imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
    [fullCallingView addSubview:imageView];
//    [imageView release];

    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
    [fullCallingView addSubview:imageView];
//    [imageView release];

    
    
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTarget:self selector:@selector(speakerLargeOnOff:) frame:CGRectMake(103, height/2-55, 113, 113) imageNamedNormal:@"speaker_on.png" imageNamedPressed:@""];//buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerLargeOnOff:) frame:CGRectMake(103, height/2-55, 113, 113) imageNamedBullet:nil imageNamedNormal:@"speaker_on.png" imageNamedPressed:nil];
    [fullCallingView addSubview:speaker];
    [speaker release];
    
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:self.toName bold:NO fontSize:19 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 20, 200, 22) numberOfLines:1 alignText:UITextAlignmentLeft];//labelWithText:@"" fontSize:19 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 20, 200, 22) numberOfLines:1 alignText:UITextAlignmentLeft];
    [fullCallingView addSubview:label];
    if([self.toName length]>0)
        label.text = self.toName;
    if([self.fromName length]>0)
        label.text = self.fromName;
    NSLog(@"label.text %@",label.text);
//    [label release];
    
    
    
    //    time = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 48, 200, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //    [fullCallingView addSubview:time];
    //	[time retain];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(100, 48, 200, 17)];
    [time setFont:[UIFont boldSystemFontOfSize:14]];
    [time setTextColor:[UIColor whiteColor]];
    [time setTextAlignment:NSTextAlignmentLeft];
    [time setBackgroundColor:[UIColor clearColor]];
    [fullCallingView addSubview:time];
    
    //    qual = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 65, 217, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //    [qual retain];
    
    qual = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 217, 17)];
    [qual setFont:[UIFont boldSystemFontOfSize:14]];
    [qual setTextColor:[UIColor whiteColor]];
    [qual setTextAlignment:NSTextAlignmentLeft];
    [qual setBackgroundColor:[UIColor clearColor]];
    [fullCallingView addSubview:qual];
    
    
    cancel = [CustomUIKit buttonWithTarget:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(24, height-20-44, 272, 44) imageNamedNormal:@"call_endbtn.png" imageNamedPressed:@""];//buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(24, height-20-44, 272, 44) imageNamedBullet:nil imageNamedNormal:@"call_endbtn.png" imageNamedPressed:nil];
    [fullCallingView addSubview:cancel];
    [cancel release];
    
//    [cancel release];
    
    if (_timerQual == nil)
    {
        _timerQual = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(qualTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    if (_timerCall == nil)
    {
        _timerCall = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(callTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    

    return fullCallingView;
}
//
//
- (void)speakerOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)speakerLargeOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeLargeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)changeLargeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}
- (void)changeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}

- (void)callTimer:(NSTimer*)timer
{
    
	NSString* szByte = [NSString stringWithFormat:@"%d KB", (NSInteger)((float)[[VoIPSingleton sharedVoIP] callQueryNetworkByte])/1024];
    int hour = 0;
    int minute = (NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]/60;
    int second = (NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]%60;
    if(minute > 60)
    {
        hour = minute/60;
        minute = minute%60;
        
    }
	time.text = [NSString stringWithFormat:@"%02d:%02d:%02d / %@",hour,minute,second,szByte];
    
}

- (void)qualTimer:(NSTimer *)timer
{

    
    NSString *quality;
    quality = [NSString stringWithFormat:@"%d%%",(NSInteger)[[VoIPSingleton sharedVoIP] callQueryNetworkQuality]];
    qual.text = quality;
    
    if([quality intValue] < 80)
        qual.text = [quality stringByAppendingString:@" 네트워크 환경이 좋지 않습니다."];
}


- (void)cancelFullCalling{
    NSLog(@"cancelFullCalling");

//    if(talkingTime){
//        [talkingTime release];
//        talkingTime = nil;
//    }
//    talkingTime = [[NSString alloc]initWithFormat:@"%@",time.text];
    fullCallingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP] callHangup:0];

//    if(fullCallingView == nil)
//        return;
//    
//    [fullCallingView removeFromSuperview];
//    [fullCallingView release];
//    fullCallingView = nil;
//    
    [self closeAllCallView];
//
    if (_timerQual)
    {
        [_timerQual invalidate];
        _timerQual = nil;
    }
    
    if (_timerCall)
    {
        [_timerCall invalidate];
        _timerCall = nil;
    }
    
}



@end
