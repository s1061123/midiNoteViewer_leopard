//
//  MyDocument.m
//  pianoTest2
//
//  Created by Tomofumi Hayashi on 11/01/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>
#import "MyDocument.h"
#import "network_mcast.h"
#import "MyOpenGLView.h"

static void MIDIInputProc(const MIDIPacketList *pktlist, 
			  void *readProcRefCon, void *srcConnRefCon)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	MyDocument *doc;
	mnv_node_t *node = NULL;
	
	doc=[[NSDocumentController sharedDocumentController] currentDocument];
	if (doc != nil) {
		node = [doc getNode];
	}
		
	//MIDIパケットリストの先頭のMIDIPacketのポインタを取得
    MIDIPacket *packet = (MIDIPacket *)&(pktlist->packet[0]);
    //パケットリストからパケットの数を取得
    UInt32 packetCount = pktlist->numPackets;
    
	for (NSInteger i = 0; i < packetCount; i++) {
        //data[0]からメッセージの種類とチャンネルを分けて取得する
        Byte mes = packet->data[0] & 0xF0;
        Byte ch = packet->data[0] & 0x0F;
        
        //メッセージの種類に応じてログに表示
        if ((mes == 0x90) && (packet->data[2] != 0)) {
			[doc setMidiNoteOn: packet->data[1]];
			NSLog(@"note on number = %2.2x / velocity = %2.2x / channel = %2.2x",
                  packet->data[1], packet->data[2], ch);
        } else if (mes == 0x80 || mes == 0x90) {
			[doc setMidiNoteOff: packet->data[1]];
			NSLog(@"note off number = %2.2x / velocity = %2.2x / channel = %2.2x", 
                  packet->data[1], packet->data[2], ch);
        } else if (mes == 0xB0) {
            NSLog(@"cc number = %2.2x / data = %2.2x / channel = %2.2x", 
                  packet->data[1], packet->data[2], ch);
        } else {
            NSLog(@"etc");
        }
        
        //次のパケットへ進む
        packet = MIDIPacketNext(packet);
    }

	//if server, send notification to all clients.
	if (node != NULL && node->type == TYPE_SERVER) {
		send_midi_key_packets([doc getNode], [doc getMidiNoteTable]);
	}
	
	[pool drain];
}


@implementation MyDocument
@synthesize mnvNode;
- (id)init
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	OSStatus err;
	CFStringRef strEndPointRef = NULL;
	
	self = [super init];
	
	if (self) {
		// Add your subclass-specific initialization here.
		// If an error occurs here, send a [self release] message and return nil.
		clientName = @"inputClient";
		inputPortName = @"inputPort";
		curMIDIEndPoint = -1;
		ItemCount sourceCount = MIDIGetNumberOfSources();
		
		midiEndPointNames = [[NSMutableArray array] init];
		midiEndPoints = malloc(sizeof(MIDIEndpointRef) * sourceCount);
		midiEndPointCount = sourceCount;
		NSLog(@"Total midiEndPoints %lu / %d", sourceCount, midiEndPointCount);
		
		for (NSInteger i = 0; i < sourceCount; i++) {
			MIDIEndpointRef endPointRef = MIDIGetSource(i);
			
			err = MIDIObjectGetStringProperty(endPointRef, kMIDIPropertyName, &strEndPointRef);
			
			if (err == noErr) {
				NSLog(@"EndPoint = %@", strEndPointRef);
				if (strEndPointRef) {
					midiEndPoints[i] = endPointRef;
					[midiEndPointNames addObject:(NSString *)strEndPointRef];
					
					/*	NSLog(@"V:%@", midiEndPointNames);
					 NSLog(@"C: %d", [midiEndPointNames count]);
					 
					 //CFRelease(strEndPointRef);
					 //strEndPointRef = NULL; */
				}
			} else {
				NSLog(@"Err = %d", err);
			}
		}
		[midiEndPointNames addObject: @"Network"];
		midiEndPointNames = [midiEndPointNames retain];
		mnvNode = NULL;
		clientThread = nil;
	}
	[pool drain];
	return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
	
	[super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	[[midiEndCombobox window] setFrameAutosaveName:@"Window"];
	[[midiEndCombobox window] setFrameUsingName:@"Window"];
	[glView	setDoc: self];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
	
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
	
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

//for Combobox
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return [midiEndPointNames count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	return [midiEndPointNames objectAtIndex:index];
}

- (unsigned int)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
    return [midiEndPointNames indexOfObject:string];
}

// for MIDI
- (void)midiStartReceive:(int)index {
	OSStatus err;
	
	err = MIDIClientCreate((CFStringRef)clientName, NULL, NULL, &clientRef);
	if (err != noErr) {
        NSLog(@"MIDIClientCreate err = %d", err);
        return;
    }
    
    //MIDIポートを作成する
    err = MIDIInputPortCreate(
							  clientRef, (CFStringRef)inputPortName, 
							  MIDIInputProc, NULL, &inputPortRef);
    if (err != noErr) {
        NSLog(@"MIDIInputPortCreate err = %d", err);
        return;
    }
    
    //MIDIエンドポイントを取得し、MIDIポートに接続する
	err = MIDIPortConnectSource(inputPortRef, midiEndPoints[index], NULL);
	if (err != noErr) {
		NSLog(@"MIDIPortConnectSource err = %d", err);
		return;
	}
	curMIDIEndPoint = index;
}

