local random=math.random

GameScene = Core.class(Sprite)

function GameScene:init()
	-- bg
	application:setBackgroundColor(0x333333)
	-- cbump
	local bump = require "cbump"
	bumpWorld = bump.newWorld(32) -- global var
	-- camera (blobal!)
	camera = Camera.new(screenW, screenH) -- global var
	camera:addLayers("floor", "main", "bullets", "guns", "debug", "ui")
	camera:zoom(1.5)
	self:addChild(camera)
	-- tiny ecs
	--- Creates a new World.
	-- Can optionally add default Systems and Entities. Returns the new World along
	-- with default Entities and Systems.
	self.tworld = tiny.world(
		-- debug
		SDebugDraw.new(),
		-- displaying sprites
		SDrawable.new(),
		-- adding static bodies to the physics world
		SStaticPhysicsBodies.new(bumpWorld),
		-- player control system
		SPlayerControl.new(),
		-- nmes control system (AI?)
		SNmeControl.new(),
		-- main physics system (where we need all NON STATIC bodies)
		SBumpPhysics.new(bumpWorld),
		-- apply force to body 
		SMovement.new(),
		-- reloading and shooting system
		SGun.new(),
		-- calls update method of entity
		SUpdate.new()
	)
	_G.tworld = self.tworld
	-- actors
	local pl = EPlayer.new(100, 100)
	local nme1 = ENme.new(200, 200)
	self.tworld:addEntity(pl)
	self.tworld:addEntity(nme1)
	-- create level
	self:createLevel()
	-- listeners
	self:addEventListener(Event.KEY_UP, self.keyUp, self)
	self:addEventListener(Event.KEY_DOWN, self.keyDown, self)
	self:addEventListener(Event.MOUSE_DOWN, self.mouseDown, self)	
	self:addEventListener(Event.MOUSE_WHEEL, self.mouseWheel, self)
	self:addEventListener(Event.ENTER_FRAME, self.update, self)
	self:addEventListener(Event.APPLICATION_EXIT, self.appExit, self)
end

function GameScene:createLevel()
	local s = 32
	-- floor (no physics)
	local tex = Texture.new("gfx/floor.png", false, {wrap = Texture.REPEAT})
	local bg = Pixel.new(tex, screenW - s * 2, screenH - s * 2)
	bg:setPosition(s, s)
	camera:add("floor", bg)
	-- walls (physics)
	local l = EWall.new(0, 0, s, screenH)
	local r = EWall.new(screenW - s, 0, s, screenH)
	local t = EWall.new(0, 0, screenW, s)
	local b = EWall.new(0, screenH - s, screenW, s)
	self.tworld:addEntity(l)
	self.tworld:addEntity(r)
	self.tworld:addEntity(t)
	self.tworld:addEntity(b)
end

-- game loop
local dt
function GameScene:update(e)
	dt = e.deltaTime
	dt *= timeScale

	if (self.tworld) then
		self.tworld:update(dt)
	end
end

-- keyboard/mouse
function GameScene:keyDown(e)
	if (e.keyCode == KeyCode.Q) then
		local lr = camera:getLayer("debug")
		lr:setVisible(not lr:isVisible())
	end
	if (e.keyCode == KeyCode.S) then
		timeScale = 0.1
	end
end

function GameScene:keyUp(e)
	if (e.keyCode == KeyCode.S) then
		timeScale = 1
	end
end

function GameScene:mouseDown(e)
	local x, y = e.x, e.y
	x, y = camera:toWorld(x, y)
	
	if (e.button == 1) then
		local gun = EGun.new(x, y, choose("pistol", "auto", "falcon", "rpg", "test"))
		self.tworld:addEntity(gun)
	elseif (e.button == 2) then
		local ammo = EAmmo.new(x, y, math.random(10, 50))
		self.tworld:addEntity(ammo)
	end
end

function GameScene:mouseWheel(e)
	local step = 0.1
	if (e.wheel < 0) then
		camera:zoom(camera.scale - step)
	else
		camera:zoom(camera.scale + step)
	end
end

-- end
function GameScene:appExit(e)	
	local t = os.clock()
	print("*** Clearing app...")
	self.tworld:clearEntities()
	self.tworld:clearSystems()
	self.tworld:refresh()
	
	stage:removeEventListener(Event.ENTER_FRAME, self.update)
	stage:removeEventListener(Event.APPLICATION_EXIT, self.appExit)
	print(string.format("*** Done in %f s.", os.clock() - t))
end
