--[[
Obstacle Class
@Author : Rere
]]

Obstacle = gideros.class(Sprite)

function Obstacle:init(texture)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	local body = world:createBody{type = b2.STATIC_BODY}
	local x, y = self:getPosition()
	
	body:setPosition(x,y)
	body.object = self
	body.type = "Obstacle."..texture
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(bitmap:getWidth() / 2, bitmap:getHeight() / 2,x,y,0)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.0, restitution = 0.2}
	
	self.body = body
	self:addChild(bitmap)
	self:setPosition(200,200)
end

function Obstacle:setParameter(direction, speed)
	self.speed = speed
	self:setRotation(direction)
	--self.body:setRotation(direction)
end

function Obstacle:update()
	self.body:setPosition(self:getPosition())
	self:setY(self:getY() + self.speed)
end

function Obstacle:reset()
	--self:setAlpha(0)
	self:setPosition(-200,-200)
	self.body:setPosition(self:getPosition())
end
