//
//  QC_Plugin_TestPlugIn.h
//  QC Plugin Test
//
//  Created by vade on 10/10/09.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//


// Open Frame Works headers
#import "testApp.h"
#import "ofMain.h"
#import "ofxQCPlugin.h" // this is our OF Addon  bridge to QC

#import <Quartz/Quartz.h>

// this is our Open Frameworks ofBaseApp implementation.
class testApp;

// our plugin is a subclass of our ofxQCPluginSuperClass
// which implements specific functionality we want.
@interface QCtoOFImagePlugin : ofxQCPluginSuperClass
{
	// an instance of our ofBaseApp for our plugin
	testApp* pluginTestApp;
}


@property (assign) id<QCPlugInInputImageSource> inputImage;

/* we can also define output images, but we need to make sure we are either a
"provider" or a "processor" patch type. Consumers cannot have output images

 @property (assign) id<QCPlugInOutputImageProvider> outputImage;
*/

@end
