ofxQCPlugin
===========

ofxQCPlugin is an add on for Quartz Composer and Open Frameworks allowing developers to leverage the Open Frameworks media &amp; programming environment to create new Quartz Composer plugins. 

ofxQCPlugin allows interoperability with the Quartz Composer 'run time' and the Open Framework environment, including image passing between both environments.  

The eventual goal is to be able to simply move your existing Open Frameworks ofApp and with a simple re-compile have a functioning Quartz Composer plugin. A bit more work can allow you to pass Images, colors, structures (arrays and key value pairs), strings and numbers between the Quartz Composer environment and your Open Framework based code.  You can use ofxQCPlugin to:  

* Post process your Open Framework rendering using the plethora of existing image processing filters in Quartz Composer.  
* Leverage Open Frameworks native drawing, text, and visualization tools inside of Quartz Composer to make visualizations that would be difficult using a node based paradigm on its own.  
* Create unique, custom, image processing effects for Quartz Composer powered VJ applications, like VDMX, Coge and Arkaos Grand VJ using Open Frameworks. 
* Extend Quartz Composers capability by leveraging all of the add-ons currently available to Open Frameworks, and use them side by side with Quartz Composers standard tools.



Installation
===========

The latest beta of ofxQCPlugin now resides in your OpenFrameworks Addons folder, and the examples reside within, just like any good Open Frameworks citizen should.

Copy "ofxQCplugin" to your "openFrameworks/addons" folder

If you wish to make a new QC plugin, you probably want to duplicate one of the existing ones. 

Todo: Make template Consumer, Provider and Processor ofQCPlugin projects.


Important : 32 bit only
===========

QC plugins like to be 32/64 universal, but for now, due to Quicktime dependencies, Open Frameworks based plugins are by default 32 bit only. If you want to stub out the Quicktime Codebase within your OF install, feel free to do so, you should be able to get 64 bit compliance with a little bit of work.


Important : Name Space Collisions
===========

Since Quartz Composer plugins use ObjectiveC++ to load the Open Frameworks ofApp (usually your 'ofApp'), and more than one Open Frameworks powered Quartz Composer plugin may be loaded at a single time in a host app, we need to pay attention to name space collisions.

For example, if we have two Quartz Composer plugins that both have ofApp implementations named 'ofApp' that do different things (ie, one draws graphics the other does audio analysis), if both Quartz Composer plugins are loaded its undefined which testApp implementation is used. You will get one and only one of the testApp behaviors in instances of your different plugins, and things will break or behave in very odd ways and you will slowly go insane.

This means, basically, make sure to give each testApp class its own, as unique-as-possible class name. The same goes for Quartz Composer plugins, by the way, as documented in Apples Quartz Composer Custom Patch Programming guide. 

My advice is if you have a plugin called 'myAwesomeFooPlugin', call your ofApp class 'myAwesomeFooTestApp', so you wont be confused later on.

Example Plugins:  
===========

* OFtoQCImage: loads an image within Open Frameworks and outputs it to the Quartz Composer world. 
	
* QCtoOFImage: The opposite of above, sends any image from Quartz Composer into Open Frameworks.
	
* SoundPlayerFFT: A port of the Sound Player FFT example with mp3 loading, playback, working interactive mouse and FFT analysis and visualization.