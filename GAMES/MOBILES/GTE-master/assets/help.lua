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

help = gideros.class(Sprite)

function help:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/screen_bg.png"))
	self:addChild(screen)
	screen:setPosition((application:getContentWidth()-screen:getWidth())/2, (application:getContentHeight()-screen:getHeight())/2)
	
	local myfont = TTFont.new("asset/pricedown bl.ttf", 80)
	local text = TextField.new(myfont, "DEF : " .. NICK_DEFENCE)
	text:setTextColor(0x000000)
	text:setPosition((application:getContentWidth()-text:getWidth())/3, ((application:getContentHeight()*3/2-text:getHeight())/2)-(text:getHeight()+10))
	self:addChild(text)
	myfont = TTFont.new("asset/pricedown bl.ttf", 75)
	text = TextField.new(myfont, "DEF : " .. NICK_DEFENCE)
	text:setTextColor(0xffffff)
	text:setPosition((application:getContentWidth()-text:getWidth())/3, ((application:getContentHeight()*3/2-text:getHeight())/2)-(text:getHeight()+10))	
	self:addChild(text)
	
	local myfont = TTFont.new("asset/pricedown bl.ttf", 80)
	local text = TextField.new(myfont, "HP : " .. NICK_MAXHEALTH)
	text:setTextColor(0x000000)
	text:setPosition((application:getContentWidth()-text:getWidth())/3, ((application:getContentHeight()*3/2-text:getHeight())/2)+(text:getHeight()+10))
	self:addChild(text)
	myfont = TTFont.new("asset/pricedown bl.ttf", 75)
	text = TextField.new(myfont, "HP : " .. NICK_MAXHEALTH)
	text:setTextColor(0xffffff)
	text:setPosition((application:getContentWidth()-text:getWidth())/3, ((application:getContentHeight()*3/2-text:getHeight())/2)+(text:getHeight()+10))	
	self:addChild(text)
	
	local bitmapClicked = Bitmap.new(Texture.new("images/plus_clicked.png"))
	bitmapClicked:setScale(0.4,0.4)
	local bitmapNormal = Bitmap.new(Texture.new("images/plus_normal.png"))
	bitmapNormal:setScale(0.2,0.2)
	local plusDef = Button.new(bitmapClicked, bitmapNormal )
	plusDef:setPosition((application:getContentWidth()-text:getWidth())-25, ((application:getContentHeight()*3/2-text:getHeight())/2)-(text:getHeight()-20))
	self:addChild(plusDef)
	
	plusDef:addEventListener("click", 
		function()
				NICK_DEFENCE = NICK_DEFENCE + 1
		end
	)
	
	
	local bitmapClicked = Bitmap.new(Texture.new("images/plus_clicked.png"))
	bitmapClicked:setScale(0.4,0.4)
	local bitmapNormal = Bitmap.new(Texture.new("images/plus_normal.png"))
	bitmapNormal:setScale(0.2,0.2)
	local plusHP = Button.new(bitmapClicked, bitmapNormal)
	plusHP:setPosition((application:getContentWidth()-text:getWidth()-25), ((application:getContentHeight()*3/2-text:getHeight())/2)-(text:getHeight()+80))
	self:addChild(plusHP)
	
	plusHP:addEventListener("click", 
		function()
			NICK_MAXHEALTH = NICK_MAXHEALTH + 1
		end
	)
	
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_clicked.png")), Bitmap.new(Texture.new("images/back_normal.png")))
	backButton:setPosition((application:getContentWidth()-backButton:getWidth())/2, ((application:getContentHeight()*3/2-backButton:getHeight())/2)+(backButton:getHeight()+20))
	self:addChild(backButton)
	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, transition, easing.outBack) 
		end
	)
	
end