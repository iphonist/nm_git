#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#include "bon_utils.h"
#include "bon_const.h"
#include "bon_client.h"
#include "bon_packet.h"

void bon_clear_frame(char *inbuf, int buflen)
{
	memset(inbuf, '\0', buflen);
}

int bon_shift_frame(char *inbuf, char *np, int len, int buflen)
{
	char tmpbuf[buflen];

	memset(tmpbuf, '\0', buflen);
	memcpy(tmpbuf, np, len);

	memset(inbuf, '\0', buflen);
	memcpy(inbuf, tmpbuf, len);

	return BON_TRUE;
}

int bon_check_header(stBonHeader *header)
{
	return BON_TRUE;
}

stBonHeader *bon_get_header(char *packet)
{
	stBonHeader *h;

	BON_CREATE(h, stBonHeader, 1);

	memcpy(h, packet, BON_HEADER_SIZE);

	return h;
}

void bon_free_header(stBonHeader *h)
{
	BON_FREE(h);
	return;
}

stBonHeader *bon_make_header(char cmd, char msg)
{
  stBonHeader *h;

  BON_CREATE(h, stBonHeader, 1);

	h->ucCommandID 	= cmd;
	h->ucMessageID 	= msg;
	if (g_bon_enc)
		h->usVersion	= 1;
	else
		h->usVersion 	= 0;
	h->uiBodyLength = 0;

  return h;
}

stBonPacket *bon_make_packet(char cmd, char msg)
{
	stBonPacket *p;

	BON_CREATE(p, stBonPacket, 1);

	p->header = bon_make_header(cmd, msg);
	memset(p->data, '\0', BON_MAX_PACKET_LEN);

	return p;
}

// Packet dump
void bon_packet_dump(char *pdata, short plength, char *ip)
{
	char *point, **packet = &point;
	int i;

	point = pdata;

	bon_debug_out("[PKDUMP] OUT Packet Dump (HEX) (IP:%s, LEN:%u)", ip, plength);

	bon_debug_out("\n      -----------------------------  -----------------------------  ----------------------------- \n");
	bon_debug_out("  0 : ");
	for (i = 1; i <= plength; ++i) {
		bon_debug_out("%02X ", (char)(*(*packet + i - 1)));
		if (i % 10 == 0) bon_debug_out(" ");
		if (i % 30 == 0) bon_debug_out("\n%3d : ", i / 30);
	}
	bon_debug_out("\n      -----------------------------  -----------------------------  ----------------------------- \n");

	return;
}

/* socket handling utility */
void bon_nonblock(int s)
{
  int flags;

  flags = fcntl(s, F_GETFL, 0);
  flags |= O_NONBLOCK;
  if (fcntl(s, F_SETFL, flags) < 0) {
    bon_debug_out("FATALERR - executing nonblock\n");
		return;
  }
}

ssize_t bon_writen(int fd, void *vptr, ssize_t n)
{
	size_t  nbytes = n;
	char *ptr = (char *) vptr;
	while (nbytes) {
		ssize_t nwritten = write(fd,ptr,nbytes);
		if (nwritten <= 0) {
			if (errno == EINTR)
				nwritten = 0;
			else
				return -1; 
		}   
		nbytes -= nwritten;
		ptr += nwritten;
	}
	return (n - nbytes);
}
