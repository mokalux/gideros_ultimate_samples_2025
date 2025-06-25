--!NEEDS:utils.lua

Player = Core.class(Sprite)
local jumpSound = Sound.new("sounds/jump.wav")
function Player:init()
	self.states = {}
	self.states["run"] = AnimatedSprite.new(Texture.new("gfx/player_run.png"), 16, 23)
	self.states["jump"] = Bitmap.new(Texture.new("gfx/player_jump.png"))
	self.states["dead"] = Bitmap.new(Texture.new("gfx/player_dead.png"))
	self.states["jet"] = Bitmap.new(Texture.new("gfx/player_jetpack.png"))
	for k,v in pairs(self.states) do
		v:setX(-3)
	end
	self.currentState  = "run"
	self:addChild(self.states["run"])
	--self:addChild(Bitmap.new(Texture.new("gfx/player.png")))
	self.sx = 0
	self.sy = 0
	self.px = 0
	self.py = 0
	
	self.width = 8 * gameScale
	
	self.isJumping = false
	
	self.onGround = false
	self:setScale(gameScale, gameScale)
	
end

function Player:setState(state)
	if state == self.currentState then
		return
	end
	for k,v in pairs(self.states) do
		v:removeFromParent()
	end
	self:addChild(self.states[state])
	self.currentState = state
end

function Player:update(e)
	if self.isJumping then
		self:jump()
		self.isJumping = false
		self.py = self.py - gameScale
	end
	self:setPosition(self.px, self.py)
	if self.currentState == "run" then
		self.states["run"]:update(e.deltaTime)
	end
end

function Player:jump()
	if self.currentState == "jet" then
		self.sy = -200 * gameScale
		return
	end
	if self.onGround ~= true then
		return
	end
	self.sy = -400 * gameScale
	self:setState("jump")
	self.onGround = false
	jumpSound:play()
end