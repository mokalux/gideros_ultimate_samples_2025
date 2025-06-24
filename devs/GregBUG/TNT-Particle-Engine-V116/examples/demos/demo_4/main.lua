--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 4 * " EXPLOSION " *               --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local waveGFX = (Texture.new("shockwave1.png"))	
local sparklesGFX = (Texture.new("exp1.png"))	
local smokeGFX = (Texture.new("smoke.png"))	
local font = Font.new("8bit_small.txt", "8bit_small.png")


---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "tntparticlesengine")
local name = TextField.new(font, "Demo 4 *EXPLOSION*")
local fps = TextField.new(font, "")
tntLogo:setPosition(40,430)
tntLogo:setTextColor(0xFF9955)
name:setPosition(40,445)
name:setTextColor(0xFF4444)
fps:setPosition(40, 60)
fps:setTextColor(0xFF2299)


---------------------------------------------------------------------
-- define explosion weave
wave = CParticles.new(waveGFX, 1, 1, 0, "add")
wave:setSize(0.1)
wave:setAlpha(190)
wave:setColor(150,120,130)
wave:setAlphaMorphOut(0, 1)
wave:setSizeMorphOut(2, 1)

---------------------------------------------------------------------
-- define explosion sparkles
sparkles = CParticles.new(sparklesGFX, 10, 1, 0, "add")
sparkles:setSize(0.3, 0.8)
sparkles:setSpeed(150, 350)
sparkles:setAlpha(0)
sparkles:setDirection(0, 360)
sparkles:setColor(255,100,190)
sparkles:setAlphaMorphIn(255, .5)
sparkles:setAlphaMorphOut(0, .5)

---------------------------------------------------------------------
-- define explosion sparkles
smoke = CParticles.new(smokeGFX, 5, 1, 0, "add")
smoke:setSize(1, 2)
smoke:setSpeed(100, 160)
smoke:setRotation(0, 80, 360, -80)
smoke:setDirection(0, 360)
smoke:setColor(120,90,150)
smoke:setAlphaMorphOut(0, 1)
smoke:setSizeMorphOut(3, 1)

---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(160,240,0, stage)


---------------------------------------------------------------------
-- assign particles to emitters

wave:setLoopMode(1)
sparkles:setLoopMode(1)
smoke:setLoopMode(1)

emitter_1:assignParticles(wave)
emitter_1:assignParticles(sparkles)
emitter_1:assignParticles(smoke)

---------------------------------------------------------------------
-- start emitters

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

local function onMouseDown(event)
	emitter_1:start()
	emitter_1:setPosition(event.x, event.y)
end


---------------------------------------------------------------------
-- Add FPS Counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
