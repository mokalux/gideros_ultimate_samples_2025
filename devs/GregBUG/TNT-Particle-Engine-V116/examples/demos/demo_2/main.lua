--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 2 * " snow " *                    --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x010522)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local particleGFX = (Texture.new("smoke.png"))	
local flakeGFX = (Texture.new("ember.png"))	
local background = Bitmap.new(Texture.new("myhouse.png"))
local font = Font.new("8bit_small.txt", "8bit_small.png")

---------------------------------------------------------------------
-- define demo Text
local tntLogo = TextField.new(font, "tntparticlesengine")
local name = TextField.new(font, "Demo 2 *SNOW*")
local fps = TextField.new(font, "")
tntLogo:setPosition(40,430)
tntLogo:setTextColor(0x555588)
name:setPosition(40,445)
name:setTextColor(0x774444)
fps:setPosition(40, 60)
fps:setTextColor(0xFFBB99)


---------------------------------------------------------------------
-- define cloud 1 (3 particles)
clouds1 = CParticles.new(particleGFX, 3, 7, 7, "add")
clouds1:setSpeed(50, 80)
clouds1:setSize(3, 5)
clouds1:setAlpha(0)
clouds1:setRotation(0, -20, 360, 20)
clouds1:setAlphaMorphIn(15, 3)
clouds1:setAlphaMorphOut(0, 3)
clouds1:setColor(255, 255,255)
---------------------------------------------------------------------
-- define cloud 2 (3 particles)
clouds2 = CParticles.new(particleGFX, 3, 7, 7, "add")
clouds2:setSpeed(30, 50)
clouds2:setSize(3, 5)
clouds2:setAlpha(0)
clouds2:setRotation(0, -20, 360, 20)
clouds2:setAlphaMorphIn(10, 3)
clouds2:setAlphaMorphOut(0, 3)
clouds2:setColor(255, 255,255)
---------------------------------------------------------------------
-- define snow flakes (25 particles)
flakes = CParticles.new(flakeGFX, 30, 5.5, 5.5, "alpha")
flakes:setDisplacement(320,0)
flakes:setSpeed(50, 90)
flakes:setSize(.1, .5)
flakes:setRotation(0, -30, 360,30)
flakes:setAlpha(20, 255)
--flakes:setRotation(0, -20, 360, 20)
flakes:setAlphaMorphIn(70, 2)
flakes:setAlphaMorphOut(0, .5)
flakes:setDirectionMorphIn(-60,5.4, 60, 5.4)
flakes:setColor(255, 255,255)

---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)
emitter_3 = CEmitter.new(110,0,80, background)
emitter_1 = CEmitter.new(-40,-20,55, background)
emitter_2 = CEmitter.new(-40,400,-30, background)

---------------------------------------------------------------------
-- assign particles to emitters
stage:addChild(background)

emitter_3:assignParticles(flakes)
emitter_1:assignParticles(clouds1)
emitter_2:assignParticles(clouds2)

---------------------------------------------------------------------
-- start emitters
emitter_1:start()
emitter_2:start()
emitter_3:start()

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