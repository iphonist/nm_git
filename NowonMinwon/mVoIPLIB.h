//
//  mVoIPLIB.h
//  mVoIP
//
//  Created by 백인구 on 10. 12. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//
// for daum
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

#import <systemconfiguration/systemconfiguration.h>
#import <netinet/in.h>

@interface eventParam : NSObject {
	int status_type;
	int status_code;
	NSString *status_message;
	int prev_status_type;
}
@property (nonatomic) int status_type;
@property (nonatomic) int status_code;
@property (retain, nonatomic) NSString *status_message;
@property (nonatomic) int prev_status_type;

@end

@protocol mVoIPEventDelegate <NSObject>
	@required
		- (void) eventStatus:(eventParam *)ep;
		- (void) eventVideo:(NSData *)vi;
@end

@interface mVoIPLIB : NSObject {
	id parentObj;
	id videoObj;
	int isOutbound;
	BOOL isClosing;
	BOOL closeAudio;
	BOOL startAudio;
	BOOL startPredestroy;
	int daumHangupCode;
	int jitterBufferType;
	NSString *phoneNumber;
}

- (id) initWithDelegate:(id)singleObj;

//- (BOOL) initializes_test:(NSString *)userkey userPwd:(NSString *)userpwd Domain:(NSString *)domain serverIp:(NSString *)serverip serverPort:(NSInteger)serverport;

// - (BOOL) initializes:(NSString *)userkey userPn:(NSString *)userpn Domain:(NSString *)domain serverIp:(NSString *)serverip serverPort:(NSInteger)serverport;
- (BOOL) initializes:(NSString *)userkey userPn:(NSString *)userpn userPwd:(NSString *)userpwd Domain:(NSString *)domain serverIp:(NSString *)serverip serverPort:(NSInteger)serverport userName:(NSString *)username;
- (BOOL) destroy;

- (BOOL) call:(NSString *)phone_number daumCodec:(NSInteger)daumcodec sendCall:(BOOL)send_call jbType:(NSInteger)jbtype enableNC:(BOOL)enablenc probStart:(NSInteger)probstart probContinue:(NSInteger)probcontinue secureRTP:(BOOL)secure; // SRTP
- (BOOL) answer;
- (BOOL) hold:(BOOL)onoff;
- (BOOL) hangup:(NSInteger)hangupcode;
- (BOOL) senddigit:(char)digit;

- (BOOL) speaker:(BOOL)onoff;
- (BOOL) mute:(BOOL)onoff;
- (void) video:(NSData *)vi;
- (BOOL) vadprob:(NSInteger)probstart probContinue:(NSInteger)probcontinue;

// - (void) eventStatusLocal:(NSInteger)status_type status_Code:(NSInteger)status_code status_Message:(NSString *)status_message;
- (void) resetAudio;
- (void) eventStatusLocal:(eventParam *)epp;
- (void) videoLocal:(NSString *)jpeg Size:(NSInteger)size;
- (BOOL) isCellNetwork;
- (NSString *)getIPAddress;

- (NSInteger)getQualityStatus;
- (NSInteger)getCallTime;
- (NSInteger)getCallStatus;
- (NSInteger)getCallBytes; // ADD

- (void)setHeadsetPropertyListener:(BOOL)onoff;
- (void)eventStatusHeadset:(eventParam *)epp;

@end

