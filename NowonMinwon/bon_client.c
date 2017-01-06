#define BON_CLIENT_C__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <netinet/in.h>
#include <netdb.h>
#ifndef DEV_IPHONE
#include <malloc.h>
#endif
#include <pthread.h>
#include <fcntl.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/resource.h>
#include <sys/types.h>
#ifndef DEV_ANDROID
#include <sys/signal.h>
#else
#include <signal.h>
#endif
#include <sys/stat.h>
#include <sys/time.h>
#ifdef DEV_LINUX
#include <arpa/telnet.h>
#endif
#ifndef AF_INET
#include <sys/socket.h>         /* BSD AF_INET */
#endif
#include "bon_utils.h"
#include "bon_packet.h"
#include "bon_const.h"
#include "bon_process.h"
#include "bon_client.h"
#include "bon_mobile.h"

BON_DESC_T *my_bon = NULL;

#ifdef DEV_ANDROID
extern JavaVM *g_VM;
extern JNIEnv *env_main;
#endif

int bon_init_socket(char *ip, int port) 
{
  static struct sockaddr_in sa_zero;
  struct sockaddr_in sa;
	struct linger ld;
  int fd, opt = 1;

  if ((fd = socket( AF_INET, SOCK_STREAM, 0)) < 0) {
    bon_debug_out("[SRVMSG] socket error : %s\n", strerror(errno));
		return -1; // abort();
  }

  if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (char *) &opt, sizeof(opt)) < 0) {
    close(fd);
    bon_debug_out("[SRVMSG] setsockopt error SO_REUSEADDR : %s\n", strerror(errno));
		return -1; // abort();
  }

  if (setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, (char *) &opt, sizeof(opt)) < 0) {
    close(fd);
    bon_debug_out("[SRVMSG] setsockopt error SO_KEEPALIVE : %s\n", strerror(errno));
		return -1; // abort();
  }

  int y = 32768, z = 32768; // 32k

  if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (char *) &y, sizeof(y)) < 0) {
    close(fd);
    bon_debug_out("[SRVMSG] setsockopt error SO_RCVBUF : %s\n", strerror(errno));
    return -1; // exit(1);
  }
  if (setsockopt(fd, SOL_SOCKET, SO_SNDBUF, (char *) &z, sizeof(z)) < 0) {
    close(fd);
    bon_debug_out("[SRVMSG] setsockopt error SO_SNDBUF : %s\n", strerror(errno));
    return -1; // exit(1);
  }

	ld.l_onoff = 0;
	ld.l_linger = 0;
  if (setsockopt(fd, SOL_SOCKET, SO_LINGER, (char *) &ld, sizeof(ld)) < 0) {
    close(fd);
    bon_debug_out("[SRVMSG] setsockopt error SO_LINGER : %s", strerror(errno));
		return -1; // abort();
  }

  sa									= sa_zero;
  sa.sin_family   		= AF_INET;
	sa.sin_addr.s_addr 	= inet_addr(ip);
  sa.sin_port     		= htons(port);

	int con;

	if ((con = connect(fd, (struct sockaddr *)&sa, sizeof(sa))) < 0)
	{
		bon_debug_out("[SRVMSG] TCP connect fail.(%d)\n", con);
    close(fd);
		return con;
	}

	bon_nonblock(fd);

  return fd;
}

void bon_new_descriptor() 
{
	if (my_bon != NULL)
	{
		my_bon->desc  	= 0;
		memset(my_bon->inbuf, '\0', BON_INBUF_LEN);
		memset(my_bon->outbuf, '\0', BON_OUTBUF_LEN);
		my_bon->ctime = time(0);
		my_bon->outtop = 0;
		my_bon->intop = 0;
		my_bon->status = BON_STATUS_DISCONNECT;

		memset(my_bon->bon_ip, '\0', BON_IP_LEN);
		my_bon->bon_port = 0;
		memset(my_bon->uid, '\0', BON_UID_LEN);
		memset(my_bon->rk, '\0', BON_RK_LEN);
		memset(my_bon->skey, '\0', BON_SESSION_LEN);
		memset(my_bon->was_ip, '\0', BON_IP_LEN);

		my_bon->keep_alive_period = 0;

		my_bon->bon_cb_event = NULL;

		bon_debug_out("[SRVMSG] Client Descriptor Create\n");
	}
}


