Obstacle = Core.class(Sprite)

function Obstacle:init()
	local bPath = "gfx/obstacle_"..math.random(1,3)..".png"
	self.bitmap = Bitmap.new(Texture.new(bPath))
	self:addChild(self.bitmap)
	self:setScale(gameScale, gameScale)
end

function Obstacle:checkCollision(x, y)
	if	x >= self:getX() and x <= self:getX() + self:getWidth() and 
		y >= self:getY() and y <= self:getY() + self:getHeight()
	then
		return true
	end
	return false
end