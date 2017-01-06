#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <time.h>
//#include <pthread.h>
//#include <error.h>
#include <errno.h>
//#include <sys/socket.h>
//#include <netdb.h>

#include "bon_utils.h"
#include "bon_packet.h"
#include "bon_const.h"
#include "bon_client.h"
#include "bon_process.h"
#include "bon_mobile.h"

#ifdef DEV_ANDROID
extern JavaVM *g_VM;
extern JNIEnv *env_main;
#endif

#define READ_LEN_CHECK(rl, l, tl) \
	rl += l; \
	if (rl > tl) { bon_debug_out("Read data length(%d) over Packet header length(%d)\n", rl, tl); return BON_FALSE; }


/*
 *
 * Response Packet
 *
*/
int bon_res_message(BON_DESC_T *d, int len)
{
	//stBonPacket *packet;
	char *pp, **p = &pp;
	char rk[BON_RK_LEN];
	char msg[BON_MSG_LEN];
	char uid[BON_UID_LEN];
	short str_len;
	char msg_type, in_active;
	int  read_len = 0;

	memset(rk, '\0', BON_RK_LEN);
	memset(msg, '\0', BON_MSG_LEN);
	memset(uid, '\0', BON_UID_LEN);

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(rk, str_len, p);
	READ_LEN_CHECK(read_len, sizeof(char), len);
	BON_GETARRAY(&msg_type, sizeof(char), p);
	READ_LEN_CHECK(read_len, sizeof(char), len);
	BON_GETARRAY(&in_active, sizeof(char), p);

	if (in_active == 2)
	{
		/* Specification 0.4 removed */
		/*
		READ_LEN_CHECK(read_len, sizeof(short), len);
		BON_GETARRAY(&str_len, sizeof(short), p);
		READ_LEN_CHECK(read_len, str_len, len);
		BON_GETARRAY(nickname, str_len, p);
		*/
		READ_LEN_CHECK(read_len, sizeof(short), len);
		BON_GETARRAY(&str_len, sizeof(short), p);
		READ_LEN_CHECK(read_len, str_len, len);
		BON_GETARRAY(msg, str_len, p);
		/* Specification 0.5 add */
		READ_LEN_CHECK(read_len, sizeof(short), len);
		BON_GETARRAY(&str_len, sizeof(short), p);
		READ_LEN_CHECK(read_len, str_len, len);
		BON_GETARRAY(uid, str_len, p);
	}
	
	if (in_active == 1) // current room // if (!strcmp(d->rk, rk))
	{
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_MESSAGE, msg_type, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_MESSAGE, msg_type, "", "", "", "", "");
#endif
	}
	else
	{
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_NOTIFY_MESSAGE, msg_type, uid, "", rk, "", msg, env_main);
#else
		d->bon_cb_event(BON_EVENT_NOTIFY_MESSAGE, msg_type, uid, "", rk, "", msg);
#endif
	}

	bon_debug_out("[PROCES] Response Message. RK:%s MessageType:%c ActiveRK:%c UniqueID:%s Message:%s \n", rk, msg_type, in_active, uid, msg);

	return BON_TRUE;
}

/* Specification 0.5 add */
int bon_res_all_message(BON_DESC_T *d, int len)
{
	//stBonPacket *packet;
	char *pp, **p = &pp;
	char rk[BON_RK_LEN];
	char msg[BON_MSG_LEN];
	char uid[BON_UID_LEN];
	char nickname[BON_NICKNAME_LEN];
	char lastidx[BON_LASTIDX_LEN];
	short str_len;
	char msg_type, in_active;
	int  read_len = 0;

	memset(rk, '\0', BON_RK_LEN);
	memset(msg, '\0', BON_MSG_LEN);
	memset(uid, '\0', BON_UID_LEN);
	memset(nickname, '\0', BON_NICKNAME_LEN);
	memset(lastidx, '\0', BON_LASTIDX_LEN);

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	/* ROOM KEY */
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(rk, str_len, p);

	/* MESSAGE TYPE */
	READ_LEN_CHECK(read_len, sizeof(char), len);
	BON_GETARRAY(&msg_type, sizeof(char), p);

	/* SENDER UID */
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(uid, str_len, p);

	/* SENDER NICKNAME */
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(nickname, str_len, p);

	/* MESSAGE LAST INDEX */
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(lastidx, str_len, p);

	/* MESSAGE */
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&str_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, str_len, len);
	BON_GETARRAY(msg, str_len, p);

#ifdef DEV_ANDROID
	d->bon_cb_event(BON_EVENT_ALL_MESSAGE, msg_type, uid, nickname, rk, lastidx, msg, env_main);
#else
	d->bon_cb_event(BON_EVENT_ALL_MESSAGE, msg_type, uid, nickname, rk, lastidx, msg);
