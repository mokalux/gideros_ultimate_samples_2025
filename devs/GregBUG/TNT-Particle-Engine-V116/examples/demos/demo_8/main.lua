--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 8 * " FireWorks " *               --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local sparklesGFX = (Texture.new("sparkle01.png"))	
local font = Font.new("8bit_small.txt", "8bit_small.png")


---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "tntparticlesengine")
local name = TextField.new(font, "Demo 8 *FireWorks*")
local fps = TextField.new(font, "")
tntLogo:setPosition(40,430)
tntLogo:setTextColor(0xFF9955)
name:setPosition(40,445)
name:setTextColor(0xFF4444)
fps:setPosition(40, 60)
fps:setTextColor(0xFF2299)


---------------------------------------------------------------------
-- define explosion sparkles
sparkles1 = CParticles.new(sparklesGFX, 20, .5, .05, "add")
sparkles1:setRotation(10, -220, 10, 220)
sparkles1:setSize(1, 3)
sparkles1:setSpeed(200,300)
sparkles1:setDirection(0, 360)
sparkles1:setColor(200,60,200)
sparkles1:setColorMorphOut(60,60,60, .49, 255,255,255, .49)
sparkles1:setSizeMorphOut(0.1,4)
sparkles1:setGravity(0, 900)
sparkles1:setAlphaMorphOut(50, .3)
sparkles1:setLoopMode(1)

sparkles2 = CParticles.new(sparklesGFX, 20, 1, .05, "add")
sparkles2:setRotation(10, -220, 10, 220)
sparkles2:setSize(1, 3)
sparkles2:setSpeed(200,300)
sparkles2:setDirection(0, 360)
sparkles2:setColor(200,60,200)
sparkles2:setColorMorphOut(60,60,60, .99, 255,255,255, .99)
sparkles2:setSizeMorphOut(0.1,4)
sparkles2:setGravity(0, 900)
sparkles2:setAlphaMorphOut(50, .3)
sparkles2:setLoopMode(1)

sparkles3 = CParticles.new(sparklesGFX, 20, 1.5, .05, "add")
sparkles3:setRotation(10, -220, 10, 220)
sparkles3:setSize(1, 3)
sparkles3:setSpeed(200,300)
sparkles3:setDirection(0, 360)
sparkles3:setColor(200,60,200)
sparkles3:setColorMorphOut(60,60,60, 1.49, 255,255,255, 1.49)
sparkles3:setSizeMorphOut(0.1, 4)
sparkles3:setGravity(0, 900)
sparkles3:setAlphaMorphOut(50, .3)
sparkles3:setLoopMode(1)

---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(math.random(10, 300), math.random(10, 370),0, stage)
emitter_2 = CEmitter.new(math.random(10, 300), math.random(10, 370),0, stage)
emitter_3 = CEmitter.new(math.random(10, 300), math.random(10, 370),0, stage)

---------------------------------------------------------------------
-- assign particles to emitters

emitter_1:assignParticles(sparkles1)
emitter_2:assignParticles(sparkles2)
emitter_3:assignParticles(sparkles3)

---------------------------------------------------------------------
-- start emitters

---------------------------------------------------------------------
-- Add Text To stage
stage:addChild(tntLogo)
stage:addChild(name)
stage:addChild(fps)

emitter_1:start()
emitter_2:start()
emitter_3:start()

----------------------------------------------------------------------
-- show fps (thanks to atilim)
local frame = 0
local timer = os.timer()
local qFloor = math.floor

local function displayFps(event)
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
		fps:setText(qFloor(60 / (currentTimer - timer)))
		frame = 0
		timer = currentTimer	
	end
end

local function onEmitterStop(event)
	local maxlife = math.random(5, 30)/10
	sparkles1:setColor(math.random(50, 255),math.random(50, 255),math.random(50, 255))
	sparkles1:setColorMorphOut(60,60,60, (maxlife), 255,255,255, maxlife)

	sparkles1:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles1:setSpeed(100,300)
	sparkles1:setAlphaMorphOut(50, .3)
	sparkles1:setMaxLife(maxlife)
	emitter_1:setPosition(math.random(10, 300), math.random(10, 370))
	emitter_1:start()
end

local function onEmitter2Stop(event)
	local maxlife = math.random(5, 30)/10
	sparkles2:setColor(math.random(50, 255),math.random(50, 255),math.random(50, 255))
	sparkles2:setColorMorphOut(60,60,60, maxlife, 255,255,255, maxlife)
	sparkles2:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles2:setSpeed(100,300)
	sparkles2:setAlphaMorphOut(50, .3)
	sparkles2:setMaxLife(maxlife)
	emitter_2:setPosition(math.random(10, 300), math.random(10, 370))
	emitter_2:start()
end

local function onEmitter3Stop(event)
	local maxlife = math.random(5, 30)/10
	sparkles3:setColor(math.random(50, 255),math.random(50, 255),math.random(50, 255))
	sparkles3:setColorMorphOut(60,60,60, maxlife, 255,255,255, maxlife)
	sparkles3:setGravity(math.random(-300, 300), math.random(50, 1200))
	sparkles3:setSpeed(100,300)
	sparkles3:setAlphaMorphOut(50, .3)
	sparkles3:setMaxLife(maxlife)
	emitter_3:setPosition(math.random(10, 300), math.random(10, 370))
	emitter_3:start()
end

stage:addEventListener(Event.ENTER_FRAME, displayFps)
emitter_1:addEventListener("EMITTER_FINISHED", onEmitterStop, event)
emitter_2:addEventListener("EMITTER_FINISHED", onEmitter2Stop, event)
emitter_3:addEventListener("EMITTER_FINISHED", onEmitter3Stop, event)
