--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 5 * " FIREWORKS WITH EVENTS " *   --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local sparklesGFX = (Texture.new("exp1.png"))	
local font = Font.new("8bit_small.txt", "8bit_small.png")


---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "tntparticlesengine")
local name = TextField.new(font, "Demo 5 *EVENTS*")
local fps = TextField.new(font, "")
local STATUS = TextField.new(font, "EMITTER IDLE")

tntLogo:setPosition(40,430)
tntLogo:setTextColor(0xFF9955)
name:setPosition(40,445)
name:setTextColor(0xFF4444)
fps:setPosition(40, 60)
fps:setTextColor(0xFF2299)
STATUS:setPosition(40, 90)
STATUS:setTextColor(0xFF2299)


---------------------------------------------------------------------
-- define explosion sparkles
sparkles = CParticles.new(sparklesGFX, 50, 1, 0.5, "add")
sparkles:setSize(0.3, 1)
sparkles:setSpeed(400, 550)
sparkles:setAlpha(0)
sparkles:setAlphaMorphIn(255, 0.2)
sparkles:setAlphaMorphOut(0, 0.6	)
sparkles:setDirection(0, 360)
sparkles:setColor(50,50,50, 255, 255, 255)
--sparkles:setGravity(0,2500)
---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(160,240,0, stage)


---------------------------------------------------------------------
-- assign particles to emitters

sparkles:setLoopMode(3)

emitter_1:assignParticles(sparkles)

---------------------------------------------------------------------
-- start emitters

---------------------------------------------------------------------
-- Add Text To stage
stage:addChild(tntLogo)
stage:addChild(name)
stage:addChild(fps)
stage:addChild(STATUS)

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
	emitter_1:setPosition(event.x, event.y)
	emitter_1:start()
end
local function onEmitterStart(event)
	STATUS:setText("EMITTER START")
end
local function onEmitterStop(event)
	STATUS:setText("EMITTER FINISHED")
end


---------------------------------------------------------------------
-- Add FPS Counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
emitter_1:addEventListener("EMITTER_START", onEmitterStart, event)
emitter_1:addEventListener("EMITTER_FINISHED", onEmitterStop, event)