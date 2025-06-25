monitorMemoryUtility = gideros.class(Sprite)


function monitorMemoryUtility:init()
	self.memory =0
	self.memoryTemp=0
	
	self.info = TextField.new(nil, ">>Memory: "..self.memory)
	self.info:setTextColor(0x000000)
	self.info:setPosition(0, 100)
	self.info:setScale(5)
	--self:addChild(self.info)	
	
	_MONITORMEMORYUTILITYSELF = self
	self:addEventListener(Event.ENTER_FRAME, self.monitorMemory, self)
	
	--self:testMemoryFromSinglePng()
	--self:testMemorySpriteSheet()
	
end


function monitorMemoryUtility:monitorMemory(event)
    gc()
	_MONITORMEMORYUTILITYSELF.memory=collectgarbage("count")
	if(_MONITORMEMORYUTILITYSELF.memory~=_MONITORMEMORYUTILITYSELF.memoryTemp)then
		_MONITORMEMORYUTILITYSELF.memoryTemp=_MONITORMEMORYUTILITYSELF.memory
		_MONITORMEMORYUTILITYSELF.info:setText(">>Memory: "..round((application:getTextureMemoryUsage()+_MONITORMEMORYUTILITYSELF.memoryTemp)/1024).." MB")
		print( "\nMemUsage: " .. _MONITORMEMORYUTILITYSELF.memoryTemp.." + "..application:getTextureMemoryUsage().." = "..round((application:getTextureMemoryUsage()+_MONITORMEMORYUTILITYSELF.memoryTemp)/1024).." MB" )
	end    
end

function monitorMemoryUtility:testMemorySpriteSheet()
	--[[local _SHEETMAIN	= TexturePack.new("images/texturePackerExample.txt", "images/texturePackerExample.png")
	--TEST
	for i=1, 100 do
		local item = Bitmap.new(_SHEETMAIN:getTextureRegion("tux_dredd.png"))
		item:setPosition(500,500)
		self:addChild(item)
	end

	]]
end

function monitorMemoryUtility:testMemoryFromSinglePng()
	--[[
	--TEST
	for i=1, 100 do
		local item = Bitmap.new(Texture.new("originalArt/tux_dredd.png"))
		item:setPosition(500,500)
		self:addChild(item)
	end

	]]
end

function monitorMemoryUtility:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.monitorMemory, self)
end