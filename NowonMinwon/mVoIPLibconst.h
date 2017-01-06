/*
 *  mVoIPLibconst.h
 *  mVoIP
 *
 *  Created by 백인구 on 10. 12. 15..
 *  Copyright 2010 Benchbee Co.,LTD. All rights reserved.
 *
 */

//
// for daum
//
enum _daum_jb {
	DJB_NONE = 0,
	DJB_BENCHBEE,
	DJB_SPEEX,
};

enum _daum_codec {
	DCODEC_RESERVE = 0,
	DCODEC_AUTO = 1,
	DCODEC_WIFI,
	DCODEC_3G,
	DCODEC_ALAW,
	DCODEC_G722,
	DCODEC_ILBC,
};

enum _daum_hangup_code {
	DHANGUP_RESERVE = 0, // 0 ~ 9 Reserve
	
	// 10~ 호관련 Hangup Code
	DHANGUP_NORMAL = 10,		// 정상종료
	DHANGUP_UNALLOCATED,		// 없는 번호입니다. (아운바운드콜)
	DHANGUP_BUSY,				// 상대방이 통화중입니다.
	DHANGUP_NOANSWER,			// 상대방이 전화를 받지않습니다.
	DHANGUP_REJECT,				// 상대방이 수신을 거부했습니다.
	DHANGUP_FAILURE,			// 15 전화를 연결할 수 없습니다.
	DHANGUP_CODEC,				// 코덱이 맞지 않습니다. (x)
	DHANGUP_RTPTIMEOUT,			// 네트워크 불안정으로 종료되었습니다.
	DHANGUP_TORTPTIMEOUT, // 상대방의 네트워크 불안정으로 종료되었습니다.
	DHANGUP_CONGESTION,			// 전화가 폭주하여 서버에서 전화를 연결할수 없습니다.
	DHANGUP_NOPERMIT,			// 20 발신인이 전화를 걸 권한이 없습니다. (아운바운드콜)
	DHANGUP_DND,				// 상대방이 수신거부를 설정해 놓았습니다. (아운바운드콜)
	DHANGUP_CANCEL,				// 수신이에게 RING이 울리고 있는데, 발신인이 끊었을때
	DHANGUP_INCOMINGTIMEOUT,
	
	// 30~ Network 관련 Hangup Code
	DHANGUP_NETWORK = 30,		// 서버와 연결할수 없습니다. 패킷 재전송시 실패한 경우
	DHANGUP_NETWORKTIMEOUT,		// 서버에서 응답이 없습니다.
	DHANGUP_IMPOSSIBLE,			// 발신인에게 전화를 유지할수 없은 잘못된 응답이 없습니다. (발신인데 RING이벤트 수신시)
	
	// 40~ XFon Register, Invite
  DHANGUP_AUTHFAIL = 40, // XFon이 404응답에 대해 MVoIP헤더를 없이 준 경우
  DHANGUP_TOPNFAIL, // 수산자의 번호(Invite Pool번호)를 XFon에 없는(생성못한)경우
  DHANGUP_REGISTERERROR, // XFon에 계정이 없거나 계정의 암호가 다른 경우
  DHANGUP_INVITEERROR, // XFon의 INVITE시 400외 INVITE 오류
	DHANGUP_USERKEYNULL, // 사용자 REGISTER, INVITE시 USERKEY가 없이 온 경우
	DHANGUP_DOMAINMISMATCH, // 45 사용자 REGISTER시 XFon서버와 DOMAIN이 MISMATCH된 경우
	
	// 50~ WAS ERROR
  DHANGUP_WASIPBLOCK = 50, // 해당 서버 접근제한
  DHANGUP_WASMISSINGPARAM, // WAS API 호출시 필수 파라미터 부재
  DHANGUP_WASINVALIDUSERKEY, // AuthKey 해석 불가. 존재하지 않는 마이이플 유저
  DHANGUP_WASINVALIDCALEEPN, // To PN에 해당하는 유저가 마이피플에 존재하지 않음.
  DHANGUP_WASSERVERERROR,  // 다음온 에러 산타, 푸시오류
  DHANGUP_WASMPOLDVERSION, // 55 ToPN이 VoIP를 사용하지 못하는 예전 버전인 경우
  DHANGUP_WASCALEEBUSY, // 해당 유저가 통화중
  DHANGUP_WASNOCALLER, // 전화를 수신하려고 했을 때 발신인이 이미 전화를 끊고 나간 경우
  DHANGUP_XFONWASREQUESTERROR, //  XFon -> WAS 연결이 실패한 경우
  DHANGUP_XFONWASRESPONSEERROR, // WAS의 HTTP_RESPONSE_STATUS 코드가 200이 아닌 경우
  DHANGUP_XFONWASRESPONSEBODYERROR, // 60 WAS의 HTTP_RESPONSE BODY내용이 없거나 오류인 경우
	DHANGUP_XFONWASLIMITEDNUMBER, // 제한된 번호
	
	// 100~ Extention Custom Hangup Code (Hangup명령을 통해 상대방이 직접 보내온 Hangup Code)
	DHANGUP_3GCALL = 100,		// 통화중 실제전화가 와서 연결이 종료되었을때
	DHANGUP_TO3GCALL, // 통화중 상대방에게 실제전화가 와서 연결이 종료되었을때
	DHANGUP_MPDND,				// 상대방이 수신거부를 설정해 놓았습니다. (마이피플내)
	DHANGUP_AUDIODRIVERERROR, // Android only
};

enum _daum_call_event {
	DEVENT_RESERVE = 0,
	DEVENT_DIALING,
	DEVENT_RINGING,
	DEVENT_CALL,
	DEVENT_HOLD,
	DEVENT_HANGUP, // 5
	DEVENT_PLAYDEBUG, // for PLAYOUT BUFFER DEBUG
	DEVENT_NETDEBUG, // for RTP NETWORK DEBUG
	DEVENT_HEADSET, // HEADSET PLUG(1)/UNPLUG(0)
};


// DEVENT_PLAYOUT BUFFER DEBUG
// status_code
// 0 ~ N : index diff. 재생중인 버퍼 인덱스와 RTP를 통해 입력된 버퍼 INDEX의 차이.
//       : 예를 들어 값이 10인 경우 현재 재생중인 위치앞에 10개의 미리 입력된 데이타가 존재
//       : alaw기준 1개의 패킷이 20ms 간격이므로 총 200ms 버퍼 지연이 생김
//       : 이 값이 최대 4초(alaw기준 200개)가 넘어가면 현재 재생위치에서 200개 앞으로 JUMP하여 음원을 재생함.
//       : 이 값이 3G기준 20(400ms) 정도로 유지한다면 400ms지연에서 안정적인 통화가 이루어지며
//       : 이 값이 50을 유지하고 있다면 1초의 지연이 생기면서 통화가 되고 있는 것이다.
//       : 이 값이 0이면 재생 가능한 버퍼가 없다는 뜻

// DEVENT_NETDEBUG
// status_code
//    1 : UDP recvfrom에서 RTP read시 0.1초 timeout 발생


//
// for xfonua
//
enum _call_nettype {
	TOP_RESERVE = 0,
	TOP_WIFIWIFI,
	TOP_WIFI3G,
	TOP_3GWIFI,
	TOP_3G3G,
};

