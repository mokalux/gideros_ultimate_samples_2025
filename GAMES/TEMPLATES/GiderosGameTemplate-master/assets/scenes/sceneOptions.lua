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

sceneOptions = gideros.class(Sprite)


function sceneOptions:init()
	--here we'd probably want to set up a background picture
	_SCENEOPTIONS=self
	_SHEETHOME= TexturePack.new("images/home.txt", "images/home.png")
	local background = Bitmap.new(_SHEETHOME:getTextureRegion("homeBackground.png"))
	background:setPosition(0,0)
	self:addChild(background)
	
	--create layer for menu buttons
	local menu = Shape.new()
	menu:setFillStyle(Shape.SOLID, 0xffffff, 0.5)   
	menu:beginPath(Shape.NON_ZERO)
	menu:moveTo(application:getContentWidth()/5,application:getContentHeight()/16)
	menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()/16)
	menu:lineTo((application:getContentWidth()/5)*4, application:getContentHeight()-(application:getContentHeight()/16))
	menu:lineTo(application:getContentWidth()/5, application:getContentHeight()-(application:getContentHeight()/16))
	menu:lineTo(application:getContentWidth()/5, application:getContentHeight()/16)
	menu:endPath()
	self:addChild(menu)

	local musicOnButton
	local musicOnButtonTitle

	musicOnButton , musicOnButtonTitle = menuButtonSheetSpriteWhitTitle(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("yes.png")),
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("yes.png")), menu, 1,3,
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("music.png"))
	)
	
	local musicOffButton
	local musicOffButtonTitle
	
	musicOffButton, musicOffButtonTitle = menuButtonSheetSpriteWhitTitle(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("no.png")),
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("no.png")), menu, 1,3,
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("music.png"))
	)
	musicOnButton:addEventListener("click", 
		function()
			menu:removeChild(musicOnButton)
			music.off()
			menu:addChild(musicOffButton)
		end
	)

	musicOffButton:addEventListener("click", 
		function()
			menu:removeChild(musicOffButton)
			music.on()
			menu:addChild(musicOnButton)
		end
	)
	
	if sets.music then
		menu:addChild(musicOnButton)
	else
		menu:addChild(musicOffButton)
	end
	menu:addChild(musicOffButtonTitle)
	
	local soundsOnButton
	local soundsOnButtonTitle
	
	soundsOnButton ,soundsOnButtonTitle = menuButtonSheetSpriteWhitTitle(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("yes.png")),
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("yes.png")), menu, 2,3,
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("sounds.png"))
	)
	
	local soundsOffButton
	local soundsOffButtonTitle
	
	soundsOffButton,  soundsOffButtonTitle = menuButtonSheetSpriteWhitTitle(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("no.png")),
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("no.png")), menu, 2,3,
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("sounds.png"))
	)
	
	soundsOnButton:addEventListener("click", 
		function()
			menu:removeChild(soundsOnButton)
			menu:addChild(soundsOffButton)
			sounds.off()
		end
	)
	
	soundsOffButton:addEventListener("click", 
		function()
			menu:removeChild(soundsOffButton)
			menu:addChild(soundsOnButton)
			sounds.on()
		end
	)
	
	if sets.sounds then
		menu:addChild(soundsOnButton)
	else
		menu:addChild(soundsOffButton)
	end
	menu:addChild(soundsOffButtonTitle)
	
	local backButton = menuButtonSheetSprite(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png")),
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png")), menu, 3,3)
	menu:addChild(backButton)
	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("sceneHome", 1, transition, easing.outBack) 
		end
	)
	
	
end