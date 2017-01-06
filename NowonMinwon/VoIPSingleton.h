//
//  VoIPSingleton.h
//
//  Created by 백인구 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mVoIPLIB.h"
#import "mVoIPLIBconst.h"

typedef enum 
{ 
	CALL_WAIT = 0,		// VoIP Not Initialed
	CALL_INIT,			// VoIP Started & Library Initing
	CALL_DIALING,		// VoIP Started & Dialing (Send)
	CALL_RINGING,		// VoIP Started & Ringing (Recv)
	CALL_TALKING,		// VoIP Started & talking
	CALL_HOLD,			// VoIP Started & Holded
	CALL_HANGUP			// VoIP Hanguped
	
} CALL_STATUS;

@protocol VoIPCallDelegate <NSObject>
	@required
	-(void)eventStatus:(NSInteger)status_type status_Code:(NSInteger)status_code;
@end

@protocol VoIPVideoDelegate <NSObject>
	@required
	-(void)eventVideo:(NSData*)video_image;
@end

/////////////////////////////////////////////////////////////////////////////////////////////

@interface VoIPSingleton : NSObject <NSCopying, mVoIPEventDelegate>
{
@public
	id<VoIPCallDelegate> _call_target;
	id<VoIPVideoDelegate> _video_target;

	BOOL _bSendCall;
	NSString* _szServerIP;
	NSNumber* _nServerPort;
	NSString* _szServerDomain;
	NSString* _szUserKey;
	NSString* _szUserPwd;
	NSString* _szUserPhone;
	NSString* _szPeerPhone;
	NSString* _szUserName;
	
@private
	mVoIPLIB* _voip;
	NSDate* _dateTalking;

	CALL_STATUS _eCallStatus;
	BOOL _bSpeakerOn;
}

@property(nonatomic,assign) id call_target;
@property(nonatomic,assign) id video_target;

@property(nonatomic,assign) BOOL bSendCall;
@property(nonatomic,retain) NSString* szServerIP;
@property(nonatomic,retain) NSNumber* nServerPort;
@property(nonatomic,retain) NSString* szServerDomain;
@property(nonatomic,retain) NSString* szUserKey;
@property(nonatomic,retain) NSString* szUserPwd;
@property(nonatomic,retain) NSString* szUserPhone;
@property(nonatomic,retain) NSString* szPeerPhone;
@property(nonatomic,retain) NSString* szUserName;

/////////////////////////////////////////////////////////////////////////

+ (VoIPSingleton*)sharedVoIP;
+ (void)releaseVoIP;

/////////////////////////////////////////////////////////////////////////

-(CALL_STATUS)callStatus;

- (BOOL)callDigit;
- (BOOL)callSenddigit:(char)c;
- (BOOL)callStart:(NSInteger)nCodecType;
- (BOOL)callAccept;
- (BOOL)callHold;
- (BOOL)callHangup:(NSInteger)nHangupCode;
- (void)callDestroy;

- (void)callSpeaker:(BOOL)bOn;

-(BOOL)callQuerySpeakerOn;				//스피커 출력 여부 
-(BOOL)callQuerySuccessCall;			//통화 성공 여부
-(BOOL)callQueryIncommingCall;			//수신되는 전화인지 여부
-(NSTimeInterval)callQueryCallTime;		//총 통화시간 (통화연결성공이후)
-(NSInteger)callQueryNetworkQuality;	//현재 네트워크 상태
-(NSInteger)callQueryNetworkByte;		//통화시 소모된 네트워크 바이트


/////////////////////////////////////////////////////////////////////////

@end
