----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 2        --
----------------------------------


-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	
-- load graphics
local particleGFX = (Texture.new("ember.png"))								-- load particles sprite

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(160, 490, -85, stage)							
-- create particles...
particleTest_1 = CParticles.new(particleGFX, 40, 2, 2, "alpha")				
particleTest_1:setSpeed(100, 350)											
particleTest_1:setSize(0.5, 4)
particleTest_1:setDisplacement(320, 0)
--particleTest_1:setAlphaMorphIn(255, 0.5)
particleTest_1:setAlphaMorphOut(0, 1.5)
particleTest_1:setColor(10,60,160, 100,150,250)

emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter
-- start emitter
emitterTest_1:start()														-- start emitter
