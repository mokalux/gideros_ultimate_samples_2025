--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 6 * " Deep Space " *              --
--------------------------------------------
-- for GIDEROS 2002.2.1                   --
--------------------------------------------


---------------------------------------------------------------------
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

---------------------------------------------------------------------
-- load graphics
local starsGFX = (Texture.new("exp1.png"))	
local nubiGFX = (Texture.new("smoke.png"))	
local nebulosaGFX = Bitmap.new(Texture.new("nebulosa.png"))	
local logoGFX = Bitmap.new(Texture.new("logo1.png"))	
local font = Font.new("8bit_small.txt", "8bit_small.png")


---------------------------------------------------------------------
-- define demo Text
local name = TextField.new(font, "Demo 6 *Deep Space*")
local fps = TextField.new(font, "")


name:setPosition(30,295)
name:setTextColor(0xFF4444)
fps:setPosition(30, 35)
fps:setTextColor(0xFF2299)

nebulosaGFX:setAnchorPoint(.5, .5)
nebulosaGFX:setScale(2.3)
nebulosaGFX:setPosition(240,160)

logoGFX:setAnchorPoint(.5, .5)
logoGFX:setPosition(240,160)

---------------------------------------------------------------------
stars = CParticles.new(starsGFX, 50, 2.5, 2.5, "add")-- define explosion sparkles
stars:setSize(0.2, .35)
stars:setDirection(0, 360)
stars:setSpeed(50, 100)
stars:setAlpha(0)
stars:setColor(255, 255, 255)
stars:setAlphaMorphIn(150, 1.6)
stars:setAlphaMorphOut(0, .9)
stars:setSizeMorphOut(.7, 1)
---------------------------------------------------------------------
-- define explosion sparkles
nubi = CParticles.new(nubiGFX, 4, 2.5, 2.5, "alpha")
nubi:setSize(2)
nubi:setDirection(0, 360)
nubi:setSpeed(30, 50)
nubi:setRotation(0, 10)
nubi:setColor(255, 255, 255)
nubi:setAlpha(0)
nubi:setAlphaMorphIn(18, 1)
nubi:setAlphaMorphOut(9, 2.5)
nubi:setSizeMorphOut(7, 2.5)


---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(240,160,0, stage)


---------------------------------------------------------------------
-- assign particles to emitters

stage:addChild(nebulosaGFX)
emitter_1:assignParticles(nubi)
emitter_1:assignParticles(stars)
stage:addChild(logoGFX)
---------------------------------------------------------------------
-- start emitters

emitter_1:start()

---------------------------------------------------------------------
-- Add Text To stage
stage:addChild(name)
stage:addChild(fps)


----------------------------	emitter_1:start()
------------------------------------------
-- show fps (thanks to atilim)
local frame = 0
local timer = os.timer()
local qFloor = math.floor
local r = 0
local function displayFps(event)
	frame = frame + 1
	if frame == 60 then
		local currentTimer = os.timer()
		fps:setText(qFloor(60 / (currentTimer - timer)))
		frame = 0
		timer = currentTimer	
	end
	nebulosaGFX:setRotation(r)
	emitter_1:setDirection(r*8)
	r = r +3*event.deltaTime
end

local function onMouseDown(event)
end


---------------------------------------------------------------------
-- Add FPS Counter to stage
stage:addEventListener(Event.ENTER_FRAME, displayFps)
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
