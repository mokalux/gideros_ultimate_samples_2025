--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
* And modified by Ali Lopez zero.exu@gmail.com
]]--

sceneHome = gideros.class(Sprite)


function sceneHome:init()
	print("sceneHome")
	_SCENEHOMESELF=self
	_SHEETHOME= TexturePack.new("images/home.txt", "images/home.png")
	local background = Bitmap.new(_SHEETHOME:getTextureRegion("homeBackground.png"))
	background:setPosition(0,0)
	self:addChild(background)
	
	
	local logo = Bitmap.new(_SHEETBUTTONS:getTextureRegion("gameName.png"))
	logo:setAnchorPoint(0.5,0.5)
	logo:setPosition(
		(application:getLogicalHeight())/2, 
		(logo:getHeight()/2)
	)
	self:addChild(logo)
	
		--#play
	local buttonPlay = Button.new(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("play.png")), 
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("play.png"))
	)
	buttonPlay:setPosition(
		(application:getLogicalHeight()/2-buttonPlay:getWidth()/2), 
		(application:getLogicalWidth()/2-buttonPlay:getHeight()/3)
	)
	self:addChild(buttonPlay)
	buttonPlay:addEventListener("click", 
		function()
			--go to pack select scene
			sceneManager:changeScene("scenePackSelect", _SCENETIMETRANSITION, transition, easing.outBack) 
		end
	)
	
	--#options
	local buttonOptions = Button.new(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("options.png")), 
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("options.png"))
	)
	buttonOptions:setPosition(
		(application:getLogicalHeight()/2-buttonOptions:getWidth()/2), 
		(application:getLogicalWidth()/2+buttonOptions:getHeight()/2+20)
	)
	self:addChild(buttonOptions)
	buttonOptions:addEventListener("click", 
		function()
			--go to pack select scene
			sceneManager:changeScene("sceneOptions", _SCENETIMETRANSITION, transition, easing.outBack) 
		end
	)	
	
	--#credits
	local buttonCredits = Button.new(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("credits.png")), 
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("credits.png"))
	)
	buttonCredits:setPosition(
		(application:getLogicalHeight()/2-buttonCredits:getWidth()/2), 
		(application:getLogicalWidth()/2+buttonCredits:getHeight()*1.5+20)
	)
	self:addChild(buttonCredits)
	buttonCredits:addEventListener("click", 
		function()
			--go to pack select scene
			--sceneManager:changeScene("sceneCredits", _SCENETIMETRANSITION, transition, easing.outBack) 
		end
	)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	_SHEETHOME=nil
	gc()
end

function sceneHome:onExitBegin()	
	local i=_SCENEHOMESELF:getNumChildren()
	while i>0 do
		local sprite = _SCENEHOMESELF:getChildAt(i)
		_SCENEHOMESELF:removeChild(sprite)
		sprite=nil
		i=i-1
	end
	
	_SCENEHOMESELF:removeEventListener("exitBegin", _SCENEHOMESELF.onExitBegin, _SCENEHOMESELF)
	_SCENEHOMESELF=nil
	gc()
end