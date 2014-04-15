ofxQCPlugin Readme

***



***************************************
Installation
***************************************

The latest beta of ofxQCPlugin now resides in your OpenFrameworks Addons folder, and the example plugins below reside in your Apps folder, just like any good Open Frameworks citizen should.

Copy "ofxQCplugin" to your "of_preRelease_v0061_osxSL_FAT/addons" folder

Copy "QC Plugins" to your "of_preRelease_v0061_osxSL_FAT/apps" folder

If you wish to make a new QC plugin, you probably want to duplicate one of the existing ones. 

Todo: Make template Consumer, Provider and Processor ofQCPlugin projects.


***************************************
Important : 32 bit only
***************************************

QC plugins like to be 32/64 universal, but for now, due to Quicktime dependencies, Open Frameworks based plugins are by default 32 bit only. If you want to stub out the Quicktime Codebase within your OF install, feel free to do so, you should be able to get 64 bit compliance with a little bit of work.


***************************************
Important : Name Space Collisions:
***************************************

Since Quartz Composer plugins use ObjectiveC++ to load the Open Frameworks ofBaseApp (usually your 'testApp'), and more than one Open Frameworks powered Quartz Composer plugin may be loaded at a single time in a host app, we need to pay attention to name space collisions.

For example, if we have two Quartz Composer plugins that both have ofBaseApp implementations named 'testApp' that do different things (ie, one draws graphics the other does audio analysis), if both Quartz Composer plugins are loaded its undefined which testApp implementation is used. You will get one and only one of the testApp behaviors in instances of your different plugins, and things will break or behave in very odd ways and you will slowly go insane.

This means, basically, make sure to give each testApp class its own, as unique-as-possible class name. The same goes for Quartz Composer plugins, by the way, as documented in Apples Quartz Composer Custom Patch Programming guide, my advice is if you have a plugin called 'myAwesomeFooPlugin', call your ofBaseApp class 'myAwesomeFooTestApp', so you wont be confused later on.

***************************************
Example Plugins:  
***************************************

	OFtoQCImage: loads an image within Open Frameworks and outputs it to the Quartz Composer world. 
	
	QCtoOFImage: The opposite of above, sends any image from Quart Composer into Open Frameworks.
	
	SoundPlayerFFT: A port of the Sound Player FFT example with mp3 loading, playback, working interactive mouse and FFT analysis and visualization.