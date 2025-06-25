--
-- TNT Virtual Pad for Gideros Mobile SDK
-- Example 2
--
-- Copyright (C) 2012 By Gianluca D'Angelo
--
--[[
local function is32bit()
	return string.dump(is32bit):byte(9) == 4
end

if is32bit() then
	require("tntvpad32")
	require("tntanimator32")
else
	require("tntvpad64")
	require("tntanimator64")
end
]]
require "tntvirtualpad"
require("libs/tntanimator")
require "box2d"

-- Box2d config
b2.setScale(20)

-- this table holds the dynamic bodies and their sprites
local actors = {}

-- create world
local world = b2.World.new(0, 9.8, true)


--we load the PhysicsData containing all PhysicsEditor's information for our bodies,
--obviously exported with "Gideros" exporter.

local scaleFactor = 1.0
local physics = (loadfile "scene.lua")().physicsData(scaleFactor)

-- Setup App
application:setKeepAwake(true)
application:setBackgroundColor(0x000000)

-- load background  box2d
local floorBody = world:createBody{type = b2.STATIC_BODY}
floorBody.name = "sfondo3"
floorBody:setPosition(0,320)
physics:addFixture(floorBody, "sfondo3")
-- create floor sprite and add it to stage
local floor = Bitmap.new(Texture.new("gfx/sfondo3.png"))
floor:setAnchorPoint(physics:getAnchorPoint("sfondo3"))
floor:setY(320)
stage:addChild(floor)

-- setup player
local archer = CLASS_archer.new(world, physics)
stage:addChild(archer)

-- setup Virutal Pad
local texturevpad = TexturePack.new("gfx/example2_gfx.txt", "gfx/example2_gfx.png", true)
--local vPad = CTNTVirtualPad.new(stage, "example2_gfx", PAD.STICK_SINGLE, PAD.BUTTONS_ONE, 20, 3)
local vPad = CTNTVirtualPad.new(stage, texturevpad, PAD.STICK_SINGLE, PAD.BUTTONS_ONE, 20, 3)
--vPad:setJoyStyle(PAD.COMPO_LEFTPAD, PAD.STYLE_FOLLOW)
vPad:setJoyStyle(PAD.COMPO_LEFTPAD, PAD.STYLE_CLASSIC)
--vPad:setScale(PAD.COMPO_LEFTPAD, 1)
vPad:setScale(PAD.COMPO_LEFTPAD, 1)
--vPad:setScale(PAD.COMPO_BUTTON1, 1)
vPad:setPosition(PAD.COMPO_LEFTPAD, 80, 220)
vPad:setMaxRadius(PAD.COMPO_LEFTPAD, 40)
--vPad:setHideDelay(5000)
vPad:start()

destroy = false
dont_shot = false

-- **************** CALLBACK FUNCTION **************** 

-- PAD EVENTS FUNCTION

local function leftJoy(e)
	if e.data.power > 0.2 then
		dont_shot = true
		archer:move(e.data.angle, (e.data.power*170)*e.data.deltaTime)
	else
		archer:stop(e.data.angle)
	end
end

local function jump(e)
	if e.data.state == PAD.STATE_BEGIN then
		dont_shot = true
		archer:jump(archer.angle)
	end
end

-- STAGE EVENTS FUNCTION

local function fire(e)
	if dont_shot == false and archer.shooting == false and archer.nbArrow > 0 then
		archer.nbArrow = archer.nbArrow - 1
		local xA, yA = archer:getPosition()
		local xB = 360
		local yB = yA
		local xC = e.x
		local yC = e.y

		a = math.sqrt( (xC - xB)*(xC - xB) + (yC - yB)*(yC - yB) )
		b = math.sqrt( (xA - xC)*(xA - xC) + (yA - yC)*(yA - yC) )
		c = math.sqrt( (xA - xB)*(xA - xB) + (yA - yB)*(yA - yB) )
		
		local cosA = ( b*b + c*c - a*a)/(2*b*c)
		local angle = math.acos(cosA)
		
		local orientation = "right"
		
		if math.cos(angle) < 0 then
			orientation = "left"
		end
		
		archer:shoot(orientation)
		
		Timer.delayedCall(330, function() 
			local fire = CLASS_fire.new(xA, yA, angle, e.x, e.y, world, physics)
			stage:addChild(fire)
			Timer.delayedCall(50, function() 
				archer:stopShoot(orientation)
			end)
		end)
	else
		dont_shot = false
	end
end

-- COLLISION EVENTS FUNCTION

local function onBeginContact(e)
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	local objectA = bodyA.name
	local objectB = bodyB.name 
	
	-- Collision : Arrow vs Floor
	if objectA == "arrow" and objectB == "sfondo3" then
		world:destroyBody(bodyA)
		destroy = true
		who = bodyA
		local parent = bodyA.parent
		parent.isDestroyed = true
		parent:collision(objectB)
	elseif objectB == "arrow" and objectA == "sfondo3" then
		destroy = true
		who = bodyB
		local parent = bodyB.parent
		parent.isDestroyed = true
		parent:collision(objectA)
	end
	
	-- Collision Archer vs floor
	if objectA == "FrioArcher" and objectB == "sfondo3" then
		parent = bodyA.parent
		parent:touchFloor()
	elseif objectB == "FrioArcher" and objectA == "sfondo3" then
		parent = bodyB.parent
		parent:touchFloor()
	end
	
	-- Collision Arrow vs Archer
	if objectA == "FrioArcher" and objectB == "arrow" then
		parent = bodyB.parent
		parent:collision(objectA)
		parent = bodyA.parent
		parent:toucheByArrow()
	elseif objectA == "arrow" and objectB == "FrioArcher" then
		parent = bodyA.parent
		parent:collision(objectB)
		parent = bodyB.parent
		parent:toucheByArrow()
	end
	
	-- Collision Arrow vs Archer
	if objectA == "FrioArcher" and objectB == "item" then
		destroy = true
		who = bodyB
		parentB = bodyB.parent
		parentB.destroy = true
		parentB:collision(objectA)
		stage:removeChild(parentB)
		
		parentA = bodyA.parent
		if parentA.nbArrow < 7 then
			parentA.nbArrow = parentA.nbArrow + 1
		end
	elseif objectA == "item" and objectB == "FrioArcher" then
		destroy = true
		who = bodyA
		parentA = bodyA.parent
		parentA.destroy = true
		parentA:collision(objectB)
		stage:removeChild(parentA)
		
		parentB = bodyA.parent
		if parentB.nbArrow < 7 then
			parentB.nbArrow = parentB.nbArrow + 1
		end
	end

end

local function onEnterFrame()
	world:step(1/60, 8, 3)	
	if destroy then
		world:destroyBody(who)
		destroy = false
	end
	
	if math.random(1, 2000) == 42 then
		-- setup player
		local ammo = CLASS_ammo.new(world, physics)
		stage:addChild(ammo)
	end
	
	archer:onEnterFrame(e)
end

-- **************** EVENTS **************** 

-- PAD EVENTS
-- tnt virtual pad listeners
vPad:addEventListener(PAD.LEFTPAD_EVENT, leftJoy, self)
vPad:addEventListener(PAD.BUTTON1_EVENT, jump, self)

-- STAGE EVENTS
stage:addEventListener(Event.MOUSE_UP, fire, self)
stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

-- COLLISION EVENTS
world:addEventListener(Event.BEGIN_CONTACT, onBeginContact)