void bon_close_socket() 
{
//	my_bon->status = BON_STATUS_DISCONNECT;

	/*
	if (my_bon->desc > 0) {
    if (FD_ISSET(my_bon->desc, &in_set))
      FD_CLR(my_bon->desc, &in_set);
    if (FD_ISSET(my_bon->desc, &o_in_set))
      FD_CLR(my_bon->desc, &o_in_set);
    if (FD_ISSET(my_bon->desc, &exc_set))
      FD_CLR(my_bon->desc, &exc_set);
    if (FD_ISSET(my_bon->desc, &out_set))
      FD_CLR(my_bon->desc, &out_set);
	}
	*/

    if (my_bon && my_bon->desc > 0 && my_bon->outtop > 0)
        bon_process_output();
    if (my_bon && my_bon->desc > 0 && (my_bon->status == BON_STATUS_CONNECT || my_bon->status == BON_STATUS_READY || my_bon->status == BON_STATUS_IN_CHATROOM)) { 
        close(my_bon->desc); 
        my_bon->desc = 0;
    }
    my_bon->status = BON_STATUS_DISCONNECT;
    bon_debug_out("[SRVMSG] Close socket...");

  return;
}


void bon_dump_header(stBonHeader *h)
{
	bon_debug_out("- BON Header Dump\n");
	bon_debug_out("  CommandID : %02X \n", h->ucCommandID);
	bon_debug_out("  MessageID : %02X \n", h->ucMessageID);
	bon_debug_out("  Version   : %d \n", h->usVersion);
	bon_debug_out("  BodyLength : %u \n", h->uiBodyLength);
}

