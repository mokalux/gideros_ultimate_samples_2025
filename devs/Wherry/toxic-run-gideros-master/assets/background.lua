Background = Core.class(Sprite)
local treesTexturesCount = 2
local treesTextures = {}
for i=1,treesTexturesCount do
	treesTextures[i] = Texture.new("gfx/tree"..tostring(i)..".png")
end

function Background:init()
	self.layers = {}
end

function Background:addLayer(path, speed)
	local layer = {}
	layer.b1 = Bitmap.new(Texture.new(path))
	layer.b1:setScale(gameScale, gameScale)
	layer.b2 = Bitmap.new(Texture.new(path))
	layer.b2:setScale(gameScale, gameScale)
	layer.speed = speed
	
	self:addChild(layer.b1)
	self:addChild(layer.b2)
	layer.b2:setX(layer.b1:getWidth())
	table.insert(self.layers, layer)
end

function Background:addTree()
	self.tree = Bitmap.new(treesTextures[math.random(1,treesTexturesCount)])
	self.tree:setScale(gameScale, gameScale)
	self.tree:setX(screenWidth + self.tree:getWidth())
	self:addChild(self.tree)
end

function Background:move(dx)
	if self.tree then
		self.tree:setX(self.tree:getX() - dx * 0.9)
		if self.tree:getX() < -self.tree:getWidth() then
			self.tree:setX(screenWidth + self.tree:getWidth())
			self.tree:setTexture(treesTextures[math.random(1,treesTexturesCount)])
		end
	end
	for i, layer in ipairs(self.layers) do
		local x = layer.b1:getX() - dx * layer.speed
		layer.b1:setX(x)
		layer.b2:setX(x + layer.b1:getWidth())
		if layer.b1:getX() + layer.b1:getWidth() < 0 then
			layer.b1:setX(layer.b2:getX() + layer.b2:getWidth())
			
			local b1 = layer.b1
			layer.b1 = layer.b2
			layer.b2 = b1
		end
	end
end