#ifndef BON_PACKET_H__
#define BON_PACKET_H__

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>

#include "bon_utils.h"
#include "bon_const.h"

#define BON_CMD_CONNECT        	  10
#define BON_CMD_EVENT 	       	  11
#define BON_CMD_MESSAGE        	  12
#define BON_CMD_ROOM 		       	  13

#define BON_MSG_10               	10 
#define BON_MSG_11                11

#define BON_MAX_PACKET_LEN				3200

#define BON_PUTUSHORT(s, packet)	\
	*((short *)*packet) = s; *packet += sizeof(short)
#define BON_PUTUINT(s, packet)	\
	*((int *)*packet) = s; *packet += sizeof(int)
#define BON_PUTINT(s, packet)	\
	*((int *)*packet) = s; *packet += sizeof(int)
#define PBON_UTTIME_T(s, packet)	\
	*((time_t *)*packet) = s; *packet += sizeof(time_t)
#define BON_PUTUCHAR(s, packet)	\
	*((char *)*packet) = s; *packet += sizeof(char)
#define PBON_UTBOOLEAN(s, packet)	\
	*((boolean *)*packet) = s; *packet += sizeof(boolean)
#define BON_PUTARRAY(s, n, packet)	\
	memcpy(*packet, s, n); *packet += n
#define BON_PUTSTRING(s, n, packet)	\
	BON_PUTUSHORT(n, packet); \
	BON_PUTARRAY(s, n, packet)

#define BON_GETARRAY(s, n, packet)	\
	memcpy(s, *packet, n); *packet += n

#define BON_PREFIX(commandid, messageid)                             \
        stBonPacket *p;                                  \
        char *point, **packet = &point, *temp;       \
        int uiLength = 0;                            \
        p = bon_make_packet(commandid, messageid);  \
        point = p->data + BON_HEADER_SIZE;                \
        temp = point;

#define BON_BODYEND()                                     \
        uiLength = point - temp; 

#define BON_POSTFIX()                                     \
        temp = point;																	\
        p->header->uiBodyLength = uiLength; 					\
        point = p->data;                              \
        BON_PUTARRAY(p->header, BON_HEADER_SIZE, packet);


typedef struct _bon_header {    ///< 8 bytes
  /* Transaction ID - 4 */
  char   ucCommandID;      ///< 1
  char   ucMessageID;      ///< 1
  short  usVersion;        ///< 2
  /* Body Length - 4 */
  int  	uiBodyLength; 	  ///< 4  body length
} stBonHeader;


typedef struct _bon_packet 
{
  stBonHeader *header;
  char data[BON_MAX_PACKET_LEN];
} stBonPacket;

stBonHeader *bon_get_header(char *packet);
stBonHeader *bon_make_header(char cmd, char msg);
stBonPacket *bon_make_packet(char cmd, char msg);

void 	bon_packet_dump(char *pdata, short plength, char *ip);

void  bon_free_header(stBonHeader *p_header);
int 	bon_check_header(stBonHeader *header);

int 	bon_shift_frame(char *inbuf, char *np, int len, int buflen);
void 	bon_clear_frame(char *inbuf, int buflen);

void 	bon_nonblock(int s);
ssize_t bon_writen(int fd, void *vptr, ssize_t n);

#endif
