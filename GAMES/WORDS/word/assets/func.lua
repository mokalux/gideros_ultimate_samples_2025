-- ==================================================================================================
-- CREATE SIMPLE BUTTON
-- ==================================================================================================
function newSimpleBtn(color1, color2, opaq, w, h, px, py)
	local btn = Pixel.new(color1, opaq, w, h)
	btn:setAnchorPoint(0.5, 0.5)
	btn:setPosition(px, py)
	btn.pressed = false
	btn.enable  = true
	
	btn:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if btn:hitTestPoint(event.touch.x, event.touch.y) and btn.enable then
			btn:setScale(0.95)
			btn:setColor(color2)
			btn.pressed = true
			btn:dispatchEvent(Event.new('onPress'))
			event:stopPropagation()
		end
	end)
	
	btn:addEventListener(Event.TOUCHES_END, function(event)
		if btn:hitTestPoint(event.touch.x, event.touch.y) and btn.pressed and btn.enable then
			btn:setScale(1)
			btn:setColor(color1)
			btn.pressed = false
			btn:dispatchEvent(Event.new('onRelease'))
			event:stopPropagation()
		end
	end)
	
	return btn
end

-- ==================================================================================================
-- CREATE BITMAP BUTTON
-- ==================================================================================================
function newBmpBtn(tx, px, py)
	local btn = Bitmap.new(tx)
	btn:setAnchorPoint(0.5, 0.5)
	btn:setPosition(px, py)
	btn.pressed = false
	btn.enable  = true
	
	btn:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if btn:hitTestPoint(event.touch.x, event.touch.y) and btn.enable then
			btn:setScale(0.95)
			btn.pressed = true
			btn:dispatchEvent(Event.new('onPress'))
			event:stopPropagation()
		end
	end)
	
	btn:addEventListener(Event.TOUCHES_END, function(event)
		if btn:hitTestPoint(event.touch.x, event.touch.y) and btn.pressed and btn.enable then
			btn:setScale(1)
			btn.pressed = false
			btn:dispatchEvent(Event.new('onRelease'))
			event:stopPropagation()
		end
	end)
	
	return btn
end

-- ==================================================================================================
-- SIMPLE SWITCH SCENE FUNCTION
-- ==================================================================================================
function switchScene(root, sceneId, sceneTable, fadeSprite)
	root:addChild(fadeSprite)
	
	for i = 1, #sceneTable do
		sceneTable[i]:setAlpha(0)
		sceneTable[i]:removeAllListeners()
		sceneTable[i]:removeFromParent()
	end
	
	root:addChild(sceneId)
	
	local function fadecd()
		Core.yield(0.5)
		fadeSprite:removeFromParent()
		fadeSprite = nil
		
		for i = 1, 10 do
			sceneId:setAlpha(i / 10)
			Core.yield(0.005)
		end
		
		sceneId:setAlpha(1)
	end
	
	Core.asyncCall(fadecd)
end


-- ==================================================================================================
-- FUNCTION TO GENERATE BITMAP ARRAY FROM ATLAS
-- ==================================================================================================
function newBmpArr(sheet, frameNo) -- only linear frames with uniform width
	local spriteSheet = Texture.new(sheet)
	local bmpArr = {}
	local w, h = spriteSheet:getWidth() / frameNo, spriteSheet:getHeight()
	
	local point = 0
	for i = 1, frameNo do
		bmpArr[i] = TextureRegion.new(spriteSheet, point, 0, w, h)
		point = point + w
	end
	
	return bmpArr
end
