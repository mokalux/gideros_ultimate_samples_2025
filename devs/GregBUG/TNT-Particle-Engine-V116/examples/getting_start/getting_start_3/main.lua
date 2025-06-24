----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 3        --
----------------------------------


-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	
-- load graphics
local particleGFX = (Texture.new("ember.png"))								-- load particles sprite

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(160, 240, -90, stage)							
-- create particles...
particleTest_1 = CParticles.new(particleGFX, 30, 2.3, 2.3, "add")				
particleTest_1:setSpeed(140)										
particleTest_1:setDirection(0, 360)
particleTest_1:setAlpha(0)
particleTest_1:setAlphaMorphIn(255, 0.65)
particleTest_1:setAlphaMorphOut(0, 1.0)

particleTest_1:setSize(2,3)

particleTest_1:setColor(0, 0, 0, 255, 255, 255)
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter

-- start emitter
emitterTest_1:start()														-- start emitter
local  n = 0
function onEnterFrame(event)
	n= n + 150*event.deltaTime
	emitterTest_1:setDirection(n)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)						-- add event listner "onEnterFrame"
