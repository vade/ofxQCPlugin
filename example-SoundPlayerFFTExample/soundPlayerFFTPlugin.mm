//
//  QC_Plugin_TestPlugIn.m
//  QC Plugin Test
//
//  Created by vade on 10/10/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

#import "soundPlayerFFTPlugin.h"

// DUE TO GLEE INCLUDE ORDER ISSUES, MAKE SURE GL MACRO.H IS BELOW YOUR IMPLEMENTATION IMPORT

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>


#define	kQCPlugIn_Name				@"Sound Player FFT Demo"
#define	kQCPlugIn_Description		@"ofxQCPlugin Demo: The Sound Player FFT example running in Quartz Composer.\n\nvade \n\nhttp://code.google.com/p/ofxqcplugin/"


static void MyQCPlugInTextureReleaseCallback (CGLContextObj cgl_ctx, GLuint name, void* context)
{	
	glDeleteTextures(1, &name);
}

@implementation soundPlayerFFTPlugin

// for whatever reason, we can't put these in our superclass
// it causes compilation errors. this is sad. :(

@dynamic inputMousePositionX;
@dynamic inputMousePositionY;
@dynamic inputMousePressedLeft;
@dynamic inputMousePressedRight;
@dynamic inputWindowSizeX;
@dynamic inputWindowSizeY;

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

@implementation soundPlayerFFTPlugin (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{			
	// the only thing we *HAVE* to do, is make sure we instantiate a new 
	// ofBaseApp implementation!
		
	// this will let our superclass QC Plugin talk to our custom ofBaseApp
	// and the QC Plugin will take care of everything else.

	// call our super plugins start execution method
	// this will set up the Open frameworks environment, the proxy window, etc for us.
	CGLContextObj cgl_ctx = [context CGLContextObj];
	CGLSetCurrentContext(cgl_ctx);
	CGLLockContext(cgl_ctx);
	
	windowProxy = new ofxQCBaseWindowProxy();
	
	// this basically just sets up the coordinate system for OF.
	// you no longer draw to Quartz Composers -1, 1 QC unit coordinate space
	// but an OF one based on 0, 
	
	ofSetupOpenGL(windowProxy, 1024, 768, OF_WINDOW); 
	
	pluginTestApp = new soundPlayerFFTTestApp();

	// run our ofBaseApp.
	ofRunApp(pluginTestApp);
	
	NSString* dataPath = [NSString stringWithFormat:@"%@/Contents/Resources/Data/", [[NSBundle bundleForClass:[self class]] bundlePath]];
	
	ofSetDataPathRoot([dataPath cString]);
	
	// we have to manually run setup()
	ofGetAppPtr()->setup();
	
	CGLUnlockContext(cgl_ctx);
	
	return YES;
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{	
	// set any variables into OF before you run super. 
	// this uses our ofTextureFromQCImage, see ofxQCImageUtilities for details.
	// call our super plugins execute method, this handles 
	
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
	
	// check mouse presses
	if([self didValueForInputKeyChange:@"inputMousePressedLeft"] || [self didValueForInputKeyChange:@"inputMousePressedRight"])
	{
		float aspect = windowProxy->getWindowSize().y/windowProxy->getWindowSize().x;
		float normalizedMouseX = ((self.inputMousePositionX + 1) * 0.5);
		float normalizedMouseY = (self.inputMousePositionY - (-aspect))/(aspect - (-aspect));
		
		float mouseX = normalizedMouseX * windowProxy->getWindowSize().x;
		float mouseY = (windowProxy->getWindowSize().y) - (normalizedMouseY * windowProxy->getWindowSize().y);
		
		ofGetAppPtr()->mouseX = mouseX;
		ofGetAppPtr()->mouseY = mouseY;
		
		// if mouse is down...
		if(self.inputMousePressedLeft)
			ofGetAppPtr()->mousePressed(mouseX, mouseY, 0);
		
		else if(self.inputMousePressedRight)
			ofGetAppPtr()->mousePressed(mouseX, mouseY, 1);
		
		else if(!self.inputMousePressedLeft && !self.inputMousePressedRight)
		{
			ofGetAppPtr()->mouseReleased(mouseX, mouseY, 0);
			ofGetAppPtr()->mouseReleased();
		}
	}
		
	// check mouse motion
	if([self didValueForInputKeyChange:@"inputMousePositionX"] || [self didValueForInputKeyChange:@"inputMousePositionY"])
	{
		float aspect = windowProxy->getWindowSize().y/windowProxy->getWindowSize().x;
		float normalizedMouseX = ((self.inputMousePositionX + 1) * 0.5);
		float normalizedMouseY = (self.inputMousePositionY - (-aspect))/(aspect - (-aspect));

		float mouseX = normalizedMouseX * windowProxy->getWindowSize().x;
		float mouseY = (windowProxy->getWindowSize().y) - (normalizedMouseY * windowProxy->getWindowSize().y);

		ofGetAppPtr()->mouseX = mouseX;
		ofGetAppPtr()->mouseY = mouseY;

		if(self.inputMousePressedLeft)
			ofGetAppPtr()->mouseDragged(mouseX, mouseY, 0);	
		
		else if(self.inputMousePressedRight)
			ofGetAppPtr()->mouseDragged(mouseX, mouseY, 1);	

		else
			ofGetAppPtr()->mouseMoved(mouseX, mouseY);
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
