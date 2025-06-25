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

sceneLevelLoader = gideros.class(Sprite)



function sceneLevelLoader:startGame()
	--game started
	startGame = false
	--do your game logic and stuff

end

function sceneLevelLoader:init()
	print("sceneLevelLoader:")
	local _SHEETLEVELLOADER= TexturePack.new("images/levelcommons.txt", "images/levelcommons.png")
	local background = Bitmap.new(_SHEETLEVELLOADER:getTextureRegion("level1.png"))
	background:setPosition(0,0)
	self:addChild(background)
	--load scores
	local highScore = dataSaver.loadValue("scores")
	--if not exist yet
	if(not highScore) then
		highScore = {}
	end
	--score for this levela
	if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
		highScore[(sets.curPack).."-"..sets.curLevel] = {}
		highScore[(sets.curPack).."-"..sets.curLevel].score = 0
	end
	currentScore = 0
	--save score function
	local saveScore = function()
		if(currentScore > highScore[(sets.curPack).."-"..sets.curLevel].score) then
			highScore[(sets.curPack).."-"..sets.curLevel].score = currentScore
		end
		--increase level
		sets.curLevel = sets.curLevel + 1
		
		--if level does not exist in pack
		if(packs.packs[sets.curPack].levels < sets.curLevel) then
			--level one
			sets.curLevel = 1
			--increase pack
			sets.curPack = sets.curPack + 1
			--if pack exists
			if(packs.packs[sets.curPack]) then
				--unlock pack
				local unPacks = dataSaver.loadValue("unPacks")
				if(not unPacks) then
					unPacks = {}
				end
				unPacks[sets.curPack] = true
				dataSaver.saveValue("unPacks", unPacks)
			else
				--if doesn't exist, go back
				sets.curPack = sets.curPack - 1
			end
			--unlock next level
			if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
				highScore[(sets.curPack).."-"..sets.curLevel] = {}
				highScore[(sets.curPack).."-"..sets.curLevel].score = 0
				highScore[(sets.curPack).."-"..sets.curLevel].unlocked = true
			end
			--save high score
			dataSaver.saveValue("scores", highScore)
			ret = "pack_select"
		else
			--unlock next level
			if(not highScore[(sets.curPack).."-"..sets.curLevel]) then
				highScore[(sets.curPack).."-"..sets.curLevel] = {}
				highScore[(sets.curPack).."-"..sets.curLevel].score = 0
				highScore[(sets.curPack).."-"..sets.curLevel].unlocked = true
			end
			--save high score
			dataSaver.saveValue("scores", highScore)
			ret = "level"
		end
		--save setting
		dataSaver.saveValue("sets", sets)
		--return to scene
		return ret
	end
	--self reference
	--fore easy access out of scope
	levelSelf = self
	--allow to start game
	startGame = true
	--is game paused
	pauseGame = false
	
	

	
	local lastLeft = 10

	
	--back to menu button
	menuBtn = Button.new(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("pauseDraw.png")), 
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("pauseDraw.png"))
	)
	menuBtn:setPosition(lastLeft, 10)
	self:addChild(menuBtn)
	menuBtn:addEventListener("click", 
		function()	
			if not startGame then
				pauseGame = true
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
				levelSelf:addChild(menu)
				
				--close menu button
				local backButton = menuButtonSheetSprite(
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png")),
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png")), menu, 1,5)
				menu:addChild(backButton)
				backButton:addEventListener("click", 
					function()	
						pauseGame = false
						levelSelf:removeChild(menu)
					end
				)
				
				--reset level button
				local restartButton = menuButtonSheetSprite(
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("restart.png")),
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("restart.png")), menu, 2,5)
				menu:addChild(restartButton)
				restartButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("sceneLevelLoader", 1, transition, easing.outBack)
					end
				)
				
				--select pack button
				local packButton = menuButtonSheetSprite(
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("stageSelect.png")),
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("stageSelect.png")), menu, 3,5)
				menu:addChild(packButton)
				packButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("scenePackSelect", 1, transition, easing.outBack)
					end
				)
				
				--select level of current pack button
				local levelButton = menuButtonSheetSprite(
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("levelSelect.png")),
					Bitmap.new(_SHEETBUTTONS:getTextureRegion("levelSelect.png")), menu, 4,5)
				menu:addChild(levelButton)
				levelButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("sceneLevelSelect", 1, transition, easing.outBack)
					end
				)
				
				--[[go to start menu
				local menuButton = menuButton("images/menu_up.png","images/menu_down.png", menu, 5,5)
				menu:addChild(menuButton)
				menuButton:addEventListener("click", 
					function()	
						sceneManager:changeScene("start", 1, transition, easing.outBack)
					end
				)]]
			end
		end
	)
	lastLeft = lastLeft + menuBtn:getWidth() + 45
	

	
	--display highscore
	local highscore = TextField.new(nil, "Highscore: "..highScore[(sets.curPack).."-"..sets.curLevel].score)
	highscore:setPosition(10,application:getContentHeight()-30)
	highscore:setTextColor(0x000000)
	self:addChild(highscore)
	
	--display current score
	self.score = TextField.new(nil, "Score: 0")
	self.score:setPosition(10,application:getContentHeight()-20)
	self.score:setTextColor(0x000000)
	self:addChild(self.score)
	

	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame)
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
	
	self:startGame()
end

--removing event
function sceneLevelLoader:onEnterFrame() 
	if not startGame and not pauseGame then
		
	end
end

--removing event on exiting scene
function sceneLevelLoader:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

