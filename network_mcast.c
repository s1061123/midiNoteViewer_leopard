/*
 *  network_mcast.c
 *  midiNoteViewer(仮)
 *
 *  Created by Tomofumi Hayashi on 11/11/14.
 *  Copyright 2011 s1061123.net. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "network_mcast.h"
#include <assert.h>
#include <CoreMIDI/CoreMIDI.h>

#define MIDI_NOTE_VIEWER_UDP_PORT	1123
#define MIDI_NOTE_VIEWER_MCAST_GROUP	"239.1.1.23"

int get_server_socket (struct sockaddr_in *addr);
struct ip_mreq *get_client_mreq (void);
int get_client_socket (struct ip_mreq *mreq);
mnv_node_t *mnv_get_node(mnv_node_type_t type);
void mnv_free_node(mnv_node_t *node);
void send_midi_packets (mnv_node_t *node, const MIDIPacketList *pktlist);
    
int get_server_socket (struct sockaddr_in *addr)
{
	int sockfd;
		
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	addr->sin_family = AF_INET;

	addr->sin_port = htons(MIDI_NOTE_VIEWER_UDP_PORT);
	addr->sin_addr.s_addr = inet_addr(MIDI_NOTE_VIEWER_MCAST_GROUP);

#if 0
	{
		// Set source addr
		ip_addr_t ipaddr;
		ipaddr = inet_addr("127.0.0.1");
		if (setsockopt(sockfd, IPPROTO_IP, IP_MULTICAST_IF,
					   (char *)&ipaddr, sizeof(ipaddr)) != 0) {
			perror("setsockopt");
			return -1;
		}
	}
#endif
	return sockfd;
}

struct ip_mreq *get_client_mreq (void)
{
	struct ip_mreq *mreq;

	mreq = malloc(sizeof(*mreq));
	assert(mreq != NULL);
	memset(mreq, 0, sizeof(*mreq));
	//mreq->imr_interface.s_addr = inet_addr("127.0.0.1");
	mreq->imr_multiaddr.s_addr = inet_addr(MIDI_NOTE_VIEWER_MCAST_GROUP);

	return mreq;
}

int get_client_socket (struct ip_mreq *mreq) 
{
	int sockfd;
	struct sockaddr_in addr;

	sockfd = socket(AF_INET, SOCK_DGRAM, 0);

	addr.sin_family = AF_INET;
	addr.sin_port = htons(MIDI_NOTE_VIEWER_UDP_PORT);
	addr.sin_addr.s_addr = INADDR_ANY;
	
	if (bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) != 0) {
		perror("bind");
		return -1;
	}
	
	if (setsockopt(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP,
				   (char *)mreq, sizeof(*mreq)) != 0) {
		perror("setsockopt");
		return -1;
	}
	return sockfd;
}

mnv_node_t *mnv_get_node(mnv_node_type_t type)
{
	mnv_node_t *node;
	
	node = malloc(sizeof(*node));
	assert(node != NULL);
	
	node->type = type;
	switch (type) {
		case TYPE_SERVER:
			node->sockfd = get_server_socket(&node->addr);
			break;
		case TYPE_CLIENT:
			node->mreq = get_client_mreq();
			node->sockfd = get_client_socket(node->mreq);
			break;
        default:
            break;
	}

	if (node->sockfd == -1) {
		free(node);
		return NULL;
	}
	return node;
}

void mnv_free_node(mnv_node_t *node)
{
	switch (node->type) {
		case TYPE_SERVER:
			close(node->sockfd);
			break;
		case TYPE_CLIENT:
			if (setsockopt(node->sockfd, IPPROTO_IP, IP_DROP_MEMBERSHIP,
						   (char *)node->mreq, sizeof(struct ip_mreq)) != 0) {
				perror("setsockopt");
			}
			
			free(node->mreq);
			close(node->sockfd);
			break;
        default:
            break;
	}
	return;
}

#if 0
void send_midi_packets (mnv_node_t *node, const MIDIPacketList *pktlist)
{
	ssize_t sz, send_len;
    char buf[1024];
	
    memset(buf, 0, sizeof(buf));
	sz = sizeof(UInt32) + sizeof(MIDIPacket) * pktlist->numPackets;

    memcpy(buf, pktlist, sz);
	send_len = sendto(node->sockfd, buf, sz, 0, 
					  (struct sockaddr *)&node->addr, sizeof(struct sockaddr_in));
	assert(sz == send_len);
}
#endif 

#define MAX_MIDI_NOTE		127
void send_midi_key_packets (mnv_node_t *node, uint8_t *note)
{
	ssize_t send_len;
	
	send_len = sendto(node->sockfd, note, MAX_MIDI_NOTE * sizeof(uint8_t), 0,
					  (struct sockaddr *)&node->addr, sizeof(struct sockaddr_in));

	assert(send_len == MAX_MIDI_NOTE * sizeof(uint8_t));
}
