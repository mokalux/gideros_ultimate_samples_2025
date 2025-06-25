--[[
*************************************************************
 * This script is developed by Scouser, it uses modules 
 * created by other developers but I have made minor / subtle
 * changes to get the effects I required.
 * Feel free to distribute and modify code, 
 * but keep reference to its creator
**************************************************************
]]--

optionScreen = Core.class(Sprite)

local imgBase = getImgBase()
local font = getFont()

local checkX = 60
local sliderX = 240
local gap = 70

local col = {r=243/255,g=206/255,b=0,a=1}

local soundSlider
local musicSlider
local redSlider

function optionScreen:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new(imgBase.."opt_back.png"))
	self:addChild(screen)
	screen:setPosition(0,0)
	
	local txtY = 100
	-- Add a back button to return to your main menu
--[[	
	local backButton = Button.new(Bitmap.new(Texture.new(buttonBase.."back_up.png")), Bitmap.new(Texture.new(buttonBase.."back_up.png")))
	backButton:setPosition((appWidth-backButton:getWidth())/2, appHeight-backButton:getHeight())
	screen:addChild(backButton)
	backButton:addEventListener("click", 
		function() sceneManager:changeScene("menuScreen", 2, SceneManager.crossfade, easing.outBack, false) end
	)
]]	
	-- Functionality for checkboxes
	-- Music On / Off
	musicChk = checkBox.new(checkX, txtY, "Music", col, 
		function(this)
			local state = this:getCheck()
			if state then settings.musicOn() 
			else settings.musicOff()
			end
		end
	)
	screen:addChild(musicChk)
	musicChk:setCheck(settings.getMusicState())
	
	-- Music Volume Slider
	musicSlider = slider.new(sliderX,txtY-46,settings.musicGetVolume(),"Music Volume",col,true)
	musicSlider:addEventListener("click",  function() settings.musicSetVolume(musicSlider:getPos()) end  )
	screen:addChild(musicSlider)

	txtY = txtY + gap
	-- Sound On / Off
	soundChk = checkBox.new(checkX, txtY, "Sound FX", col, 
		function(this)
			local state = this:getCheck()
			if state then settings.soundOn() 
			else settings.soundOff()
			end
		end	
	)
	screen:addChild(soundChk)
	soundChk:setCheck(settings.getSoundState())
	
	-- Sound Volume Slider
	soundSlider = slider.new(sliderX,txtY-46,settings.soundGetVolume(),"Sound Volume",col,true)
	soundSlider:addEventListener("click",  function() settings.soundSetVolume(soundSlider:getPos()) end )
	screen:addChild(soundSlider)
	
	txtY = txtY + gap
	-- Autosave On / Off
	autosaveChk = checkBox.new(checkX, txtY, "Autosave", col, 
		function(this)
			local state = this:getCheck()
			if state then settings.autosaveOn() 
			else settings.autosaveOff()
			end
		end
	)
	screen:addChild(autosaveChk)
	autosaveChk:setCheck(settings.getAutosaveState())
	
	redSlider = slider.new(sliderX,txtY-46,(col.r*100),"red",{r=col.r,g=0,b=0,a=1})
	-- Quick and dirty way of adding the callbacks to the sliders
	redSlider:setMoveCallback(self.adjustRed, self)
	redSlider:setClickCallback(self.adjustRed, self)

	txtY = txtY + gap
	greenSlider = slider.new(sliderX,txtY-46,(col.g*100),"green",{r=0,g=col.g,b=0,a=1})
	-- Quick and dirty way of adding the callbacks to the sliders
	greenSlider:setMoveCallback(self.adjustGreen, self)
	greenSlider:setClickCallback(self.adjustGreen, self)

	txtY = txtY + gap
	blueSlider = slider.new(sliderX,txtY-46,(col.b*100),"blue",{r=0,g=0,b=col.b,a=1})
	-- Quick and dirty way of adding the callbacks to the sliders
	blueSlider:setMoveCallback(self.adjustBlue, self)
	blueSlider:setClickCallback(self.adjustBlue, self)

	screen:addChild(redSlider)
	screen:addChild(greenSlider)
	screen:addChild(blueSlider)

	txtY = txtY + gap
	
	self:removeEventListener("exitEnd", self.onExitEnd)
end

-- Let's get rid of all of the elements shall we. This is strictly not required
-- but I thought I'd put it in for completeness
function optionScreen:onExitEnd()
	self:removeEventListener("exitEnd", self.onExitEnd)
	redSlider:onExitEnd()
	greenSlider:onExitEnd()
	blueSlider:onExitEnd()
	musicSlider:onExitEnd()
	soundSlider:onExitEnd()
	
	soundChk:onExitEnd()
	musicChk:onExitEnd()
	autosaveChk:onExitEnd()
	
	collectgarbage()
end


function optionScreen:adjustRed(this) 
	col.r = (redSlider:getPos()*2.55)/255 
	redSlider:setCol({r=col.r,g=0,b=0,a=1})
	musicSlider:setCol(col)
	soundSlider:setCol(col)
	autosaveChk:setCol(col)
	soundChk:setCol(col)
	musicChk:setCol(col)
end

function optionScreen:adjustGreen(this) 
	col.g = (greenSlider:getPos()*2.55)/255 
	greenSlider:setCol({r=0,g=col.g,b=0,a=1})
	musicSlider:setCol(col)
	soundSlider:setCol(col)
	autosaveChk:setCol(col)
	soundChk:setCol(col)
	musicChk:setCol(col)
end

function optionScreen:adjustBlue(this) 
	col.b = (blueSlider:getPos()*2.55)/255 
	blueSlider:setCol({r=0,g=0,b=col.b,a=1})
	musicSlider:setCol(col)
	soundSlider:setCol(col)
	autosaveChk:setCol(col)
	soundChk:setCol(col)
	musicChk:setCol(col)
end

