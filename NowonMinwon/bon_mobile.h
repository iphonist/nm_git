#ifndef BON_MOBILE_H__
#define BON_MOBILE_H__

#include "bon_const.h"

#ifdef DEV_ANDROID
#include <jni.h>
#endif

/*
 * BON Interface Function Return Value for Mobile
 * A: me
 * B: other
 * bon_start(), bon_stop(), bon_send_event()
*/
/* ERROR or WARNING or NORMAL EVENT > 0 */
#define BON_WARNING_ALREADY_START	1		// __reserved__
#define BON_WARNING_NOT_INIT			2 	// bon_send_event
#define BON_WARNING_NOT_CONNECT		3 	// bon_send_event
#define BON_WARNING_NOT_JOIN			4 	// bon_send_event
#define BON_WARNING_ALREADY_JOIN	5 	// bon_send_event
#define BON_WARNING_NOT_AUTH			6 	// bon_send_event
#define BON_WARNING_STOPING				7 	// bon_send_event, bon_start, bon_stop
#define BON_NORMAL								20 	// bon_start, bon_stop, bon_send_event
#define BON_ERROR_UNKNOWN					31 	// __not used__
#define BON_ERROR_MEM_ALLOC				32 	// bon_start
#define BON_ERROR_CLEAR						33 	// bon_start
#define BON_ERROR_NET_PARAM				34 	// bon_start
#define BON_ERROR_UID_PARAM				35 	// bon_start
#define BON_ERROR_SKEY_PARAM			36 	// bon_start
#define BON_ERROR_CB_PARAM				37 	// bon_start
#define BON_ERROR_WAS_IP_PARAM		38 	// bon_start
#define BON_ERROR_WAS_IP_ERROR		39 	// bon_start

/* 
 * NORMAL EVENT > 100 
 * event by callback func.
*/
#define BON_EVENT_CONNECT					101 // A Connect to BON and Auth Success
#define BON_EVENT_DISCONNECT			102 // A Socket disconnect from BON
#define BON_EVENT_AUTH_FAIL				103 // A Disconnect from BON by Auth Fail
#define BON_EVENT_TYPING					104 // Typing by B
#define BON_EVENT_JOIN_ROOM				105 // A/B Join room key
#define BON_EVENT_LEAVE_ROOM			106 // A/B Leave current room key
#define BON_EVENT_MESSAGE					107 // Receive new message from B. Update chat context
#define BON_EVENT_NOTIFY_MESSAGE	108 // B Message event on the other rook key
#define BON_EVENT_ALL_MESSAGE			109 // Receive new all message from B.

/* STATUS @ bon_get_status() */
#define BON_STATUS_DISCONNECT			1
#define BON_STATUS_CONNECT				2
#define BON_STATUS_READY					3
#define BON_STATUS_IN_CHATROOM		4
#define BON_STATUS_STOP						5

/*
 * BON Mobile Interface
*/
int bon_start(BON_CHAR_P bon_ip, int bon_port, BON_CHAR_P uid, BON_CHAR_P skey, char is3g, BON_CHAR_P was_ip, char is_enc, void *cb); // cb func param (char event, char *nickname, char *rk, char *msg);
int bon_stop(void);
int bon_send_event(char event, BON_CHAR_P uid, BON_CHAR_P rk);
int bon_get_status(void);

void BenEncryption(int len, BON_CHAR_P datain, BON_CHAR_P dataout);
void BenDecryption(int len, BON_CHAR_P datain, BON_CHAR_P dataout);

#endif
