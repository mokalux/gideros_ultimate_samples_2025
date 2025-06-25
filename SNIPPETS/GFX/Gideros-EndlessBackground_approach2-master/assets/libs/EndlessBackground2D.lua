EndlessBackground2D = Core.class(Sprite)


--[[
	
	-- Endless background2d follows same approach as version 1
	-- I do not offer a complete component. Instead, I am showing some aspects which may be useful in some ways

]]


function modulo(a,b)

	-- revisited! u can use math.fmod if you want
	return a - math.floor(a/b)*b

end

function createTextBackGround()
	
	
	
	local sprite = Sprite.new()
	
	local dummy = TextField.new(nil,"12","1234567890")
	sprite:addChild(dummy)
	
	dummy:setAlpha(0)

	for i=0,9 do
		
		local str = ""
		
		
		for j=0,9 do
		
			
			str = str .." " .. modulo((i +j),10)
			
		end
		
		--TTFont.new(font,fontSize)
		local textField = TextField.new(nil,str,"1234567890")
		
		textField:setY(textField:getHeight()*(i+0.5)*2)
		
		sprite:addChild(textField)
		
	end
	
	
	
	return sprite
	
end


function EndlessBackground2D:init()


	local px = 1.0
	local py = 1.0
	
	local c1 = createTextBackGround()
	local c2 = createTextBackGround()
	local c3 = createTextBackGround()
	local c4 = createTextBackGround()

	c2:setX(c1:getWidth()*px)
	c3:setY(c1:getHeight()*py)
	c4:setPosition(c2:getX(),c3:getY())
	
	
	
	self:addChild(c1)
	self:addChild(c2)
	self:addChild(c3)
	self:addChild(c4)
	



end

function EndlessBackground2D:moveBy(x,y)
	
	--[[
			** SIMPLEST APPROACH
			
			-- if pictures midpoint passed its parent sprite position, just reposition by its halfwidth. 
			   Since Two half of the picture is identicals creates an illusion which image will be 
			   scrolling forever. 
			-- One final side note! Images are not necesserily be identical. Two different images but seamless 
			   with each other creates same effect. 
			
	]]
		local midX = self:getX() + self:getWidth()/2 - x
		
		
		if(midX < 0) then
			self:setX(self:getX() + self:getWidth()/2)
		end
		
		self:setX(self:getX() - x)
		
		local midY = self:getY() + self:getHeight()/2 - y
		
		
		if(midY < 0) then
			self:setY(self:getY() + self:getHeight()/2)
		end
		
		self:setY(self:getY() - y)
		
	



end