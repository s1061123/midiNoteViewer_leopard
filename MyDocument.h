//
//  MyDocument.h
//  pianoTest2
//
//  Created by Tomofumi Hayashi on 11/01/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "network_mcast.h"
#import <Cocoa/Cocoa.h>
#import <CoreMIDI/CoreMIDI.h>


@class MyOpenGLView;

@interface MyDocument : NSDocument
{
@private
@public
	int curMIDIEndPoint;
	int midiEndPointCount;
	MIDIEndpointRef *midiEndPoints;
	NSMutableArray *midiEndPointNames;
	
	MIDIClientRef clientRef;
	MIDIPortRef inputPortRef;
	NSString *clientName;
	NSString *inputPortName;
	NSThread *clientThread;
	
	mnv_node_t *mnvNode;
	BOOL isClientRunning;
	
	// All note: 0-127
	// 88鍵 =note: 21-108
	// 美学校: 15-6c
#define MAX_MIDI_NOTE		127
#define MAX_KEY_NOTE		88
	int midiNote[MAX_MIDI_NOTE];
	
	IBOutlet MyOpenGLView *glView;
	IBOutlet NSComboBox *midiEndCombobox;
	IBOutlet NSComboBoxCell *midiEndComboboxCell;
	IBOutlet NSButton *midiServerButton;
}

- (IBAction)midiSelected:(id)sender;
- (IBAction)serverClicked:(id)sender;
- (void)midiStartReceive:(int)index;
- (BOOL)setMidiNoteOn:(uint)note;
- (BOOL)setMidiNoteOff:(uint)note;
- (uint)getMidiNote:(uint)note;
@property (assign,getter=getNode)mnv_node_t* mnvNode;
@end