#endif

	bon_debug_out("[PROCES] Response All Message. RK:%s MessageType:%c ActiveRK:%c UniqueID:%s Message:%s \n", rk, msg_type, in_active, uid, msg);

	return BON_TRUE;
}


/*
 *
 * Request Packet
 *
*/

/*
 * BON Connect
*/
stBonPacket *bon_connect_packet(BON_CHAR_P uid, int len, BON_CHAR_P skey, int slen, BON_CHAR_P was_ip, int was_len)
{
	BON_PREFIX(BON_CMD_CONNECT, BON_MSG_10);

	BON_PUTSTRING(uid, len, packet);
	BON_PUTARRAY("0", sizeof(char), packet); // 0:WiFi  1:3G
	BON_PUTSTRING(skey, slen, packet);
	BON_PUTSTRING(was_ip, was_len, packet); // Spec 0.8

	BON_BODYEND();
	if (g_bon_enc) BenEncryption(uiLength, (T_OCTET *)temp, (T_OCTET *)temp);
	BON_POSTFIX();

	return p;
}

int bon_req_connect(BON_DESC_T *d, BON_CHAR_P uid, BON_CHAR_P skey, BON_CHAR_P was_ip)
{
	bon_debug_out("[PROCES] Request Connect(Auth) UniqueID:%s (LEN:%d)\n", uid, strlen(uid));
	stBonPacket *packet;

	packet = bon_connect_packet(uid, strlen(uid), skey, strlen(skey), was_ip, strlen(was_ip));

	bon_send_message(packet);

	BON_FREE(packet->header); BON_FREE(packet);

	return BON_TRUE;
}

int bon_res_connect(BON_DESC_T *d, int len)
{
	//stBonPacket *packet;
	char *pp, **p = &pp;
	short ret_code, keep_alive_period;
	int read_len = 0;

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&ret_code, sizeof(short), p);
	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&keep_alive_period, sizeof(short), p);

	bon_debug_out("[PROCES] Response Connect(Auth) Return Code:%d, Keep Alive Period:%d\n", ret_code, keep_alive_period);

	if (ret_code == 0)
	{
		d->keep_alive_period = keep_alive_period;
		d->status = BON_STATUS_READY;
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_CONNECT, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_CONNECT, 0, "", "", "", "", "");
#endif
		return BON_TRUE;
	}

	// else
#ifdef DEV_ANDROID
	d->bon_cb_event(BON_EVENT_AUTH_FAIL, 0, "", "", "", "", "", env_main);
#else
	d->bon_cb_event(BON_EVENT_AUTH_FAIL, 0, "", "", "", "", "");
#endif

	return BON_FALSE;
}


/*
 * BON Keep Alive
*/
stBonPacket *bon_keepalive_packet()
{
	BON_PREFIX(BON_CMD_CONNECT, BON_MSG_11);

	BON_BODYEND();
	BON_POSTFIX();

	return p;
}

int bon_req_keepalive(BON_DESC_T *d)
{
	bon_debug_out("[PROCES] Request Keep Alive\n");
	stBonPacket *packet;

	packet = bon_keepalive_packet();

	bon_send_message(packet);

	BON_FREE(packet->header); BON_FREE(packet);

	return BON_TRUE;
}

int bon_res_keepalive(BON_DESC_T *d, int len)
{
	// stBonPacket *packet;
	char *pp, **p = &pp;
	short ret_code;
	int read_len = 0;

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&ret_code, sizeof(short), p);

	bon_debug_out("[PROCES] Response Keep Alive Return Code:%d\n", ret_code);

	return BON_TRUE;
}


/*
 * BON Typing & Join/Leave Event
*/
int bon_res_room_event(BON_DESC_T *d, int len)
{
	char *pp, **p = &pp;
	char room_event_type;
	int read_len = 0;
	short rk_len;
	char rk[BON_RK_LEN];

	memset(rk, '\0', BON_RK_LEN);

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&rk_len, sizeof(short), p);
	READ_LEN_CHECK(read_len, rk_len, len);
	BON_GETARRAY(rk, rk_len, p);	
	READ_LEN_CHECK(read_len, sizeof(char), len);
	BON_GETARRAY(&room_event_type, sizeof(char), p);

	bon_debug_out("[PROCES] Receive Event Type : %d\n", room_event_type);

	if (room_event_type <= 0 || room_event_type > 3)
		return BON_FALSE;
	if (room_event_type == 1) // typing
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_TYPING, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_TYPING, 0, "", "", "", "", "");
#endif
	else if (room_event_type == 2) // join
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_JOIN_ROOM, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_JOIN_ROOM, 0, "", "", "", "", "");
#endif
	else if (room_event_type == 3) // leave
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "");
#endif
	else
		bon_debug_out("[PROCES] Unknown Receive Event Type : %d\n", room_event_type);

	return BON_TRUE;
}