int bon_interpret(int bufsize) 
{
	int r;
	char *point, *npoint;
	stBonHeader *header;

	npoint = my_bon->inbuf + my_bon->intop;

	header = bon_get_header(npoint);

	// bon_debug_out("# Interpret Function Enter");

	if (header == NULL) {
		bon_debug_out("[ERROR ] Header is NULL\n");
		bon_free_header(header);
		my_bon->status = BON_STATUS_STOP;
		return BON_FALSE;
	} else if ((r = bon_check_header(header)) == BON_FALSE) {
		bon_debug_out("[ERROR ] Header check fail\n");
		bon_free_header(header);
		my_bon->status = BON_STATUS_STOP;
		return BON_FALSE;
	} else if (bufsize < header->uiBodyLength + BON_HEADER_SIZE + my_bon->intop) {
		bon_shift_frame(my_bon->inbuf, npoint, bufsize - my_bon->intop, BON_INBUF_LEN);
		my_bon->intop = bufsize - my_bon->intop; 
		bon_free_header(header);
		return BON_FALSE;
	} else {
		point = npoint + BON_HEADER_SIZE;

		switch (header->ucCommandID) {
			case BON_CMD_CONNECT : 
				switch (header->ucMessageID) {
					case BON_MSG_10 : // connect & auth result
						bon_debug_out("[MESSAG] Receive Connect ACK\n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_connect(my_bon, header->uiBodyLength);
						break;
					case BON_MSG_11 : // keepalive
						bon_debug_out("[MESSAG] Receive KeepAlive ACK\n");
						// proc_keepalive(header, d);
						break;
					default :
						goto unknown;
						break;
				}
				my_bon->intop += header->uiBodyLength + BON_HEADER_SIZE;
				break;

      case BON_CMD_EVENT :
				switch (header->ucMessageID) {
					case BON_MSG_10 :
						bon_debug_out("[MESSAG] Response Typing\n");
						break;
					case BON_MSG_11 : // other typing, join, leave
						bon_debug_out("[MESSAG] Response Server Event \n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_room_event(my_bon, header->uiBodyLength);
						break;
					default :
						goto unknown;
						break;
				}
				my_bon->intop += header->uiBodyLength + BON_HEADER_SIZE;
        break;

			case BON_CMD_MESSAGE :
				switch (header->ucMessageID) {
					case BON_MSG_10 : // receive message
						bon_debug_out("[MESSAG] Receive Message\n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_message(my_bon, header->uiBodyLength);
						break;
					case BON_MSG_11 : // receive all message
						bon_debug_out("[MESSAG] All Receive Message\n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_all_message(my_bon, header->uiBodyLength);
						break;
					default :
						goto unknown;
						break;
				}
				my_bon->intop += header->uiBodyLength + BON_HEADER_SIZE;
        break;

			case BON_CMD_ROOM :
				switch (header->ucMessageID) {
					case BON_MSG_10 : // room join
						bon_debug_out("[MESSAG] Room join ACK\n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_join(my_bon, header->uiBodyLength);
						break;
					case BON_MSG_11 : // room leave
						bon_debug_out("[MESSAG] Room leave ACK\n");
						if (g_bon_enc) BenDecryption(header->uiBodyLength, (T_OCTET *)point, (T_OCTET *)point);
						bon_res_leave(my_bon, header->uiBodyLength);
						break;
					default :
						goto unknown;
						break;
				}
				my_bon->intop += header->uiBodyLength + BON_HEADER_SIZE;
        break;

			default :
				goto unknown;
				break;
		}

	}

	bon_free_header(header);
	return BON_TRUE;

unknown:
	bon_debug_out("[ERROR ] Unknown command (CMD:%d:MSG:%d) (DESC:%d).", header->ucCommandID, header->ucMessageID, my_bon->desc);
  bzero(my_bon->inbuf, BON_INBUF_LEN);
  my_bon->intop = 0;
	bon_free_header(header);
	return BON_FALSE;
}


int bon_send_message(stBonPacket *packet) 
{
	int plen;

	if (packet == NULL) return BON_FALSE;

	plen = packet->header->uiBodyLength + BON_HEADER_SIZE;

	if (plen < BON_HEADER_SIZE) {
		bon_debug_out("[ERROR ] Packet length(%d) is less then BON_HEADER_SIZE(%d)\n", plen, BON_HEADER_SIZE);
		return BON_FALSE;
	}

	my_bon->outtop += plen;
	memcpy(my_bon->outbuf, packet->data, plen);

	// for debug
	// if (1) bon_packet_dump(packet->data, plen, "To BON");

	bon_process_output();

	return BON_TRUE;
}


int bon_process_output() 
{
	if (!bon_write_to_descriptor(my_bon->desc, my_bon->outbuf, my_bon->outtop)) 
	{
		bzero(my_bon->outbuf, BON_OUTBUF_LEN);
		my_bon->outtop = 0;
		return BON_FALSE;
	} 
	else 
	{
		bzero(my_bon->outbuf, BON_OUTBUF_LEN);
		my_bon->outtop = 0;
		return BON_TRUE;
	}

	return BON_FALSE;
}

int bon_write_to_descriptor(int desc, char *msg, int len)
{
	int iStart;
	int nWrite;
	int nBlock;

	if ( len <= 0 )
		len = strlen(msg);

	for ( iStart = 0; iStart < len; iStart += nWrite ) {
		nBlock = BON_UMIN( len - iStart, 4096 );
		if ( ( nWrite = write( desc, msg + iStart, nBlock ) ) < 0 ) { 
			bon_debug_out("[ERROR ] write error : %s", strerror(errno));
			return BON_FALSE; 
		}
  }

	return BON_TRUE;
}


int bon_read_from_descriptor() 
{
	int iStart;
 	int nRead;

	/* Checking buffer overflow*/
	iStart = my_bon->intop;

 	nRead = read( my_bon->desc, my_bon->inbuf + iStart, sizeof(my_bon->inbuf) - 10 - iStart );
	if ( nRead > 0 ) {
	// for debug
#if 0
			int i;
			bon_debug_out("[%5d]--------------------------------------------------- IN DUMP (%d)\n", iStart, nRead);
			for (i = 1 + iStart; i <= nRead; ++i) {
				bon_debug_out("%02X ", my_bon->inbuf[i + iStart - 1]);
				if (i % 10 == 0) bon_debug_out(" ");
				if (i % 30 == 0) bon_debug_out("\n");
			}
			bon_debug_out("\n[%5d]--------------------------------------------------- IN DUMP (%d)\n", iStart, nRead);
#endif
		nRead += my_bon->intop;
		my_bon->intop = 0;

		my_bon->ctime = time(0);

		while(bon_interpret(nRead)) ;

	} else if ( nRead == 0 ) {
		bon_debug_out("[SRVMSG] read() 0  error occur.(DESC:%d)", my_bon->desc);
		return BON_FALSE;
	} else {
		bon_debug_out("[SRVMSG] read() 0  error occur.(DESC:%d)", my_bon->desc);
		return BON_FALSE;
	}

	return BON_TRUE;
}

void bon_enter_loop() 
{
	int control;
	time_t now = time(0), sold, mold;
	int maxdesc = 0;
	struct timeval null_time;

	fd_set in_set, out_set, exc_set;
	fd_set o_in_set, o_out_set, o_exc_set;

	sold = now;
	mold = now;

	null_time.tv_sec = 0;
	null_time.tv_usec = 0;

	if (my_bon == NULL || my_bon->bon_ip == NULL || my_bon->bon_port < 1024)
	{
		bon_debug_out("[SRVMSG] Can't start bon client session. my_bon struct is empty.\n");
		return;
	}

	control = bon_init_socket(my_bon->bon_ip, my_bon->bon_port);

	if (control > 0)
	{
		
		bon_debug_out("[SRVMSG] BON connect success\n");
		my_bon->desc = control;
		my_bon->status = BON_STATUS_CONNECT;

		FD_ZERO(&in_set);
		FD_ZERO(&out_set);
		FD_ZERO(&exc_set);
		FD_SET(control, &in_set );
		maxdesc = control;

		bon_req_connect(my_bon, my_bon->uid, my_bon->skey, my_bon->was_ip);	
	}
	else
	{
		bon_debug_out("[SRVMSG] BON connect fail. After 2 sec try again connect\n");
#ifdef DEV_ANDROID
		my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "", env_main);
#else
		my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "");
#endif
	}

	while (BON_TRUE) 
	{
		if (my_bon->status == BON_STATUS_STOP)
		{
			bon_debug_out("[SRVMSG] BON STOP. Exit main loop\n");
			bon_close_socket();
#ifdef DEV_ANDROID
			my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "", env_main);
#else
			my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "");
#endif
			break;
		}
		 else if (my_bon->status == BON_STATUS_DISCONNECT && now > mold + 2)
		{
			bon_debug_out("[SRVMSG] Trying to connect BON\n");
			control = bon_init_socket(my_bon->bon_ip, my_bon->bon_port);
			if (control > 0)
			{
				bon_debug_out("[SRVMSG] BON connect success\n");
				my_bon->desc = control;
				my_bon->status = BON_STATUS_CONNECT;

				FD_ZERO(&in_set);
				FD_ZERO(&out_set);
				FD_ZERO(&exc_set);
				FD_SET(control, &in_set);
				maxdesc = control;

				bon_req_connect(my_bon, my_bon->uid, my_bon->skey, my_bon->was_ip);	
			}
			else
			{
				bon_debug_out("[SRVMSG] BON connect fail. After 2 sec try again connect\n");
#ifdef DEV_ANDROID
				my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "", env_main);
#else
				my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "");
#endif
			}
			mold = now;
			now = time(0);
			usleep(200000);

		}
		else if (my_bon->status == BON_STATUS_CONNECT || my_bon->status == BON_STATUS_READY || my_bon->status == BON_STATUS_IN_CHATROOM)
		{
			memcpy((char *)&o_in_set, (char *)&in_set, sizeof(fd_set));
			memcpy((char *)&o_out_set, (char *)&out_set, sizeof(fd_set));
			memcpy((char *)&o_exc_set, (char *)&exc_set, sizeof(fd_set));

			usleep(10000); // 10ms

			null_time.tv_sec = 0;
			null_time.tv_usec = 0;

    	if ( select( maxdesc+1, &o_in_set, &o_out_set, &o_exc_set, &null_time ) < 0 )
			{
      	bon_debug_out("[ERROR ] Select poll error.\n");
#ifdef DEV_ANDROID
				my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "", env_main);
#else
				my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "");
#endif
				break;
    	}

    	FD_ZERO(&in_set);
    	FD_ZERO(&out_set);
    	FD_ZERO(&exc_set);
    	FD_SET(control, &in_set);
			maxdesc = control;

			FD_SET( control, &in_set  );
			FD_SET( control, &out_set );
			FD_SET( control, &exc_set );

			/* input process */
      if ( control > 0 && FD_ISSET( control, &o_in_set ) )
			{
				if (!bon_read_from_descriptor()) 
				{
					bon_debug_out("[SRVMSG] read() error (DESC:%d)", control);
					FD_CLR(control, &o_exc_set);
					FD_CLR(control, &o_out_set);
					bon_close_socket();
#ifdef DEV_ANDROID
					my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "", env_main);
#else
					my_bon->bon_cb_event(BON_EVENT_DISCONNECT, 0, "", "", "", "", "");
#endif
					continue;
				}
			}
			if (my_bon->status >= BON_STATUS_READY && my_bon->keep_alive_period > 2 && now >= sold + my_bon->keep_alive_period)
			{
				bon_req_keepalive(my_bon);
				sold = now;
			}
			
			now = time(0);
			usleep(200000);
			mold = now;
		}

	}
	bon_debug_out("[SRVMSG] Client main loop exit\n");

	if (my_bon != NULL)
	{
		free(my_bon);
		my_bon = NULL;
	}

	return;
}



