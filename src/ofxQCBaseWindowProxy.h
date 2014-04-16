/*
 *  ofxQCBaseWindowProxy.h
 *  QC Plugin Test
 *
 *  Created by vade on 10/11/09.
 *  Copyright 2009 vade. All rights reserved.
 *
 */

// this class is a proxy window for OF, for use within the Quartz Composer environment.

// Basically this class pretends to be a window but does not do much on its own. 
// It provides no GL context (QC gives this to us)
// however it does set up the GL coordinate system to match the passed in "window" size for convenience.
// This calls ofGetAppPtrs update and draw methods each frame
// and just holds the window size, 'mouse' position, and things like that.


#import "ofAppBaseWindow.h"

class ofxQCBaseWindowProxy: public ofAppBaseWindow 
{
	public:
		
		ofxQCBaseWindowProxy();
		//virtual ~ofxQCBaseWindowProxy(){};
		
		void	setupOpenGL(int w, int h, int screenMode);
		void	initializeWindow();
		void	runAppViaInfiniteLoop(ofBaseApp * appPtr);
			
		virtual void	hideCursor() {};
		virtual void	showCursor() {};
		
		virtual void	setWindowPosition(int x, int y);
		virtual void	setWindowShape(int w, int h);
			
		virtual int		getFrameNum();
		virtual	float	getFrameRate();
		
		virtual ofPoint	getWindowPosition(); 
		virtual ofPoint	getWindowSize();
		virtual ofPoint	getScreenSize();
		
		virtual void	setFrameRate(float targetRate);
		virtual void	setWindowTitle(string title){}
		
		virtual int		getWindowMode();
		
		virtual void	setFullscreen(bool fullscreen){}
		virtual void	toggleFullscreen(){}
		
		virtual void	enableSetupScreen(){}
		virtual void	disableSetupScreen(){}
	
		// additional methods not defined in ofAppBaseWindow
		
		// our proxy window is responsible for calling update/draw on our testApp class instance
		virtual void		update();
		virtual void		draw();

		// ivars
		int					windowMode;
		ofPoint				screenSize;
		ofPoint				windowSize;
		ofPoint				windowPos;
	
		float				timeNow, timeThen, fps;
		int					nFrameCount;
		bool				bEnableSetupScreen;
		float				frameRate;	
	
		// vade addition
		bool				resetModelViewMatrix;
		void				setAllow3DTransformsFromQC(bool y);
		bool				allow3DTransformsFromQC();

};

