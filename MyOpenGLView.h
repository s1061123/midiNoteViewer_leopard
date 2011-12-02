//
//  MyOpenGLView.h
//  pianoTest2
//
//  Created by Tomofumi Hayashi on 11/01/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import "MyDocument.h"

@interface MyOpenGLView : NSOpenGLView {
	MyDocument *doc;
	BOOL	mIsRunning;
	BOOL	mIsFinished;
	CGLContextObj	mCGLContext;
}
@property (assign,setter=setDoc:)MyDocument* doc;

- (void)draw;
@end
