#ifndef BON_CONST_H__
#define BON_CONST_H__

#define BON_UID_LEN				64
#define BON_RK_LEN				64
#define BON_INBUF_LEN			8192
#define BON_OUTBUF_LEN		256
#define BON_MSG_LEN				3000
#define BON_IP_LEN				32
#define BON_SESSION_LEN		256
#define BON_NICKNAME_LEN	128
#define BON_LASTIDX_LEN		64

#define BON_ERROR 			-1
#define BON_FALSE   		0
#define BON_TRUE    		!(BON_FALSE)

#define BON_HEADER_SIZE	8

#ifdef DEV_ANDROID
typedef const char * BON_CHAR_P;
#else
typedef char * BON_CHAR_P;
#endif

#endif
