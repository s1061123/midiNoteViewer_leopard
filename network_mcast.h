/*
 *  network_mcast.h
 *  midiNoteViewer(仮)
 *
 *  Created by Tomofumi Hayashi on 11/11/14.
 *  Copyright 2011 s1061123.net. All rights reserved.
 *
 */
#include <netinet/in.h>
#include <CoreMIDI/CoreMIDI.h>

typedef enum {TYPE_NONE, TYPE_SERVER, TYPE_CLIENT} mnv_node_type_t;

typedef struct {
	mnv_node_type_t type;
	int sockfd;
	struct sockaddr_in addr;
	struct ip_mreq *mreq; // for client
} mnv_node_t;

mnv_node_t *mnv_get_node(mnv_node_type_t type);
void mnv_free_node(mnv_node_t *node);
void send_midi_packets (mnv_node_t *node, const MIDIPacketList *pktlist);
void send_midi_key_packets (mnv_node_t *node, uint8_t *note);