- (void)midiStopReceive {
	OSStatus err;
	
	err = MIDIPortDisconnectSource(inputPortRef, midiEndPoints[curMIDIEndPoint]);
	if (err!= noErr) {
		NSLog(@"MIDIPortDisconnectSource err = %d", err);
		return;
	}
	
	err = MIDIPortDispose(inputPortRef);
	if (err!= noErr) {
		NSLog(@"MIDIPortDispose err = %d", err);
		return;
	}
	
	curMIDIEndPoint = -1;
}


- (IBAction)midiSelected:(id)sender {
	int selected = [midiEndCombobox indexOfSelectedItem];
	
	NSLog(@"Selected (%d/%d)", selected, midiEndPointCount);
	if (curMIDIEndPoint != -1) {
		[self midiStopReceive];
		NSLog(@"MIDI is stopped %d", curMIDIEndPoint);
	}

	if (mnvNode != NULL) {
		/* if necessary, terminate client */
		if (mnvNode->type == TYPE_CLIENT && 
			selected != midiEndPointCount) {
			//stop client thread
			assert(clientThread != nil);
			isClientRunning = FALSE;
			NSLog(@"Client thread is terminated.");
			[clientThread cancel];
			[clientThread release];
		}
		mnv_free_node(mnvNode);
		mnvNode = NULL;
	}

	if (selected == midiEndPointCount) {
		NSLog(@"Network is selected");

		// Disable server checkbox
		[midiServerButton setState:0];
		[midiServerButton setEnabled:NO];
		
		//start client
		mnvNode = mnv_get_node(TYPE_CLIENT);

		//create thread XXX
		clientThread = [[NSThread alloc] initWithTarget:self 
										selector:@selector(clientProc:) object:nil];
		[clientThread start];
		[clientThread release];
        curMIDIEndPoint = selected;
	} else {
		[midiServerButton setEnabled:YES];
		[self midiStartReceive: selected];
		NSLog(@"MIDI is started %d -> %d", curMIDIEndPoint, selected);
	}
}

- (uint8_t)getMidiNote:(uint)note {
	return midiNote[note];
}

- (BOOL)setMidiNoteOn:(uint)note {
	if (midiNote[note] == 1) {
		NSLog(@"Error - note %d already on", note);
		return FALSE;
	}
	midiNote[note] = 1;
	return TRUE;
}

- (BOOL)setMidiNoteOff:(uint)note {
	if (midiNote[note] == 0) {
		NSLog(@"Error - note %d already on", note);
		return FALSE;
	}
	midiNote[note] = 0;
	return TRUE;
}

- (IBAction)serverClicked:(id)sender {
	int selected = [midiServerButton state];
	NSLog(@"Clicked! new state: %d", selected);

	//At this point, we assure mnv_node is server or none.
	if (mnvNode != NULL && selected == NO) {
        isClientRunning = FALSE;
        NSLog(@"Client thread is terminated.");
        [clientThread cancel];
		[clientThread release];
		mnv_free_node(mnvNode);
        mnvNode = NULL;
	} else {
		mnvNode = mnv_get_node(TYPE_SERVER);
	}
}

- (void)clientProc:(id)dummy {
	int sockfd = mnvNode->sockfd;
#define	MNV_BUF_SIZE	1024
	char buf[MNV_BUF_SIZE];
#if 0
	MIDIPacket *packet;
	MIDIPacketList *pktList;
	UInt32 pktCount;
#endif	

	isClientRunning = TRUE;
	NSLog(@"Client thread is started.");
	while (recv(sockfd, buf, sizeof(buf), 0) != 0 && 
		   isClientRunning) {
		//XXX: Need mutex 
		memcpy(midiNote, buf, MAX_MIDI_NOTE * sizeof(uint8_t));
#if 0
		pktList = (MIDIPacketList *)buf;
		packet = (MIDIPacket *)&(pktList->packet[0]);
		pktCount = pktList->numPackets;
		for (NSInteger i = 0; i < pktCount; i++) {
			//data[0]からメッセージの種類とチャンネルを分けて取得する
			Byte mes = packet->data[0] & 0xF0;
			Byte ch = packet->data[0] & 0x0F;
			
			//メッセージの種類に応じてログに表示
			if ((mes == 0x90) && (packet->data[2] != 0)) {
				[self setMidiNoteOn: packet->data[1]];
				NSLog(@"note on number = %2.2x / velocity = %2.2x / channel = %2.2x",
					  packet->data[1], packet->data[2], ch);
			} else if (mes == 0x80 || mes == 0x90) {
				[self setMidiNoteOff: packet->data[1]];
				NSLog(@"note off number = %2.2x / velocity = %2.2x / channel = %2.2x", 
					  packet->data[1], packet->data[2], ch);
			} else if (mes == 0xB0) {
				NSLog(@"cc number = %2.2x / data = %2.2x / channel = %2.2x", 
					  packet->data[1], packet->data[2], ch);
			} else {
				NSLog(@"etc");
			}
			//次のパケットへ進む
			packet = MIDIPacketNext(packet);
		}
#endif
	}
}

- (uint8_t *)getMidiNoteTable {
	return midiNote;
}

- (IBAction)prefPanelHide:(id)sender {
	[prefPanel close];
}

- (IBAction)prefPanelInit:(id)sender {
}
@end