/*
 *
 * BON Mobile Interface
 *
 */
int bon_start(BON_CHAR_P bon_ip, int bon_port, BON_CHAR_P uid, BON_CHAR_P
		skey, char is3g, BON_CHAR_P was_ip, char is_enc, void *cb)
{
	if (is_enc > 0)
		g_bon_enc = BON_TRUE;
	else
		g_bon_enc = BON_FALSE;

	if (my_bon != NULL)
	{
		// close socket if socket connected and exit main loop
		my_bon->status = BON_STATUS_STOP;

		int sleep_count = 0;
		while(my_bon != NULL)
		{
			// wating my_bon clear.
			usleep(10000); // 10ms wait
			 if (sleep_count++ > 200) // count 
			{
				bon_debug_out("[SRVMSG] Clear old my_bon session timeout. Please try again\n");
				return BON_ERROR_CLEAR;
			}
		}
		bon_debug_out("[SRVMSG] Clear old my_bon session (Escape time:%d0ms)\n", sleep_count);
	}
	if (bon_ip == NULL || strlen(bon_ip) < 7 || bon_port <= 1024)
	{
		bon_debug_out("[SRVMSG] BON IP or PORT incorrect\n");
		return BON_ERROR_NET_PARAM;
	} 
	else if (uid == NULL)
	{
		bon_debug_out("[SRVMSG] UID is NULL\n");
		return BON_ERROR_UID_PARAM;
	} 
	else if (skey == NULL)
	{
		bon_debug_out("[SRVMSG] SESSION KEY is NULL\n");
		return BON_ERROR_SKEY_PARAM;
	} 
	else if (was_ip == NULL)
	{
		bon_debug_out("[SRVMSG] WAS IP is NULL\n");
		return BON_ERROR_WAS_IP_PARAM;
	} 
	else if (cb == NULL)
	{
		bon_debug_out("[SRVMSG] Callback function is NULL.\n");
		return BON_ERROR_CB_PARAM;
	}
if (my_bon == NULL) 
	my_bon = (BON_DESC_T *)malloc(sizeof(BON_DESC_T) + BON_SAFE_MEM);
	if (my_bon == NULL)
	{
		bon_debug_out("[SRVMSG] my_bon struct alloc fail.\n");
		return BON_ERROR_MEM_ALLOC;
	}
	bon_new_descriptor();
	my_bon->bon_cb_event = cb;

	memcpy(my_bon->bon_ip, bon_ip, strlen(bon_ip));
	my_bon->bon_port = bon_port;
	memcpy(my_bon->uid, uid, strlen(uid));
	memcpy(my_bon->skey, skey, strlen(skey));
	memcpy(my_bon->was_ip, was_ip, strlen(was_ip));

	bon_debug_out("[SRVMSG] Success BON session start.\n");

	bon_enter_loop();

	bon_debug_out("[SRVMSG] Exit loop. return bon_start();\n");
	return BON_NORMAL;
}

