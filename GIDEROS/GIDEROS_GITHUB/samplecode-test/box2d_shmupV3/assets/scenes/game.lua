require "box2d"

Game = Core.class(Sprite)

local random = math.random

function Game:init()
	self.world = b2.World.new(0, 0)
	self.player = Player.new(self)
	self.enemy = Enemy.new(self)
	self.playerBullets = BulletLayer.new(self)
	self.enemyBullets = BulletLayer.new(self)
	self.explosionLayer = ExplosionLayer.new()
	-- order
	self:addChild(self.player)
	self:addChild(self.enemy)
	self:addChild(self.playerBullets)
	self:addChild(self.enemyBullets)
	self:addChild(self.explosionLayer)
	-- event listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	-- let's go!
	self.toBeRemoved = {}
	-- debug draw
	local debugDraw = b2.DebugDraw.new()
--	self:addChild(debugDraw)
--	self.world:setDebugDraw(debugDraw)
end

function Game:addPlayerBullet(id, x, y, dx, dy)
	self.playerBullets:addBullet(id, x, y, dx, dy, 8, 1, 1) -- "playerBullet"
end

function Game:addEnemyBullet(id, x, y, dx, dy)
	self.enemyBullets:addBullet(id, x, y, dx, dy, 16, 2, 2) -- "enemyBullet"
end

function Game:getPlayerPosition()
	return self.player:getPosition()
end

function Game:onEnterFrame()
	for i=#self.toBeRemoved, 1, -1 do
		local sprite = self.toBeRemoved[i]
		if sprite.type == 1 then -- "playerBullet"
			self.playerBullets:removeBullet(sprite)
		elseif sprite.type == 2 then -- "enemyBullet"
			self.enemyBullets:removeBullet(sprite)
		end
		self.toBeRemoved[i] = nil
	end
	-- box2d
	self.world:step(1/60, 3, 6)
end

local x, y, rand = 0, 0, 0
function Game:onBeginContact(event)
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	local spriteA = bodyA.sprite
	local spriteB = bodyB.sprite

	local bullet
	if spriteA.type == 8 or spriteA.type == 16 then bullet = spriteA -- "playerBullet", "enemyBullet"
	elseif spriteB.type == 8 or spriteB.type == 16 then bullet = spriteB -- "playerBullet", "enemyBullet"
	end
	if bullet ~= nil then
		self.toBeRemoved[#self.toBeRemoved + 1] = bullet
		x, y = bullet.x, bullet.y
		rand = random(0, 10) - 5
		self.explosionLayer:addExplosion(x + rand, y + rand)
		soundManager:play("hit")
	end
end
