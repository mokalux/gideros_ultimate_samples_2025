
--[[

	---------------------------------------------
	Fool Job
	a game by hubert ronald
	---------------------------------------------
	a game of liquid puzzle
	Gideros SDK Power and Lua coding.

	Artwork: Kenney Game Assets
			Platform Pack Industrial
			http://kenney.nl/assets/platformer-pack-industrial
	
	Design & Coded
	by Hubert Ronald
	contact: hubert.ronald@gmail.com
	Development Studio: [-] Liasoft
	Date: Aug 26th, 2017
	
	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator

	The MIT License (MIT)
	
	Copyright (C) 2017 Hubert Ronald

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	
	---------------------------------------------
	FILE: MAIN
	---------------------------------------------
	
--]]

----------------------------------------
--	FIX DIMENSION DEVICE
----------------------------------------
--application:setOrientation(Application.LANDSCAPE_LEFT)

--all change
_W = application:getContentWidth()
_H  = application:getContentHeight()		--reverse
--print(_W,_H)
--application:setLogicalDimensions(_W, _H)

Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()
_WD,_HD  = application:getDeviceWidth(), application:getDeviceHeight()		--reverse
_Diag, _DiagD = _W/_H, _WD/_HD

----------------------------------------
--	LIBRARY
----------------------------------------
local gtween = require "Library/gtween"
require "Library/easing"
require "Library/scenemanager"


---------------------------------------------
--	SCENE MANAGER
---------------------------------------------
transitions = {
	-- Move functions
	--[[1]]		SceneManager.moveFromLeft,
	--[[2]]		SceneManager.moveFromRight,
	--[[3]]		SceneManager.moveFromBottom,
	--[[4]]		SceneManager.moveFromTop,
	
	--[[5]]		SceneManager.moveFromLeftWithFade,
	--[[6]]		SceneManager.moveFromRightWithFade,
	--[[7]]		SceneManager.moveFromBottomWithFade,
	--[[8]]		SceneManager.moveFromTopWithFade,
	
	--Overlay functions
	--[[9]]		SceneManager.overFromLeft,
	--[[10]]	SceneManager.overFromRight,
	--[[11]]	SceneManager.overFromBottom,
	--[[12]]	SceneManager.overFromTop,
	
	--[[13]]	SceneManager.overFromLeftWithFade,
	--[[14]]	SceneManager.overFromRightWithFade,
	--[[15]]	SceneManager.overFromBottomWithFade,
	--[[16]]	SceneManager.overFromTopWithFade,
	
	--Fade & flip functions
	--[[17]]	SceneManager.fade,
	--[[18]]	SceneManager.crossFade, -- nice =)
	--[[19]]	SceneManager.flip,
	--[[20]]	SceneManager.flipWithFade,
	--[[21]]	SceneManager.flipWithShade,
	
	--Zoom functions
	--[[22]]	SceneManager.zoomOutZoomIn,
	--[[23]]	SceneManager.rotatingZoomOutZoomIn,
}


---------------------------------------------
-- KEEP DEVICE SCREEN AWAKE
---------------------------------------------
application:setKeepAwake(true)


---------------------------------------------
-- DEFINE SCENES
---------------------------------------------
sets={}
sets.idWorld, sets.level = 1,1
local Engine = require "Game/Engine"


---------------------------------------------
-- DEFINE SCENES
---------------------------------------------
sceneManager = SceneManager.new({
	["Engine"] = Engine,
	})

---------------------------------------------
-- ADD MANAGER TO STAGE
-- http://giderosmobile.com/forum/discussion/5758/how-do-i-use-datasaver/p1
---------------------------------------------
stage:addChild(sceneManager)

--save achievements on exit
stage:addEventListener(Event.APPLICATION_SUSPEND,
	function()
			--dataSaver.save("|D|sets", sets)
	end)
stage:addEventListener(Event.APPLICATION_EXIT,
	function()
			--dataSaver.save("|D|sets", sets)
	end)


---------------------------------------------
-- GO TO THE CLASS intro
---------------------------------------------
sceneManager:changeScene("Engine", 0.5, transitions[18], easing.linear)
stage:addChild(sceneManager)
