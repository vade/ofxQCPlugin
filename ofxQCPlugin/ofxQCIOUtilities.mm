/*
 *  ofxQCImage.cpp
 *  QC Plugin Test
 *
 *  Created by vade on 10/11/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

// eventually use CGLMacro.h yo

#import "ofxQCIOUtilities.h"

//GLuint copyofTextureToRectTexture(id<QCPlugInContext> qcContext, ofTexture* texture)
// need to handle flipped ? hrm.
GLuint copyTextureToRectTexture(id<QCPlugInContext> qcContext, GLuint textureName, GLsizei width, GLsizei height, GLenum textureTarget)
{		
	CGLSetCurrentContext([qcContext CGLContextObj]);
	CGLLockContext([qcContext CGLContextObj]);
	
	// cache FBO state
	GLint previousFBO, previousReadFBO, previousDrawFBO;
	
	glGetIntegerv(GL_FRAMEBUFFER_BINDING_EXT, &previousFBO);
	glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING_EXT, &previousReadFBO);
	glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING_EXT, &previousDrawFBO);
	
	// new texture
	GLuint newTex;
	glGenTextures(1, &newTex);
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, newTex);
	glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	
	// make new FBO and attach.
	GLuint fboID;
	glGenFramebuffersEXT(1, &fboID);
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboID);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_RECTANGLE_ARB, newTex, 0);
	
	// draw ofTexture into new texture;
	glPushAttrib(GL_ALL_ATTRIB_BITS);
	
	glViewport(0, 0, width, height);
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	
	// weirdo ortho
	glOrtho(0.0, width, height, 0.0, -1, 1);		
	
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	glLoadIdentity();
	
	// draw the texture.
	//texture->draw(0,0);
	
	glEnable(textureTarget);
	glBindTexture(textureTarget, textureName);
	
	if(textureTarget == GL_TEXTURE_RECTANGLE_ARB)
	{	
		glBegin(GL_QUADS);
		glTexCoord2f(0, 0);
		glVertex2f(0, 0);
		glTexCoord2f(0, height);
		glVertex2f(0, height);
		glTexCoord2f(width, height);
		glVertex2f(width, height);
		glTexCoord2f(width, 0);
		glVertex2f(width, 0);
		glEnd();		
	}
	else if(textureTarget == GL_TEXTURE_2D)
	{
		glBegin(GL_QUADS);
		glTexCoord2f(0, 0);
		glVertex2f(0, 0);
		glTexCoord2f(0, 1);
		glVertex2f(0, height);
		glTexCoord2f(1, 1);
		glVertex2f(width, height);
		glTexCoord2f(1, 0);
		glVertex2f(width, 0);
		glEnd();		
	}
	else
	{
		// uh....
	}
	
	glBindTexture(textureTarget, 0);
	glDisable(textureTarget);
	
	// Restore OpenGL states 
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	
	// restore states // assume this is balanced with above 
	glPopAttrib();
	
	// pop back to old FBO
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, previousFBO);	
	glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, previousReadFBO);
	glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, previousDrawFBO);
	
	glFlushRenderAPPLE();
	
	// delete our FBO so we dont leak.
	glDeleteFramebuffersEXT(1, &fboID);
	
	CGLUnlockContext([qcContext CGLContextObj]);
	
//	NSLog(@"new texture: %u", newTex);
	
	return newTex;
}

// faster, no pixel backed ofImage from the get go, only the ofTexture.
ofTexture* ofTextureFromQCImage(id<QCPlugInContext> qcContext, id<QCPlugInInputImageSource> qcImage)
{
	// make a new ofTexture. We do it out here because ofTexture calls clear() and deletes
	// the active texture!? *grumble*
	
	ofTexture* newOfTexture = new ofTexture();
	
	// lock our qcImage buffers rep 
	if(newOfTexture && qcImage && [qcImage lockTextureRepresentationWithColorSpace:[qcImage imageColorSpace] forBounds:[qcImage imageBounds]])
	{
		// we need some way to draw into the ofTexture. 
		// first we copy the texture. We do this so it sticks around after we unlock/unbind the QC image texture representation below.
		[qcImage bindTextureRepresentationToCGLContext:[qcContext CGLContextObj] textureUnit:GL_TEXTURE0 normalizeCoordinates:NO];
		
		GLuint newTextureID = copyTextureToRectTexture(qcContext, [qcImage textureName], [qcImage imageBounds].size.width, [qcImage imageBounds].size.height, [qcImage textureTarget]);

		// set the texture data params manually cause we are awesome like that.
		//newOfTexture->texData.textureName[0] = newTextureID;
		newOfTexture->texData.textureID = newTextureID;
		newOfTexture->texData.textureTarget = GL_TEXTURE_RECTANGLE_ARB;
		newOfTexture->texData.width = [qcImage imageBounds].size.width;
		newOfTexture->texData.height = [qcImage imageBounds].size.height;
		newOfTexture->texData.bFlipTexture = [qcImage textureFlipped]; // proper flippage.
		newOfTexture->texData.tex_w = [qcImage imageBounds].size.width;
		newOfTexture->texData.tex_h = [qcImage imageBounds].size.height;
		newOfTexture->texData.tex_t = [qcImage imageBounds].size.width;
		newOfTexture->texData.tex_u = [qcImage imageBounds].size.height;
		newOfTexture->texData.glTypeInternal = GL_RGBA; // TODO:  ? is this correct?
		newOfTexture->texData.glType = GL_RGBA;
		newOfTexture->texData.bAllocated = true;
		
		[qcImage unbindTextureRepresentationFromCGLContext:[qcContext CGLContextObj] textureUnit:GL_TEXTURE0];
		[qcImage unlockTextureRepresentation];
		
		return newOfTexture;
	}				   
}

// slower, with pixel backed ofImage
ofImage* ofImageFromQCImage(id<QCPlugInContext> qcContext, id<QCPlugInInputImageSource> qcImage)
{
	// lock our qcImage buffers rep 
	if(qcImage && [qcImage lockBufferRepresentationWithPixelFormat:QCPlugInPixelFormatARGB8 colorSpace:[qcImage imageColorSpace] forBounds:[qcImage imageBounds]])
	{
		// make a new empty ofImage		
		ofImage* newOfImage = new ofImage();
		
		// read in image data from QC.
		
		// TODO: make this work.
		// this is totally broken, we need to memcopy shit here or something, because once we unlock, things vanish.
		newOfImage->setFromPixels((unsigned char*)[qcImage bufferBaseAddress], [qcImage imageBounds].size.width, [qcImage imageBounds].size.height, OF_IMAGE_COLOR_ALPHA, NO);
			
		[qcImage unlockBufferRepresentation];

		return newOfImage;
	}
}

/* release callbacks for our output image provider helper should be implemented in your QCPlugin and should look like:
// for textures:
void MyQCPlugInTextureReleaseCallback (CGLContextObj cgl_ctx, GLuint name, void* context)
{
	glDeleteTextures(1, &name);
}

// for bytes
` MyQCPlugInBufferReleaseCallback (const void address, void * context)
{
	free(address);
}
*/
 
