/*
 *  ofxQCImage.h
 *  QC Plugin Test
 *
 *  Created by vade on 10/11/09.
 *  Copyright 2009 vade. All rights reserved.
 *
 */

#import "ofImage.h"
#import "ofTexture.h"

#import	<Quartz/Quartz.h>
#import <OpenGL/OpenGL.h>

// ofxQCImageUtilities is a set of utility functions allowing you to
// exchange image IO between Open Frameworks and Quartz Composer images.

//----------------------------------------------
// From Quartz Composer to Open Frameworks:
//----------------------------------------------

// you can create pointers to ofImages and/or ofTextures in your 'ofBaseApp' implementation
// and pass them in from Quartz Composer images using either
//
// ofTextureFromQCImage()
//
// or
//
// ofImageFromQCImage() 
//
// and then draw them as usual in Open Frameworks. 

// Set the pointer value inside of the Quartz Plugin before update/draw is called.
// Make sure that you dispose of them at the end of your draw function. 
// Quartz Composer images are temporary and end up being recycled at the end of the draw cycle.

//----------------------------------------------
// From  Open Frameworks to Quartz Composer:
//----------------------------------------------

// you can create pointers to ofImages and/or ofTextures in your 'ofBaseApp' implementation
// pass them through to Quartz Composer output images using either
//
// qcImageFromOfImage()
// 
// or 
//
// qcImageFromOfTexture()
//
// and draw them as using in Quartz Composer.

// Set the pointer value inside of the Quartz Plugin after update/draw is called.
// Quartz Composer will handle disposing of them, so you can re-use your ofImages/ofTextures should you want. 
// Quartz Composer images are temporary and end up being recycled at the end of the draw cycle.


//----------------------------------------------
// Image IO
//----------------------------------------------

// Quartz Composer wants a unique (disposable) rect texture each frame. 
// This copies any texture to a new GL_TEXTURE_RECTANGLE_ARB texture for disposable output.
GLuint copyTextureToRectTexture(id<QCPlugInContext> qcContext, GLuint textureName, GLsizei width, GLsizei height, GLenum textureTarget);

// return a new ofTexture from an input QCImage.
// This is fast path option
ofTexture* ofTextureFromQCImage(id<QCPlugInContext> qcContext, id<QCPlugInInputImageSource> qcImage);

// return a new ofImage (including CPU side pixel buffer) from a QCImage. 
// This is slower than the above method due to GPU -> CPU readback.
ofImage* ofImageFromQCImage(id<QCPlugInContext> qcContext, id<QCPlugInInputImageSource> qcImage);

// return a valid output image provider for QC from an ofImage using its internal texture,if it has one, or its pixel backing
id <QCPlugInOutputImageProvider> qcImageFromOfImage(id<QCPlugInContext> qcContext, ofImage image, void* releaseCallback);

// return a valiud output image provider for QC from an ofTexture.
id <QCPlugInOutputImageProvider> qcImageFromOfTexture(id<QCPlugInContext> qcContext, ofTexture texture, void* releaseCallback);

//----------------------------------------------
// Color IO
//----------------------------------------------

CGColorRef cgColorRefFromofColor(ofColor color);
ofColor ofColorFromCGColorRef(CGColorRef color);
