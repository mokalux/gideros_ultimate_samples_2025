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

startScene = Core.class(Sprite)

function startScene:init()
	local white = Bitmap.new(Texture.new("images/white.png", true))

	local red = Bitmap.new(Texture.new("images/red.png", true))
	local redButton = Button.new(red, white)
	redButton:setPosition(150, 200)
	redButton:addEventListener("click", function()
		ach:complete("red10")
		ach:complete("red50")
		ach:complete("red100")
		ach:complete("allbuttons", "red")
	end)
	self:addChild(redButton)
	
	local yellow = Bitmap.new(Texture.new("images/yellow.png", true))
	local yellowButton = Button.new(yellow, white)
	yellowButton:setPosition(150, 300)
	yellowButton:addEventListener("click", function()
		ach:complete("yellow10")
		ach:complete("yellow50")
		ach:complete("yellow100")
		ach:complete("allbuttons", "yellow")
	end)
	self:addChild(yellowButton)
	
	local blue = Bitmap.new(Texture.new("images/blue.png", true))
	local blueButton = Button.new(blue, white)
	blueButton:setPosition(450, 300)
	blueButton:addEventListener("click", function()
		ach:complete("blue10")
		ach:complete("blue50")
		ach:complete("blue100")
		ach:complete("allbuttons", "blue")
	end)
	self:addChild(blueButton)
	
	local green = Bitmap.new(Texture.new("images/green.png", true))
	local greenButton = Button.new(green, white)
	greenButton:setPosition(450, 200)
	greenButton:addEventListener("click", function()
		ach:complete("green10")
		ach:complete("green50")
		ach:complete("green100")
		ach:complete("allbuttons", "green")
	end)
	self:addChild(greenButton)

	local achiev = Bitmap.new(Texture.new("images/achievements.png", true))
	local achievButton = Button.new(achiev, achiev)
	achievButton:setPosition(17, 14)
	self:addChild(achievButton)

	achievButton:addEventListener("click", function()
		ach:complete("allbuttons", "ach")
		sceneManager:changeScene("achievementsScene", 1, SceneManager.fade, nil) 
	end)

	self:addEventListener(Event.KEY_DOWN, function(event)
		if event.keyCode == KeyCode.BACK then
			application:exit()
		end
	end)
end
