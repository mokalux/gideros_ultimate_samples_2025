Enemie = Core.class(Sprite)

function Enemie:init()
	local bitmap = Bitmap.new(Texture.new("images/car.png"))
	self:addChild(bitmap)
end

function Enemie:update()
	self:setX(self:getX() + 10)
	if self:getX() >= 720 then
		self:kill()
	end
end

function Enemie:start()
	self:setX(0)
	self:setY(0)
end

function Enemie:kill()
	self.destroy = "enemies"
end
