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
pack_select = gideros.class(Sprite)

function pack_select:init()
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
			box = Button.new(Bitmap.new(Texture.new("images/crate.png")), Bitmap.new(Texture.new("images/crate.png")))
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
				sceneManager:changeScene("level_select", 1, transition, easing.outBack)
			end)
		else
			box = Button.new(Bitmap.new(Texture.new("images/crate_locked.png")), Bitmap.new(Texture.new("images/crate_locked.png")))
		end
		
		--scaling just for example to look better
		box.upState:setScaleX(3)
		box.upState:setScaleY(3)
		box.downState:setScaleX(3)
		box.downState:setScaleY(3)
		
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
	
	local leftButton = Button.new(Bitmap.new(Texture.new("images/left-up.png")), Bitmap.new(Texture.new("images/left-down.png")))
	leftButton:setPosition((application:getContentWidth()-leftButton:getWidth())/4, (application:getContentHeight()/2)-(leftButton:getHeight()/2))
	self:addChild(leftButton)
	leftButton:addEventListener("click", 
		function()	
			AceSlide.prevItem()
		end
	)
	
	local rightButton = Button.new(Bitmap.new(Texture.new("images/right-up.png")), Bitmap.new(Texture.new("images/right-down.png")))
	rightButton:setPosition(((application:getContentWidth()-rightButton:getWidth())/4)*3, (application:getContentHeight()/2)-(rightButton:getHeight()/2))
	self:addChild(rightButton)
	rightButton:addEventListener("click", 
		function()	
			AceSlide.nextItem()
		end
	)
	
	
	--back button
	local backButton = Button.new(Bitmap.new(Texture.new("images/back_up.png")), Bitmap.new(Texture.new("images/back_down.png")))
	backButton:setPosition((application:getContentWidth()-backButton:getWidth())/2, application:getContentHeight()-backButton:getHeight()-10)
	self:addChild(backButton)

	backButton:addEventListener("click", 
		function()	
			sceneManager:changeScene("start", 1, transition, easing.outBack) 
		end
	)

end