Coin = Core.class(Sprite)

function Coin:init()
	self.sprite = AnimatedSprite.new(Texture.new("gfx/coin.png"), 7, 7)
	self:addChild(self.sprite)
	self:setScale(gameScale, gameScale)
end

function Coin:checkCollision(x, y, w, h)
	local cx = self:getX() + self:getWidth() / 2
	local cy = self:getY() + self:getHeight() / 2
	
	if	cx >= x and cx <= x + w and 
		cy >= y and cy <= y + h
	then
		return true
	end
	return false
end

function Coin:update(e)
	self.sprite:update(e.deltaTime)
end