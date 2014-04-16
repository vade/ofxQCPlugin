#pragma once

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
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

		// test input texture, this comes from Quartz Composer
		// set to NULL here so we can test it. Fuck
		ofTexture* testOfTexture = NULL;

		// test loading and drawing images ourself withing OF.
		ofImage testOfImage;

};
