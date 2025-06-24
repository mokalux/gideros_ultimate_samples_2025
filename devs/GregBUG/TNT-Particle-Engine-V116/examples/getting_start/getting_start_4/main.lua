----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 4        --
----------------------------------

 
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	
-- load graphics
local particleGFX = (Texture.new("ptexture.png"))								-- load particles sprite
local logo = Bitmap.new(Texture.new("logo1.png"))								-- load particles sprite
logo:setPosition(10, 130)

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(0, 160, 0, stage)							
 
particleTest_1 = CParticles.new(particleGFX, 30, 1.5, 1.5, "alpha")				
-- create particles...
particleTest_1:setColor(0, 0, 0, 255, 255, 255)
particleTest_1:setSpeed(250,350)										
particleTest_1:setDisplacement(0, 200)
particleTest_1:setSize(1, 2.5)
particleTest_1:setAlpha(0)
particleTest_1:setAlphaMorphIn(255, 0.4)
particleTest_1:setAlphaMorphOut(0, 0.4)
-- assign particles...
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter
 stage:addChild(logo)
 particleTest_1:setLoopMode(0)
-- start emitter
emitterTest_1:start()														-- start emitter
