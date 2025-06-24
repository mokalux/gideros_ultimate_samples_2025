--------------------------------------------
-- TNT Particles Engine                   --
-- Copygiht (C) 2012 By Gianluca D'Angelo --
-- All Right Reserved.                    --
--------------------------------------------
-- Demo 7 * " Fingers " *               --
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
local name = TextField.new(font, "Demo 7 *Fingers*")
local fps = TextField.new(font, "")
tntLogo:setPosition(40,430)
tntLogo:setTextColor(0xFF9955)
name:setPosition(40,445)
name:setTextColor(0xFF4444)
fps:setPosition(40, 60)
fps:setTextColor(0xFF2299)


---------------------------------------------------------------------
-- define explosion sparkles
sparkles1 = CParticles.new(sparklesGFX, 65, 1, 1, "screen")
sparkles1:setRotation(10, 1, 10, 220)
sparkles1:setSpeed(20)
sparkles1:setDirection(0, 360)
sparkles1:setColor(60,255,60)
sparkles1:setAlphaMorphOut(0, .5)

sparkles2 = CParticles.new(sparklesGFX, 65, 1, 1, "screen")
sparkles2:setRotation(10, 1, 10, 220)
sparkles2:setSpeed(20)
sparkles2:setDirection(0, 360)
sparkles2:setColor(255,255,255)
sparkles2:setAlphaMorphOut(0, .5)

sparkles3 = CParticles.new(sparklesGFX, 65, 1, 1, "screen")
sparkles3:setRotation(10, 1, 10, 220)
sparkles3:setSpeed(20)
sparkles3:setDirection(0, 360)
sparkles3:setColor(255,60,60)
sparkles3:setAlphaMorphOut(0, .5)

---------------------------------------------------------------------
-- set emitter 1 (sx) and emitter 2 (dx)

emitter_1 = CEmitter.new(160,480,0, stage)
emitter_2 = CEmitter.new(160,480,0, stage)
emitter_3 = CEmitter.new(160,480,0, stage)


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


local dots = {emitter_1, emitter_2, emitter_3}

local function onTouchesBegin(event)
	local dot = event.touch.id
	if dot then
		if dot == 1 then
			emitter_1:start()
			emitter_1:setPosition(event.touch.x, event.touch.y)
		elseif dot == 2 then
			emitter_2:start()
			emitter_2:setPosition(event.touch.x, event.touch.y)
		elseif dot == 3 then
			emitter_3:start()
			emitter_3:setPosition(event.touch.x, event.touch.y)
		end
	end
end

local function onTouchesMove(event)
	local dot = event.touch.id
	if dot then
		if dot == 1 then
			sparkles1:setMoveXY(event.touch.x, event.touch.y)
		elseif dot == 2 then
			sparkles2:setMoveXY(event.touch.x, event.touch.y)
		elseif dot == 3 then
			sparkles3:setMoveXY(event.touch.x, event.touch.y)
		end
	end
end

local function onTouchesEnd(event)
	local dot = event.touch.id
	if dot then
		if dot == 1 then
			emitter_1:stop()
		elseif dot == 2 then
			emitter_2:stop()
		elseif dot == 3 then
			emitter_3:stop()
		end
	end
end


stage:addEventListener(Event.TOUCHES_BEGIN, onTouchesBegin)
stage:addEventListener(Event.TOUCHES_MOVE, onTouchesMove)
stage:addEventListener(Event.TOUCHES_END, onTouchesEnd)
stage:addEventListener(Event.ENTER_FRAME, displayFps)

