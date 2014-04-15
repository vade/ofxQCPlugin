//
//  QC_Plugin_TestPlugIn.h
//  QC Plugin Test
//
//  Created by vade on 10/10/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//


// Open Frame Works headers
#import "ofMain.h"
#import "ofxQCPlugin.h" // this is our OF Addon  bridge to QC

#import <Quartz/Quartz.h>

//class testApp;

@interface ofxQCPluginSuperClass : QCPlugIn
{
	// our OF stuff is in here
	//void* ofBaseAppImplementation;	// this is our ofBaseApp Implementation
	NSValue *ofBaseAppPointerValue;	
	
	ofxQCBaseWindowProxy* windowProxy;
}
// we will set this in our subclass of ofxQCPluginSuperClass
// ie, our new Open Frameworks based QC plugin
@property (assign) id ofBaseAppPointerValue;B

// basic inputs for the Open Framework environment are set here.
@property (assign) double inputMousePositionX;
@property (assign) double inputMousePositionY;
@property (assign) BOOL inputMousePressedLeft;
@property (assign) BOOL inputMousePressedRight;

@property (assign) double inputWindowSizeX;
@property (assign) double inputWindowSizeY;

@end
