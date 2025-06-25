local texture = Texture.new("gfx/boss/enemy_boss_ts.png", true, {transparentColor = 0xbfdcbf})

Enemy = Core.class(Sprite)

local cos, sin, random, pi = math.cos, math.sin, math.random, math.pi

function Enemy:init(game)
	self.game = game
	self.world = game.world
		
	local body = self.world:createBody{type = b2.DYNAMIC_BODY, position = {x = 160, y = 100}}
	local shape = b2.PolygonShape.new()
	shape:setAsBox(67/2, 54/2)
	body:createFixture({shape = shape, density = 1, filter = {categoryBits = 1, maskBits = 1}})
	
	self.body = body
	body.sprite = self
	
	self.type = 2 -- "enemy"

	local bitmap = Bitmap.new(TextureRegion.new(texture, 75, 113, 67, 54))
	bitmap:setAnchorPoint(0.5, 0.5)
	self:addChild(bitmap)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	self.attacks = {self.attack1, self.attack2, self.attack3}
end

function Enemy:onEnterFrame()
	self.angle = self.angle or 0
	self.body:setPosition(160 + 100 * sin(self.angle), 100 + 10 * cos(self.angle))
	self.angle = self.angle + 0.02

	self:setPosition(self.body:getPosition())

	if self.frame == nil then
		self.frame = 0
		self.attack = self.attacks[random(1, #self.attacks)]
	end
	
	self:attack()

	if self.frame ~= nil then self.frame = self.frame + 1 end
end

function Enemy:attack1()
	if self.frame < 70 and self.frame % 10 == 2 then
		local x,y = self:getPosition()
		for i=0,350,10 do
			self.game:addEnemyBullet(6, x, y, 5 * cos(i * pi / 180), 5 * sin(i * pi / 180))
		end
	end
	if self.frame == 100 then self.frame = nil end
end

function Enemy:attack2()
	if self.frame >= 0 and self.frame <= 180 then
		local x,y = self:getPosition()
		self.game:addEnemyBullet(6, x, y, 5 * cos(self.frame * pi / 22.5), 5 * sin(self.frame * pi / 22.5))
		self.game:addEnemyBullet(6, x, y, -5 * cos(self.frame * pi / 22.5), -5 * sin(self.frame  * pi / 22.5))
	end
	if self.frame == 300 then self.frame = nil end
end

local x1, y1, x2, y2 = 0, 0, 0, 0
local dx, dy, len = 0, 0, 0
function Enemy:attack3()
	x1, y1 = self:getPosition()
	x2, y2 = self.game:getPlayerPosition()
	if self.frame < 70 and self.frame % 10 == 5 then
		x1, y1 = self:getPosition()
		x2, y2 = self.game:getPlayerPosition()
		dx = x2 - x1
		dy = y2 - y1
		len = ((dx * dx) + (dy * dy)) ^ 0.5 -- math.sqrt(dx * dx + dy * dy)
		dx = (dx / len) * 15
		dy = (dy / len) * 15	
		self.game:addEnemyBullet(7, x1, y1, dx, dy)
	end
	if self.frame == 100 then self.frame = nil end
end
