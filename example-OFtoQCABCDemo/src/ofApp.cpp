#include "ofApp.h"
//class AutoLoadShader : public ofShader
//{
//public:
//	
//	Poco::Timestamp lastFragTimestamp, lastVertTimestamp;
//	ofFile vertShader, fragShader;
//	
//	void watch(string vertName, string fragName)
//	{
//		vertShader.open(vertName);
//		fragShader.open(fragName);
//		
//		ofAddListener(ofEvents().update, this, &AutoLoadShader::onUpdate);
//	}
//	
//	void reload()
//	{
//		load(vertShader.path(), fragShader.path());
//	}
//	
//	void onUpdate(ofEventArgs &e)
//	{
//		if (lastVertTimestamp != vertShader.getPocoFile().getLastModified()
//			|| lastFragTimestamp != fragShader.getPocoFile().getLastModified())
//		{
//			reload();
//		}
//	}
//};
//
//AutoLoadShader mShader;
//--------------------------------------------------------------
void ofApp::setup()
{
	ofSetVerticalSync(true);
    ofSetLogLevel(OF_LOG_SILENT);
	ofSetFrameRate(60);
	ofBackground(0);
	
	string path = "test.abc";
	
	abc.open(path);
    abc.setTime(0);
    
    
    mesh.clear();
    for (int i = 0; i < abc.size(); i++)
    {
        ofMesh foomesh;
        if (abc.get(i, foomesh))
        {
            //
            mesh.append(foomesh);
            //foomesh.drawWireframe();
        }
    }
}

//--------------------------------------------------------------
void ofApp::update()
{
	float t = abs(ofMap(sin(ofGetElapsedTimef()/abc.getMaxTime()), -1, 1, -abc.getMaxTime(), abc.getMaxTime()));
    
    //float t = timeline.getValue("abc");
    abc.setTime(t);
    
    //
     abc.get("/Camera/CameraShape", cam);
    
}

//--------------------------------------------------------------
void ofApp::draw()
{
	cam.begin();
    glEnable(GL_DEPTH_TEST);
    mesh.draw();
    glDisable(GL_DEPTH_TEST);
	cam.end();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key)
{
	
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key)
{
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y)
{
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button)
{
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button)
{
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button)
{
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h)
{
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg)
{
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo)
{
    
}