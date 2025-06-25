--!NEEDS:utils.lua

Ground = Core.class(Sprite)

local groundTypes = {
	{0, -33, 246, 31},
	{-4, -1, 115, 31},
	{-4, -1, 56, 24},
	{-4, -1, 56, 59},
	{-4, -13, 153, 31},
	{-4, -13, 153, 31}
}

function Ground:init(groundType)
	if not groundType then
		groundType = 2
	end
	local bPath = "gfx/ground_"..groundType..".png"
	if groundType == 2 then
		bPath = "gfx/ground_2_" .. math.random(1,3)..".png" 
	elseif groundType == 3 then
		bPath = "gfx/ground_3_" .. math.random(1,2)..".png" 
	elseif groundType == 4 then
		bPath = "gfx/ground_4_" .. math.random(1,2) .. ".png"
	end
	self.bitmap = Bitmap.new(Texture.new(bPath))
	self:addChild(self.bitmap)
	self.bitmap:setPosition(groundTypes[groundType][1], groundTypes[groundType][2])
	self.width = groundTypes[groundType][3] * gameScale
	self.height = groundTypes[groundType][4] * gameScale
	self:setScale(gameScale, gameScale)
end

function Ground:checkCollision(x, y)
	if	x >= self:getX() and x <= self:getX() + self.width and 
		y >= self:getY() and y <= self:getY() + self.height 
	then
		return true
	end
	return false
end