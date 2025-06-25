--!NEEDS:classes/Ace.Slide.lua

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

scenePackSelect = gideros.class(Sprite)

function scenePackSelect:init()
	print("scenePackSelect")
	_SCENEPACKSELECT=self
	_SHEETPACKSELECT= TexturePack.new("images/packSelect.txt", "images/packSelect.png")
	local background = Bitmap.new(_SHEETPACKSELECT:getTextureRegion("packselectBackground.png"))
	background:setPosition(0,0)
	self:addChild(background)
	
	local title = Bitmap.new(_SHEETBUTTONS:getTextureRegion("stageSelect.png"))
	title:setAnchorPoint(0.5,0.5)
	title:setPosition(
		(application:getLogicalHeight())/2, 
		(title:getHeight()/2)
	)
	self:addChild(title)

	--unlocked packs
	local unPacks = dataSaver.loadValue("unPacks")
	if(not unPacks) then
		unPacks = {}
	end
	--initialize AceSlide
	AceSlide.init({parent = self})
	--loop through packs
	for i, value in ipairs(packs.packs) do
		--create group
		local group = Sprite.new()
		
		--get pack picture
		local box
		--if first pack or unlocked pack
		if unPacks[i] or i == 1 then
			box = Button.new(
				Bitmap.new(_SHEETPACKSELECT:getTextureRegion("worldUnlocked.png")), 
				Bitmap.new(_SHEETPACKSELECT:getTextureRegion("worldUnlocked.png"))
			)
			--pack number
			box.cnt = i
			--add event listener
			box:addEventListener("click", function(e)
				--get target of event
				local target = e.__target
				print(target.cnt)
				--get selected pack
				sets.curPack = target.cnt
				--save selected pack
				dataSaver.saveValue("sets", sets)
				--stop propagation
				e:stopPropagation()
				--go to level select of current pack
				sceneManager:changeScene("sceneLevelSelect", 1, transition, easing.outBack)
			end)
		else
			box = Button.new(
				Bitmap.new(_SHEETPACKSELECT:getTextureRegion("worldLocked.png")), 
				Bitmap.new(_SHEETPACKSELECT:getTextureRegion("worldLocked.png"))
			)
		end
		
		--scaling just for example to look better
		--box.upState:setScaleX(3)
		--box.upState:setScaleY(3)
		--box.downState:setScaleX(3)
		--box.downState:setScaleY(3)
		
		group:addChild(box)
		
		--add pack name
		local packName = TextField.new(nil, value.name)
		packName:setPosition(0,20)
		packName:setTextColor(0xffffff)
		group:addChild(packName)
		
		--add level count
		local levelCnt = TextField.new(nil, value.levels.." levels")
		levelCnt:setPosition(0,40)
		levelCnt:setTextColor(0xffffff)
		group:addChild(levelCnt)
		if sets.curPack == i then
			AceSlide.add(group, true)
		else
			AceSlide.add(group)
		end
	end
	--show Ace slide
	AceSlide.show()
	
	--Select pack also with arrow buttons
	--just delete this if you don't need it
	
	local leftButton = Button.new(
		Bitmap.new(_SHEETPACKSELECT:getTextureRegion("left.png")), 
		Bitmap.new(_SHEETPACKSELECT:getTextureRegion("left.png"))
	)
	leftButton:setPosition(leftButton:getWidth()*0.25, (application:getContentHeight()/2)-(leftButton:getHeight()/2))
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			AceSlide.prevItem()
		end
	)
	
	local rightButton = Button.new(
		Bitmap.new(_SHEETPACKSELECT:getTextureRegion("right.png")), 
		Bitmap.new(_SHEETPACKSELECT:getTextureRegion("right.png"))
	)
	rightButton:setPosition((application:getContentWidth()-rightButton:getWidth()*1.25), (application:getContentHeight()/2)-(rightButton:getHeight()/2))
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			AceSlide.nextItem()
		end
	)
	
	
	--back button
	local backButton = Button.new(
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png")), 
		Bitmap.new(_SHEETBUTTONS:getTextureRegion("back.png"))
	)
	backButton:setPosition((application:getContentWidth()-backButton:getWidth())/2, application:getContentHeight()-backButton:getHeight()-10)
	self:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("sceneHome", 1, transition, easing.outBack) 
		end
	)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	_SHEETPACKSELECT=nil
	gc()
end

function scenePackSelect:onExitBegin()

	local i=_SCENEPACKSELECT:getNumChildren()
	while i>0 do		
		local sprite = _SCENEPACKSELECT:getChildAt(i)
		_SCENEPACKSELECT:removeChild(sprite)
		sprite=nil
		i=i-1
	end
	
	_SCENEPACKSELECT:removeEventListener("exitBegin", _SCENEPACKSELECT.onExitBegin, _SCENEPACKSELECT)
	_SCENEPACKSELECT=nil
	gc()
end