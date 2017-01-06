#ifndef BON_PROCESS_H__
#define BON_PROCESS_H__

#include "bon_packet.h"
#include "bon_client.h"
#include "bon_const.h"


/*
 * Response Packet
*/
int bon_res_message(BON_DESC_T *d, int len);
int bon_res_all_message(BON_DESC_T *d, int len);

/*
 * Request Packet
*/
stBonPacket *bon_connect_packet(BON_CHAR_P uid, int len, BON_CHAR_P skey, int slen, BON_CHAR_P was_ip, int was_len);
int bon_req_connect(BON_DESC_T *my_desc, BON_CHAR_P uid, BON_CHAR_P skey, BON_CHAR_P was_ip);
int bon_res_connect(BON_DESC_T *d, int len);

stBonPacket *bon_keepalive_packet();
int bon_req_keepalive(BON_DESC_T *my_desc);
int bon_res_keepalive(BON_DESC_T *d, int len);

stBonPacket *bon_typing_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len);
int bon_req_typing(BON_DESC_T *my_desc, BON_CHAR_P uid, BON_CHAR_P rk);
int bon_res_room_event(BON_DESC_T *d, int len); // B typing, join, leave server event.

stBonPacket *bon_join_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len);
int bon_req_join(BON_DESC_T *my_desc, BON_CHAR_P uid, BON_CHAR_P rk);
int bon_res_join(BON_DESC_T *d, int len);

stBonPacket *bon_leave_packet(BON_CHAR_P uid, int uid_len, BON_CHAR_P rk, int rk_len);
int bon_req_leave(BON_DESC_T *my_desc, BON_CHAR_P uid, BON_CHAR_P rk);
int bon_res_leave(BON_DESC_T *d, int len);

#endif
