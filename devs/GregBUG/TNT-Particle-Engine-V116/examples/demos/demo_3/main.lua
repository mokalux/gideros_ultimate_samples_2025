--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 3 * " FIRE " *                    --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local particleGFX = (Texture.new("smoke.png"))	
local sparkleGFX = (Texture.new("ember.png"))	
local font = Font.new("8bit_small.txt", "8bit_small.png")

---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "tntparticlesengine")
local name = TextField.new(font, "Demo 3 *FIRE*")
local fps = TextField.new(font, "")
tntLogo:setPosition(40,430)
tntLogo:setTextColor(0xFF9955)
name:setPosition(40,445)
name:setTextColor(0xFF4444)
fps:setPosition(40, 60)
fps:setTextColor(0xFF2299)


---------------------------------------------------------------------
-- define fire
fire = CParticles.new(particleGFX, 30, 1.5, 1.5, "add")
fire:setSpeed(220, 320)
fire:setSize(0.5, 1)
fire:setColor(255,110,80)
fire:setAlpha(0)
fire:setRotation(0, -160, 360, 160)
fire:setAlphaMorphIn(240, .15)
fire:setAlphaMorphOut(50, .9)
fire:setSizeMorphOut(0.2, 0.9)
fire:setSpeedMorphOut(450, 1, 450, 0.5)
fire:setColorMorphOut(110,110,110,1.2,20,20,20,1.5)
---------------------------------------------------------------------
-- define sparkle
sparkle = CParticles.new(sparkleGFX, 8, 1.5, 1.5, "add")
sparkle:setSpeed(120, 180)
sparkle:setSize(0.3, 0.6)
sparkle:setColor(255,80,60)
sparkle:setDirection(-90, 90)
sparkle:setAlpha(10)
sparkle:setAlphaMorphIn(255, .15)
sparkle:setAlphaMorphOut(10, .3)
sparkle:setColorMorphOut(255,190,70,0.7)
sparkle:setGravity(0, 140)
sparkle:setParticlesOffset(0, -20)
---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(160,380,-90, stage)


---------------------------------------------------------------------
-- assign particles to emitters


emitter_1:assignParticles(sparkle)
emitter_1:assignParticles(fire)

---------------------------------------------------------------------
-- start emitters
emitter_1:start()


---------------------------------------------------------------------
-- Add Text To stage
stage:addChild(tntLogo)
stage:addChild(name)
stage:addChild(fps)

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
---------------------------------------------------------------------
-- Add FPS Counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)