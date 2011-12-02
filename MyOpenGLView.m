//
//  MyOpenGLView.m
//  pianoTest2
//
//  Created by Tomofumi Hayashi on 11/01/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyOpenGLView.h"
#import <OpenGL/OpenGL.h>
#import <mach/mach.h>
#import <mach/mach_time.h>

@implementation MyOpenGLView
@synthesize doc;

- (void)prepareOpenGL {
	mCGLContext = (CGLContextObj)[[self openGLContext] CGLContextObj];
    glEnable(GL_BLEND);
	glEnable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);


	/* start Drawing thread */
	[NSThread detachNewThreadSelector:@selector (drawProc:)
							 toTarget:self withObject:nil];
}

- (void)reshape {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    NSRect frame = [self frame];
    glViewport(0, 0, 
			   (GLsizei)frame.size.width,
			   (GLsizei)frame.size.height);
    
    glOrtho(0.0,    // Left-X
            1080.0 + 20,  // Right-X (not width)
            0.0,    // Bottom-Y
            480.0,  // Top-Y (not height)
            -10.0,   // Z-Near
            10.0);   // Z-Far
}

const int COLOR_ELEMS  = 4;



// Todo: need to think how to change pushed key?
// 

- (void)draw {
	// background is same as frame.
	glClearColor(0.91f, 0.91f, 0.91f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glDisable(GL_TEXTURE_2D);

	const GLshort depthW = -1;
	const GLshort depthB = 1;
		
#define DRAW_BORDER 1
#ifdef DRAW_BORDER
#define BORDER_LINES 15
	const GLshort depthBd = 1;
	const GLshort BoldBorder[] = {
		80, 20, depthBd,  80, 460, depthBd,
		140, 20, depthBd, 140, 460, depthBd,
		220, 20, depthBd, 220, 460, depthBd,
		280, 20, depthBd, 280, 460, depthBd,
		360, 20, depthBd, 360, 460, depthBd,

		420, 20, depthBd, 420, 460, depthBd,
		500, 20, depthBd, 500, 460, depthBd,
		560, 20, depthBd, 560, 460, depthBd,
		640, 20, depthBd, 640, 460, depthBd,
		700, 20, depthBd, 700, 460, depthBd,
	
		780, 20, depthBd, 780, 460, depthBd,
		840, 20, depthBd, 840, 460, depthBd,
		920, 20, depthBd, 920, 460, depthBd,
		980, 20, depthBd, 980, 460, depthBd,
		1060, 20, depthBd, 1060, 460, depthBd,
	};
#endif	

	const GLshort KeyVertices[] = {
		40,20,depthW,60,20,depthW,60,460,depthW,40,460,depthW,
		50,200,depthB,65,200,depthB,65,460,depthB,50,460,depthB,
		60,20,depthW,80,20,depthW,80,460,depthW,60,460,depthW,
		
		/* 1 oct */
		80,20,depthW,100,20,depthW,100,460,depthW,80,460,depthW,
		90,200,depthB,105,200,depthB,105,460,depthB,90,460,depthB,
		100,20,depthW,120,20,depthW,120,460,depthW,100,460,depthW,
		110,200,depthB,125,200,depthB,125,460,depthB,110,460,depthB,
		120,20,depthW,140,20,depthW,140,460,depthW,120,460,depthW,
		140,20,depthW,160,20,depthW,160,460,depthW,140,460,depthW,
		150,200,depthB,165,200,depthB,165,460,depthB,150,460,depthB,
		160,20,depthW,180,20,depthW,180,460,depthW,160,460,depthW,
		170,200,depthB,185,200,depthB,185,460,depthB,170,460,depthB,
		180,20,depthW,200,20,depthW,200,460,depthW,180,460,depthW,
		190,200,depthB,205,200,depthB,205,460,depthB,190,460,depthB,
		200,20,depthW,220,20,depthW,220,460,depthW,200,460,depthW,
		
		/* 2 oct */
		220,20,depthW,240,20,depthW,240,460,depthW,220,460,depthW,
		230,200,depthB,245,200,depthB,245,460,depthB,230,460,depthB,
		240,20,depthW,260,20,depthW,260,460,depthW,240,460,depthW,
		250,200,depthB,265,200,depthB,265,460,depthB,250,460,depthB,
		260,20,depthW,280,20,depthW,280,460,depthW,260,460,depthW,
		280,20,depthW,300,20,depthW,300,460,depthW,280,460,depthW,
		290,200,depthB,305,200,depthB,305,460,depthB,290,460,depthB,
		300,20,depthW,320,20,depthW,320,460,depthW,300,460,depthW,
		310,200,depthB,325,200,depthB,325,460,depthB,310,460,depthB,
		320,20,depthW,340,20,depthW,340,460,depthW,320,460,depthW,
		330,200,depthB,345,200,depthB,345,460,depthB,330,460,depthB,
		340,20,depthW,360,20,depthW,360,460,depthW,340,460,depthW,
		
		/* 3 oct */
		360,20,depthW,380,20,depthW,380,460,depthW,360,460,depthW,
		370,200,depthB,385,200,depthB,385,460,depthB,370,460,depthB,
		380,20,depthW,400,20,depthW,400,460,depthW,380,460,depthW,
		390,200,depthB,405,200,depthB,405,460,depthB,390,460,depthB,
		400,20,depthW,420,20,depthW,420,460,depthW,400,460,depthW,
		420,20,depthW,440,20,depthW,440,460,depthW,420,460,depthW,
		430,200,depthB,445,200,depthB,445,460,depthB,430,460,depthB,
		440,20,depthW,460,20,depthW,460,460,depthW,440,460,depthW,
		450,200,depthB,465,200,depthB,465,460,depthB,450,460,depthB,
		460,20,depthW,480,20,depthW,480,460,depthW,460,460,depthW,
		470,200,depthB,485,200,depthB,485,460,depthB,470,460,depthB,
		480,20,depthW,500,20,depthW,500,460,depthW,480,460,depthW,
		
		/* 4 oct */
		500,20,depthW,520,20,depthW,520,460,depthW,500,460,depthW,
		510,200,depthB,525,200,depthB,525,460,depthB,510,460,depthB,
		520,20,depthW,540,20,depthW,540,460,depthW,520,460,depthW,
		530,200,depthB,545,200,depthB,545,460,depthB,530,460,depthB,
		540,20,depthW,560,20,depthW,560,460,depthW,540,460,depthW,
		560,20,depthW,580,20,depthW,580,460,depthW,560,460,depthW,
		570,200,depthB,585,200,depthB,585,460,depthB,570,460,depthB,
		580,20,depthW,600,20,depthW,600,460,depthW,580,460,depthW,
		590,200,depthB,605,200,depthB,605,460,depthB,590,460,depthB,
		600,20,depthW,620,20,depthW,620,460,depthW,600,460,depthW,
		610,200,depthB,625,200,depthB,625,460,depthB,610,460,depthB,
		620,20,depthW,640,20,depthW,640,460,depthW,620,460,depthW,
		
		/* 5 oct */
		640,20,depthW,660,20,depthW,660,460,depthW,640,460,depthW,
		650,200,depthB,665,200,depthB,665,460,depthB,650,460,depthB,
		660,20,depthW,680,20,depthW,680,460,depthW,660,460,depthW,
		670,200,depthB,685,200,depthB,685,460,depthB,670,460,depthB,
		680,20,depthW,700,20,depthW,700,460,depthW,680,460,depthW,
		700,20,depthW,720,20,depthW,720,460,depthW,700,460,depthW,
		710,200,depthB,725,200,depthB,725,460,depthB,710,460,depthB,
		720,20,depthW,740,20,depthW,740,460,depthW,720,460,depthW,
		730,200,depthB,745,200,depthB,745,460,depthB,730,460,depthB,
		740,20,depthW,760,20,depthW,760,460,depthW,740,460,depthW,
		750,200,depthB,765,200,depthB,765,460,depthB,750,460,depthB,
		760,20,depthW,780,20,depthW,780,460,depthW,760,460,depthW,
		
		/* 6 oct */
		780,20,depthW,800,20,depthW,800,460,depthW,780,460,depthW,
		790,200,depthB,805,200,depthB,805,460,depthB,790,460,depthB,
		800,20,depthW,820,20,depthW,820,460,depthW,800,460,depthW,
		810,200,depthB,825,200,depthB,825,460,depthB,810,460,depthB,
		820,20,depthW,840,20,depthW,840,460,depthW,820,460,depthW,
		840,20,depthW,860,20,depthW,860,460,depthW,840,460,depthW,
		850,200,depthB,865,200,depthB,865,460,depthB,850,460,depthB,
		860,20,depthW,880,20,depthW,880,460,depthW,860,460,depthW,
		870,200,depthB,885,200,depthB,885,460,depthB,870,460,depthB,
		880,20,depthW,900,20,depthW,900,460,depthW,880,460,depthW,
		890,200,depthB,905,200,depthB,905,460,depthB,890,460,depthB,
		900,20,depthW,920,20,depthW,920,460,depthW,900,460,depthW,
		
		/* 7 oct */
		920,20,depthW,940,20,depthW,940,460,depthW,920,460,depthW,
		930,200,depthB,945,200,depthB,945,460,depthB,930,460,depthB,
		940,20,depthW,960,20,depthW,960,460,depthW,940,460,depthW,
		950,200,depthB,965,200,depthB,965,460,depthB,950,460,depthB,
		960,20,depthW,980,20,depthW,980,460,depthW,960,460,depthW,
		980,20,depthW,1000,20,depthW,1000,460,depthW,980,460,depthW,
		990,200,depthB,1005,200,depthB,1005,460,depthB,990,460,depthB,
		1000,20,depthW,1020,20,depthW,1020,460,depthW,1000,460,depthW,
		1010,200,depthB,1025,200,depthB,1025,460,depthB,1010,460,depthB,
		1020,20,depthW,1040,20,depthW,1040,460,depthW,1020,460,depthW,
		1030,200,depthB,1045,200,depthB,1045,460,depthB,1030,460,depthB,
		1040,20,depthW,1060,20,depthW,1060,460,depthW,1040,460,depthW,
		
		1060,20,depthW,1080,20,depthW,1080,460,depthW,1060,460,depthW,
	};
	const GLdouble KeyColors[] = {
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,0.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
		
		1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,1.0f, 1.0f, 1.0f, 1.0f,
	};


	doc=[[NSDocumentController sharedDocumentController] currentDocument];
	glEnableClientState(GL_COLOR_ARRAY);
	glVertexPointer(3, GL_SHORT, 0, KeyVertices);
	glColorPointer(4, GL_DOUBLE, 0, KeyColors);
	for (int i = 0; i <MAX_KEY_NOTE ; i++) {
		//NSLog(@"Get Midi@%d", i+0x15);
		if ([doc getMidiNote:(i+0x15)] == 0) {
			glEnableClientState(GL_COLOR_ARRAY);
			glColorPointer(4, GL_DOUBLE, 0, KeyColors);
			glDrawArrays(GL_QUADS, (i*4), 4);	
		} else {
			//NSLog(@"Midi on!@%d", (i+0x15));
			glDisableClientState(GL_COLOR_ARRAY);
			glColor4f(0.929f, 0.427f, 0.239f, 1.0f);
			glDrawArrays(GL_QUADS, (i*4), 4);	
		}

		glDisableClientState(GL_COLOR_ARRAY);
		glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
		glLineWidth(2.0f);
		glDrawArrays(GL_LINE_LOOP, i*4, 4);
	}
	
#ifdef DRAW_BORDER
	glDisableClientState(GL_COLOR_ARRAY);
	glVertexPointer(3, GL_SHORT, 0, BoldBorder);
	for (int i = 0; i < BORDER_LINES; i++) {
		glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
		glLineWidth(2.0f);
		glDrawArrays(GL_LINES, i*2, 2);
	}
#endif
	
	//[[self openGLContext] flushBuffer];
}

- (void)dealloc {
	while (!mIsFinished) {
		[NSThread sleepForTimeInterval:0.05];
	}
	[super dealloc];
}

- (void)drawProc:(id)dummy {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];	
	
	// convert nano sec to mach time.
	mach_timebase_info_data_t timebaseInfo;
	mach_timebase_info(&timebaseInfo);
	// keep 60fps
	uint64_t frameInterval = (uint64_t)(1000000000 / 60.0) * timebaseInfo.denom / timebaseInfo.numer;
	
	uint64_t prevTime = mach_absolute_time();
	mIsRunning = YES;
	
	while (mIsRunning) {
		CGLLockContext(mCGLContext);
		CGLSetCurrentContext(mCGLContext);
		[self draw];
		CGLFlushDrawable(mCGLContext);
		CGLUnlockContext(mCGLContext);
		
		uint64_t endTime = prevTime + frameInterval;
		
		prevTime = mach_absolute_time();
		if (endTime > prevTime) {
			mach_wait_until(endTime);
			prevTime = endTime;
		}
		
	}
	mIsFinished = YES;
	[pool drain];
}	
@end
