# Gideros Sublime v0.01 README #


## A 'work-in-progress' Sublime Text package for Gideros SDK. ##


## Current Features: ##

* Written in Python for access to Sublime api.
* Uses Gideros gdrbridge to interface with players and output.
* Basic code completion & highlighting for Lua + Gideros
* Run project on Gideros & device players
* New, Set, Edit, Save IP address for quick player switching
* Output to console



## Installation: ##


### Note: Requires Sublime Text 3 (is multithreading) ###


### OSX: ###

- Install Sublime Text 3 to /Appliations and then run it
	
- Drop this 'Gideros' folder into: ~/Library/Application Support/Sublime Text 3/Packages
	
- Restart Sublime Text 3

- File > Open > [Gideros Project root folder]

- Project > 'Save Project As...' > [Gideros Project root folder] / [Some Name].sublime-project

- View > Syntax > 'Gideros Lua'


### Windows: ###

- Install Sublime Text 3

- Drop this 'Gideros' folder into: %APPDATA%\Sublime Text 3\Packages

- Restart Sublime Text 3

- File > Open > [Gideros Project root folder]

- Project > 'Save Project As...' > [Gideros Project root folder] \ [Some Name].sublime-project

- View > Syntax > 'Gideros Lua'


## How to use: ##

- Tools > Gideros > Choose from options listed

- Sublime Command Pallet: Type 'gideros', 'set ip', 'start player', etc...

- HotKeys: f10 to start player, f9 to stop player