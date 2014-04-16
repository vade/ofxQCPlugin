//
//  QC_Plugin_TestPlugIn.m
//  QC Plugin Test
//
//  Created by vade on 10/10/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import "ofxQCPluginSuperClass.h"

#define	kQCPlugIn_Name				@"QC To OF Image Demo"
#define	kQCPlugIn_Description		@"Open Frameworks running within Quartz Composer Demo"

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>



@implementation ofxQCPluginSuperClass

@synthesize ofBaseAppPointerValue;

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>

@dynamic inputMousePositionX;
@dynamic inputMousePositionY;
@dynamic inputMousePressedLeft;
@dynamic inputMousePressedRight;

@dynamic inputWindowSizeX;
@dynamic inputWindowSizeY;

//@dynamic inputImage;
//@dynamic outputImage;

+ (NSDictionary*) attributes
{	
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	
	if([key isEqualToString:@"inputMousePositionX"])
		return [NSDictionary dictionaryWithObject:@"Mouse X Position" forKey:QCPortAttributeNameKey];
	
	if([key isEqualToString:@"inputMousePositionY"])
		return [NSDictionary dictionaryWithObject:@"Mouse Y Position" forKey:QCPortAttributeNameKey];
	
	if([key isEqualToString:@"inputMousePressedLeft"])
		return [NSDictionary dictionaryWithObject:@"Left Button" forKey:QCPortAttributeNameKey];
	
	if([key isEqualToString:@"inputMousePressedRight"])
		return [NSDictionary dictionaryWithObject:@"Right Button" forKey:QCPortAttributeNameKey];
	
	if([key isEqualToString:@"inputWindowSizeX"])
		return [NSDictionary dictionaryWithObject:@"Window Width" forKey:QCPortAttributeNameKey];
	
	if([key isEqualToString:@"inputWindowSizeY"])
		return [NSDictionary dictionaryWithObject:@"Window Height" forKey:QCPortAttributeNameKey];
	
//	if([key isEqualToString:@"inputImage"])
//		return [NSDictionary dictionaryWithObject:@"Image" forKey:QCPortAttributeNameKey];
//	
//	if([key isEqualToString:@"outputImage"])
//		return [NSDictionary dictionaryWithObject:@"Image" forKey:QCPortAttributeNameKey];
//	
	
	return nil;
}

+ (NSArray*) sortedPropertyPortKeys
{
	return [NSArray arrayWithObjects:@"inputImage", @"inputMousePositionX", @"inputMousePositionY", @"inputMousePressedLeft", @"inputMousePressedRight", @"inputWindowSizeX", @"inputWindowSizeY", nil];
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode
{	
	return kQCPlugInTimeModeTimeBase;
}

- (id) init
{
	if(self = [super init])
	{
		// we have to init our ofBaseApp when we have a GL Context, thus StartExecution:		
	}
	
	return self;
}

- (void) finalize
{
	[super finalize];
}

- (void) dealloc
{
	// need to properly dealloc testApp here.
	
	[super dealloc];
}

@end

@implementation ofxQCPluginSuperClass (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{			
	CGLContextObj cgl_ctx = [context CGLContextObj];
	CGLSetCurrentContext(cgl_ctx);
	CGLLockContext(cgl_ctx);
	
	windowProxy = new ofxQCBaseWindowProxy();
	
	// this basically just sets up the coordinate system for OF.
	// you no longer draw to Quartz Composers -1, 1 QC unit coordinate space
	// but an OF one based on 0, 
	
	ofSetupOpenGL(windowProxy, 1024, 768, OF_WINDOW); 
	
//	pluginTestApp = new testApp();
	
	// run our ofBaseApp.
	ofRunApp((ofBaseApp*)[ofBaseAppPointerValue pointerValue]);
	
	NSString* dataPath = [NSString stringWithFormat:@"%@/Contents/Resources/Data/", [[NSBundle bundleForClass:[self class]] bundlePath]];
	
	ofSetDataPathRoot([dataPath cStringUsingEncoding:NSASCIIStringEncoding]);
	
	// we have to manually run setup()
	ofGetAppPtr()->setup();
	
	CGLUnlockContext(cgl_ctx);
	
	return YES;
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{	
	CGLContextObj cgl_ctx = [context CGLContextObj];
	CGLSetCurrentContext(cgl_ctx);
	CGLLockContext(cgl_ctx);
	
	// update our proxy "window" size..
	if([self didValueForInputKeyChange:@"inputWindowSizeX"] || [self didValueForInputKeyChange:@"inputWindowSizeX"])
	{
		windowProxy->setWindowShape(self.inputWindowSizeX, self.inputWindowSizeY);
	}
	
	// handle virtual input to our of App Pointer
	// TODO: keyboard input and other mouse related functions
	if([self didValueForInputKeyChange:@"inputMousePositionX"] || [self didValueForInputKeyChange:@"inputMousePositionY"])
	{
		float aspect = windowProxy->getWindowSize().y/windowProxy->getWindowSize().x;
		float normalizedMouseX = ((self.inputMousePositionX + 1) * 0.5);
		float normalizedMouseY = (self.inputMousePositionY - (-aspect))/(aspect - (-aspect));
		
		float mouseX = normalizedMouseX * windowProxy->getWindowSize().x;
		float mouseY = (windowProxy->getWindowSize().y) - (normalizedMouseY * windowProxy->getWindowSize().y);
		
		ofGetAppPtr()->mouseMoved(mouseX, mouseY);
		ofGetAppPtr()->mouseX = mouseX;
		ofGetAppPtr()->mouseY = mouseY;
	}
	
	// do our actual per frame drawing here
	// we use the windowProxy to handle coordinate space conversions for us
	// based on our passed in window size.
	
	windowProxy->update();
	windowProxy->draw();
		
	CGLUnlockContext(cgl_ctx);
	
	return YES;
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
	ofGetAppPtr()->exit();
}

@end