id <QCPlugInOutputImageProvider> qcImageFromOfImage(id<QCPlugInContext> qcContext, ofImage image, void* releaseCallback)
{
	id outputProvider = nil;

	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);

	CGLSetCurrentContext([qcContext CGLContextObj]);

	
	//ofTexture imageTexture;
	//imageTexture = image.getTextureReference();
	
	// depending on the ofImage, if its texture backed, we use a texture provider, otherwise a pixel buffer provider.
	if(image.getTextureReference().getTextureData().bAllocated == true)
	{		
		ofTextureData data = image.getTextureReference().getTextureData(); 
				
		CGLSetCurrentContext([qcContext CGLContextObj]);
		
		outputProvider = [qcContext outputImageProviderFromTextureWithPixelFormat:QCPlugInPixelFormatARGB8
																	   pixelsWide:image.getWidth() 
																	   pixelsHigh:image.getHeight()
																			 name:copyTextureToRectTexture(qcContext, data.textureID, image.getTextureReference().getWidth(), image.getTextureReference().getHeight(), data.textureTarget)  //copyofTextureToRectTexture(qcContext, &imageTexture)
																		  flipped:NO // above function fixes that. 
																  releaseCallback:(QCPlugInTextureReleaseCallback) releaseCallback 
																   releaseContext:nil 
																	   colorSpace:colorspace
																 shouldColorMatch:YES];
	}
	else 
	{
		outputProvider = [qcContext outputImageProviderFromBufferWithPixelFormat:QCPlugInPixelFormatARGB8
																	  pixelsWide:image.getWidth()
																	  pixelsHigh:image.getHeight()
																	 baseAddress:image.getPixels()
																	 bytesPerRow:4 * 8 * image.getWidth() // this should be right?
																 releaseCallback:(QCPlugInBufferReleaseCallback) releaseCallback
																  releaseContext:nil
																	  colorSpace:colorspace
																shouldColorMatch:YES];
	}

	
	// no leaks please.
	CGColorSpaceRelease(colorspace);

	return outputProvider;
}

id <QCPlugInOutputImageProvider> qcImageFromOfTexture(id<QCPlugInContext> qcContext, ofTexture texture, void* releaseCallback)
{
	id outputProvider = nil;
	
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		
	if(texture.getTextureData().bAllocated == true)
	{		
		ofTextureData data = texture.getTextureData(); 
				
		CGLSetCurrentContext([qcContext CGLContextObj]);
		
		outputProvider = [qcContext outputImageProviderFromTextureWithPixelFormat:QCPlugInPixelFormatARGB8
																	   pixelsWide:texture.getWidth() 
																	   pixelsHigh:texture.getHeight()
																			 name:copyTextureToRectTexture(qcContext, data.textureID, texture.getWidth(), texture.getHeight(), data.textureTarget)  //copyofTextureToRectTexture(qcContext, &imageTexture)
																		  flipped:NO // above function fixes that. 
																  releaseCallback:(QCPlugInTextureReleaseCallback) releaseCallback 
																   releaseContext:nil 
																	   colorSpace:colorspace
																 shouldColorMatch:YES];
	}
	
	// no leaks please.
	CGColorSpaceRelease(colorspace);
	
	return outputProvider;
}


CGColorRef cgColorFromofColor(ofColor color)
{
	static float refColor[4];
	refColor[0] = color.r/255.0;
	refColor[1] = color.g/255.0;
	refColor[2] = color.b/255.0;
	refColor[3] = color.a/255.0;
	
	CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	
	CGColorRef newColorRef =  CGColorCreate(space, refColor);

	// no leaks
	CGColorSpaceRelease(space);
	
	return newColorRef;
}

ofColor ofColorFromNSColor(CGColorRef color)
{
	ofColor newcolor = ofColor();
	
	const float* refColor;
	refColor = CGColorGetComponents(color);
	
	newcolor.r = refColor[0];
	newcolor.g = refColor[1];
	newcolor.b = refColor[2];
	newcolor.a = refColor[3];
	
	return newcolor;
}


