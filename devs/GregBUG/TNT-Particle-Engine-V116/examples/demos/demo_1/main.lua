--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 1 * " clouds " *                  --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------
-- init program
application:setBackgroundColor(0x010522)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local particleGFX = (Texture.new("smoke.png"))								
local font = Font.new("8bit_small.txt", "8bit_small.png")

---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "www.tntparticlesengine.com")
local name = TextField.new(font, "Demo 1 *CLOUDS*")
local fps = TextField.new(font, "")
tntLogo:setPosition(30,260)
tntLogo:setTextColor(0xFFAA66)
name:setPosition(30,275)
name:setTextColor(0xAABB99)
fps:setPosition(30, 60)
fps:setTextColor(0xAABB99)

----------------------------------------------------------------------
-- show fps (thanks to atilim)
local frame = 0
local timer = os.timer()
local qFloor = math.floor
local function displayFps()
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
		fps:setText(qFloor(60 / (currentTimer - timer)))
		frame = 0
		timer = currentTimer	
	end
end
---------------------------------------------------------------------
-- define cloud 1 (5 particles)
clouds1 = CParticles.new(particleGFX, 5, 12, 12, "screen")
clouds1:setColor(255, 255, 255)
clouds1:setSpeed(10, 40)
clouds1:setSize(3, 5)
clouds1:setAlpha(0)
clouds1:setRotation(0, -10, 360, 10)
clouds1:setAlphaMorphIn(20, 3)
clouds1:setAlphaMorphOut(0, 3)

---------------------------------------------------------------------
-- set cloud 2 (5 particles)
clouds2 = CParticles.new(particleGFX, 5, 12, 12, "screen")
clouds2:setColor(255, 255, 255)
clouds2:setSpeed(10, 40)
clouds2:setSize(3, 5)
clouds2:setAlpha(0)
clouds2:setRotation(0, -10, 360, 10)
clouds2:setAlphaMorphIn(20, 3)
clouds2:setAlphaMorphOut(0, 3)

---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)
emitter_1 = CEmitter.new(0,0,0, stage)
emitter_2 = CEmitter.new(480,320,180, stage)

---------------------------------------------------------------------
-- assign particles to emitters
emitter_1:assignParticles(clouds1)
emitter_2:assignParticles(clouds2)

---------------------------------------------------------------------
-- start emitters
emitter_1:start()
emitter_2:start()

---------------------------------------------------------------------
-- Add Text To stage
stage:addChild(tntLogo)
stage:addChild(name)
stage:addChild(fps)
---------------------------------------------------------------------
-- Add FPS Counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)