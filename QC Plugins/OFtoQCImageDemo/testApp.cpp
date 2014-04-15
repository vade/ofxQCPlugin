#include "testApp.h"

//--------------------------------------------------------------
void ofToQCImageTestApp::setup()
{	
	// force the use of a texture to make sure our
	// image has an internal texture representation
	// load the image and then we know QC can get the contents.
	
	testOfImage.setUseTexture(true);
	testOfImage.loadImage("tdf_1972_poster.jpg");
}

//--------------------------------------------------------------
 void ofToQCImageTestApp::exit()
{
	testOfImage.clear();
}


//--------------------------------------------------------------
void ofToQCImageTestApp::update()
{
}

//--------------------------------------------------------------
void ofToQCImageTestApp::draw()
{

}

//--------------------------------------------------------------
void ofToQCImageTestApp::keyPressed(int key){
	
}

//--------------------------------------------------------------
void ofToQCImageTestApp::keyReleased(int key){
	
}

//--------------------------------------------------------------
void ofToQCImageTestApp::mouseMoved(int x, int y )
{
}

//--------------------------------------------------------------
void ofToQCImageTestApp::mouseDragged(int x, int y, int button){
	
}

//--------------------------------------------------------------
void ofToQCImageTestApp::mousePressed(int x, int y, int button){
	
}

//--------------------------------------------------------------
void ofToQCImageTestApp::mouseReleased(int x, int y, int button){
	
}

//--------------------------------------------------------------
void ofToQCImageTestApp::windowResized(int w, int h){
	
}
