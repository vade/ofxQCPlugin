#ifndef _TEST_APP
#define _TEST_APP

#include "ofMain.h"

class qctoOFImageTestApp : public ofBaseApp
{
	public:
		void setup();
		void update();
		void draw();

		void keyPressed  (int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		
		// test input texture, this comes from Quartz Composer
		ofTexture* testOfTexture;

		// test loading and drawing images ourself withing OF.
		ofImage testOfImage;

};

#endif
