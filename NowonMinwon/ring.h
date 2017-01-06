//
//  ring.h
//  bSampler
//
//  Created by 백인구 on 11. 6. 28..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#ifndef _RING_H__
#define _RING_H__

int               ring_cnt;
//SystemSoundID     ring_id;
//SystemSoundID     ring_id;
CFRunLoopTimerRef ring_timer;
CFRunLoopTimerRef ring_vib_timer;

void sip_ring_init();
void sip_ring_start();
void sip_ring_stop();
void sip_ring_deinit();

#endif