stBonPacket *bon_typing_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len)
{
	BON_PREFIX(BON_CMD_EVENT, BON_MSG_10);

	BON_PUTSTRING(uid, uid_len, packet);
	BON_PUTSTRING(rk, rk_len, packet);

	BON_BODYEND();
	if (g_bon_enc) BenEncryption(uiLength, (T_OCTET *)temp, (T_OCTET *)temp);
	BON_POSTFIX();

	return p;
}

int bon_req_typing(BON_DESC_T *d, BON_CHAR_P uid, BON_CHAR_P rk)
{
	bon_debug_out("[PROCES] Request Typing Event. UniqueID:%s RoomKey:%s\n", uid, rk);
	stBonPacket *packet;

	packet = bon_typing_packet(uid, strlen(uid), rk, strlen(rk));

	bon_send_message(packet);

	BON_FREE(packet->header); BON_FREE(packet);

	return BON_TRUE;
}


/*
 * BON Join Room
*/
stBonPacket *bon_join_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len)
{
	BON_PREFIX(BON_CMD_ROOM, BON_MSG_10);

	BON_PUTSTRING(uid, uid_len, packet);
	BON_PUTSTRING(rk, rk_len, packet);

	BON_BODYEND();
	if (g_bon_enc) BenEncryption(uiLength, (T_OCTET *)temp, (T_OCTET *)temp);
	BON_POSTFIX();

	return p;
}

int bon_req_join(BON_DESC_T *d, BON_CHAR_P uid, BON_CHAR_P rk)
{
	bon_debug_out("[PROCES] Request Join Room UniqueID:%s, RoomKey:%s\n", uid, rk);
	stBonPacket *packet;

	packet = bon_join_packet(uid, strlen(uid), rk, strlen(rk));

	bon_send_message(packet);

	BON_FREE(packet->header); BON_FREE(packet);

	return BON_TRUE;
}

int bon_res_join(BON_DESC_T *d, int len)
{
	//stBonPacket *packet;
	char *pp, **p = &pp;

	short ret_code;
	char status_response;
	int read_len = 0;

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&ret_code, sizeof(short), p);
	READ_LEN_CHECK(read_len, sizeof(char), len);
	BON_GETARRAY(&status_response, sizeof(char), p);

	bon_debug_out("[PROCES] Response Join Return Code:%d, Status :%d\n", ret_code, status_response);

	if (ret_code > 0)
	{
		return BON_FALSE;
	}
	d->status = BON_STATUS_IN_CHATROOM;	

	if (status_response == 1) // B is Logoff
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "");
#endif
	else if (status_response == 2) // B is Logon
#ifdef DEV_ANDROID
		d->bon_cb_event(BON_EVENT_JOIN_ROOM, 0, "", "", "", "", "", env_main);
#else
		d->bon_cb_event(BON_EVENT_JOIN_ROOM, 0, "", "", "", "", "");
#endif

	return BON_TRUE;
}


/*
 * BON Leave Room
*/
stBonPacket *bon_leave_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len)
{
	BON_PREFIX(BON_CMD_ROOM, BON_MSG_11);

	BON_PUTSTRING(uid, uid_len, packet);
	BON_PUTSTRING(rk, rk_len, packet);

	BON_BODYEND();
	if (g_bon_enc) BenEncryption(uiLength, (T_OCTET *)temp, (T_OCTET *)temp);
	BON_POSTFIX();

	return p;
}

int bon_req_leave(BON_DESC_T *d, BON_CHAR_P uid, BON_CHAR_P rk)
{
	bon_debug_out("[PROCES] Request Leave Room UniqueID:%s, RoomKey:%s\n", uid, rk);
	stBonPacket *packet;

	packet = bon_leave_packet(uid, strlen(uid), rk, strlen(rk));

	bon_send_message(packet);

	BON_FREE(packet->header); BON_FREE(packet);

	return BON_TRUE;
}

int bon_res_leave(BON_DESC_T *d, int len)
{
	// stBonPacket *packet;
	char *pp, **p = &pp;
	short ret_code;
	int read_len = 0;

	pp = d->inbuf + d->intop + BON_HEADER_SIZE;

	READ_LEN_CHECK(read_len, sizeof(short), len);
	BON_GETARRAY(&ret_code, sizeof(short), p);

	bon_debug_out("[PROCES] Response Leave Return Code:%d\n", ret_code);

	if (ret_code > 0)
	{
		return BON_FALSE;
	}

	d->status = BON_STATUS_READY;	
#ifdef DEV_ANDROID
	d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "", env_main);
#else
	d->bon_cb_event(BON_EVENT_LEAVE_ROOM, 0, "", "", "", "", "");
#endif
	return BON_TRUE;
}
