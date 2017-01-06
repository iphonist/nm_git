#ifndef BON_CLIENT_H__
#define BON_CLIENT_H__

/*
 * Include Files
*/
#include "bon_packet.h"
#include "bon_const.h"
#ifdef DEV_ANDROID
#include "jni.h"
#endif

#ifdef BON_CLIENT_C__
int     g_bon_enc; 
#else
extern int  g_bon_enc; 
#endif

/*
 * structure types 
*/
typedef struct bon_desc BON_DESC_T;

struct bon_desc 
{
	int				desc;
	char			inbuf[BON_INBUF_LEN];
	char			outbuf[BON_OUTBUF_LEN];
	time_t		ctime;
	short			outtop;
	short			intop;
	short			status;

	char			bon_ip[BON_IP_LEN];
	int				bon_port;
	char			uid[BON_UID_LEN];
	char			rk[BON_RK_LEN];
	char			skey[BON_SESSION_LEN];
	char			was_ip[BON_IP_LEN];

	short			keep_alive_period;

	/* callback func for event */
#ifdef DEV_ANDROID
	void (*bon_cb_event) (char event, int msg_type, const char *uid, const char *nickname, const char *rk, const char *lastidx, const char *msg, JNIEnv *target);
#else
	void (*bon_cb_event) (char event, int msg_type, char *uid, char *nickname, char *rk, char *lastidx, char *msg);
#endif
};

/*
 * functions
*/
int	 bon_init_socket(char *ip, int port);    							/* initialize server socket */

void bon_close_socket();								/* close socket & clear desc buffer */
void bon_dump_header();
int	 bon_interpret(int bufsize);			/* interpret message */
int	 bon_send_message(stBonPacket *packet);	 /* send message to client */
int  bon_process_output();							/* processing output */
int  bon_write_to_descriptor(int desc, char *msg, int len);	/* write to descriptor */
int	 bon_read_from_descriptor();				/* read from descriptor */
void bon_new_descriptor();						/* new user connect */

void bon_enter_loop(); 							/* server loop */

#endif
