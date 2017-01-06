#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "bon_utils.h"

T_KEY _bon_public_key[2] 	= {0xbe30d347, 0x34f747c9};
T_KEY _bon_private_key[2] 	= {0x0497e6b8, 0xC7f69654};

void BenEncryption(int len, T_OCTET *datain, T_OCTET *dataout)
{
	int   i;   
	int   rkey;
	T_KEY tkey[2];
	T_OCTET *pkey, lkey, rsk; 
					  
	tkey[0] = _bon_public_key[0] ^ _bon_private_key[0];
	tkey[1] = _bon_public_key[1] ^ _bon_private_key[1];
	pkey = (T_OCTET *)&tkey[0];
	rkey = 2157;
	lkey = (len * 157) & 0xff;

	for (i = 0; i < len;i++) {
		rsk = (rkey >> 8) & 0xff;
		dataout[i] = ((datain[i] ^ rsk) ^ pkey[i & 0x7]) ^ lkey;
		rkey *= 2171;
	}
}

void BenDecryption(int len, T_OCTET *datain, T_OCTET *dataout)
{
	int   i;
	int   rkey;
	T_KEY tkey[2];
	T_OCTET *pkey, lkey, rsk;

	tkey[0] = _bon_public_key[0] ^ _bon_private_key[0];
	tkey[1] = _bon_public_key[1] ^ _bon_private_key[1];
	pkey = (T_OCTET *)&tkey;
	rkey = 2157;
	lkey = (len * 157) & 0xff;

	for (i = 0; i < len;i++) {
		rsk = (rkey >> 8) & 0xff;
		dataout[i] = ((datain[i] ^ lkey) ^ pkey[i & 0x7]) ^ rsk;
		rkey *= 2171;
	}
}

void bon_free(void *mem) 
{
	if (mem == NULL) return;
	free(mem); mem = NULL;
}

void *bon_calloc(size_t nmemb, size_t size)
{
	size_t tmpii = size + BON_SAFE_MEM;
  void *aa = NULL;

	if ((aa = (void *) calloc(nmemb, tmpii)) == NULL) {
		bon_debug_out("[ERROR ] Memory calloc error\n");
		exit(-1);
	}
	bzero(aa, (tmpii * nmemb));

	return aa;
}

#ifndef DEV_ANDROID
void bon_debug_out(const char *fmt, ...) 
{
#ifdef DEBUG_MODE
	va_list   ap; 
	va_start(ap, fmt);
	vprintf(fmt, ap);
	va_end(ap);
#endif
}
#endif
