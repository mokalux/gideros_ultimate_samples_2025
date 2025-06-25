EndlessBackground2D = Core.class(Sprite)

function modulo(a,b)
	-- revisited! u can use math.fmod if you want
	return a - math.floor(a/b)*b
end

function createTextBackGround()
	local sprite = Sprite.new()
	local dummy = TextField.new(nil,"12","1234567890")
	sprite:addChild(dummy)
	dummy:setAlpha(0)
	for i = 0, 9 do
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

function EndlessBackground2D:init(width,height,scaleFactor)
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
	
	-- width here is not necessary I know
	-- e:setScale(width/self:getWidth(), (height/self:getHeight())
	self:setScale(height/self:getHeight(), height/self:getHeight())
end

function EndlessBackground2D:moveBy(x,y)
--[[
	-- here is we just taking account also the forward directions,however, since in this sample we worked for 
	   global space adding to another container or any transformation can broke the system. 
	   We will handle this problem in approach 4
]]
	local halfWidth = self:getWidth()*0.5
	local halfHeight = self:getHeight()*0.5
	if( x > 0) then
		if(self:getX() + x  > 0) then
			self:setX(self:getX() - halfWidth)
		end
	elseif( x < 0) then
		if(self:getX() + x < -halfWidth) then
			self:setX(self:getX() + halfWidth)
		end
	end

	if( y > 0) then
		if(self:getY() + y  > 0) then
			self:setY(self:getY() - halfHeight)
		end
	elseif( x < 0) then
		if(self:getY() + y < -halfHeight) then
			self:setY(self:getY() + halfHeight)
		end
	end

	self:setPosition(self:getX() + x,self:getY() + y)
end