int bon_send_event(char event, BON_CHAR_P uid, BON_CHAR_P rk)
{
	if (my_bon == NULL)
		return BON_WARNING_NOT_INIT;
	if (my_bon->status == BON_STATUS_DISCONNECT)
		return BON_WARNING_NOT_CONNECT;
	if (my_bon->status == BON_STATUS_CONNECT)
		return BON_WARNING_NOT_AUTH;
	if (my_bon->status == BON_STATUS_STOP)
		return BON_WARNING_STOPING;
	
	if (event == BON_EVENT_TYPING)
	{
		if (my_bon->status == BON_STATUS_IN_CHATROOM)
			bon_req_typing(my_bon, uid, rk);
		else
			return BON_WARNING_NOT_JOIN;
	}
	else if (event == BON_EVENT_JOIN_ROOM)
	{
		if (my_bon->status == BON_STATUS_READY)
			bon_req_join(my_bon, uid, rk);
		else if (my_bon->status == BON_STATUS_IN_CHATROOM)
			return BON_WARNING_ALREADY_JOIN;
	}
	else if (event == BON_EVENT_LEAVE_ROOM)
	{
		if (my_bon->status == BON_STATUS_IN_CHATROOM)
			bon_req_leave(my_bon, uid, rk);
		else if (my_bon->status == BON_STATUS_READY)
			return BON_WARNING_NOT_JOIN;
	}
	else
	{
		bon_debug_out("[SRVMSG] Unkown send event.\n");
	}
	return BON_NORMAL;
}

int bon_stop(void)
{
	bon_debug_out("Interface bon_stop\n");
	if (my_bon == NULL)
		return BON_WARNING_NOT_INIT;
	if (my_bon->status == BON_STATUS_STOP)
		return BON_WARNING_STOPING;
    
    bon_close_socket(); // tcp
	return BON_NORMAL;
}

int bon_get_status(void)
{
	if (my_bon == NULL)
		return BON_WARNING_NOT_INIT;
	return my_bon->status;
}
