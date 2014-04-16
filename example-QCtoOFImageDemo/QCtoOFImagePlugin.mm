//
//  QC_Plugin_TestPlugIn.m
//  QC Plugin Test
//
//  Created by vade on 10/10/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>

#import "QCtoOFImagePlugin.h"

#define	kQCPlugIn_Name				@"QC to OF Image Demo"
#define	kQCPlugIn_Description		@"ofxQCPlugin Demo: passing an image to Open Frameworks from Quartz Composer using ofxQCPlugin.\n\nvade \n\nhttp://code.google.com/p/ofxqcplugin/"


static void MyQCPlugInTextureReleaseCallback (CGLContextObj cgl_ctx, GLuint name, void* context)
{	
	glDeleteTextures(1, &name);
}

@implementation QCtoOFImagePlugin

// for whatever reason, we can't put these in our superclass
// it causes compilation errors. this is sad. :(

@dynamic inputMousePositionX;
@dynamic inputMousePositionY;
@dynamic inputMousePressedLeft;
@dynamic inputMousePressedRight;
@dynamic inputWindowSizeX;
@dynamic inputWindowSizeY;

@dynamic inputImage;

+ (NSDictionary*) attributes
{	
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	return [super attributesForPropertyPortWithKey:key];
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode
{	
	return kQCPlugInTimeModeTimeBase;
}

@end

@implementation QCtoOFImagePlugin (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{			
	// the only thing we *HAVE* to do, is make sure we instantiate a new 
	// ofBaseApp implementation!
	
	pluginTestApp = new testApp();
	
	// this will let our superclass QC Plugin talk to our custom ofBaseApp
	// and the QC Plugin will take care of everything else.
	[self setOfBaseAppPointerValue:[NSValue valueWithPointer:pluginTestApp]];

	// call our super plugins start execution method
	// this will set up the Open frameworks environment, the proxy window, etc for us.
	[super startExecution:context];
	return YES;
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{	
	// set any variables into OF before you run super. 
	// this uses our ofTextureFromQCImage, see ofxQCImageUtilities for details.
	pluginTestApp->testOfTexture = ofTextureFromQCImage(context, self.inputImage);
	
	// call our super plugins execute method, this handles 
	BOOL didSuperExecute = [super execute:context atTime:time withArguments:arguments];
	
	// call any post OF actions here, like extracting QCImages from ofTextures and the like.
	return didSuperExecute;
}

@end
