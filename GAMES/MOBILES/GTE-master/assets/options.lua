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
]]--

options = gideros.class(Sprite)

function options:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/screen_bg.png"))
	self:addChild(screen)
	screen:setPosition((application:getContentWidth()-screen:getWidth())/2, (application:getContentHeight()-screen:getHeight())/2)
	
	local musicOnButton = Button.new(Bitmap.new(Texture.new("images/music_clicked.png")), Bitmap.new(Texture.new("images/music_normal.png")))
	musicOnButton:setPosition((application:getContentWidth()-musicOnButton:getWidth())/2, ((application:getContentHeight()*3/2-musicOnButton:getHeight())/2)-(musicOnButton:getHeight()+20))
	local musicOffButton = Button.new(Bitmap.new(Texture.new("images/music_normal.png")), Bitmap.new(Texture.new("images/music_clicked.png")))
	musicOffButton:setPosition((application:getContentWidth()-musicOnButton:getWidth())/2, ((application:getContentHeight()*3/2-musicOnButton:getHeight())/2)-(musicOnButton:getHeight()+20))
	
	musicOnButton:addEventListener("click", 
		function()
			self:removeChild(musicOnButton)
			music.off()
			self:addChild(musicOffButton)
		end
	)

	musicOffButton:addEventListener("click", 
		function()
			self:removeChild(musicOffButton)
			music.on()
			self:addChild(musicOnButton)
		end
	)
	
	if sets.music then
		self:addChild(musicOnButton)
	else
		self:addChild(musicOffButton)
	end
	
	local soundsOnButton = Button.new(Bitmap.new(Texture.new("images/sound_clicked.png")), Bitmap.new(Texture.new("images/sound_normal.png")))
	soundsOnButton:setPosition((application:getContentWidth()-soundsOnButton:getWidth())/2, ((application:getContentHeight()*3/2-soundsOnButton:getHeight())/2))
	local soundsOffButton = Button.new(Bitmap.new(Texture.new("images/sound_normal.png")), Bitmap.new(Texture.new("images/sound_clicked.png")))
	soundsOffButton:setPosition((application:getContentWidth()-soundsOnButton:getWidth())/2, ((application:getContentHeight()*3/2-soundsOnButton:getHeight())/2))
	
	soundsOnButton:addEventListener("click", 
		function()
			self:removeChild(soundsOnButton)
			self:addChild(soundsOffButton)
			sounds.off()
		end
	)
	
	soundsOffButton:addEventListener("click", 
		function()
			self:removeChild(soundsOffButton)
			self:addChild(soundsOnButton)
			sounds.on()
		end
	)
	
	if sets.sounds then
		self:addChild(soundsOnButton)
	else
		self:addChild(soundsOffButton)
	end
	
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_clicked.png")), Bitmap.new(Texture.new("images/back_normal.png")))
	backButton:setPosition((application:getContentWidth()-backButton:getWidth())/2, ((application:getContentHeight()*3/2-backButton:getHeight())/2)+(backButton:getHeight()+20))
	self:addChild(backButton)
	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, transition, easing.outBack) 
		end
	)
	
	
end