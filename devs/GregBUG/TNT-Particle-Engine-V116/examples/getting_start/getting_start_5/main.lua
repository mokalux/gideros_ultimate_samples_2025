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
local particleGFX2 = (Texture.new("ptexture.png"))								-- load particles sprite
local logo = Bitmap.new(Texture.new("logo1.png"))								-- load particles sprite
logo:setPosition(10, 130)

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(10, 310, -90, stage)							
emitterTest_2 = CEmitter.new(480, 160, 180, stage)							
-- create particles...
particleTest_1 = CParticles.new(particleGFX, 40, 3.3, 3.3, "add")				
particleTest_1:setSpeed(270)											
particleTest_1:setSize(1, 3)
particleTest_1:setAlpha(0)
particleTest_1:setDisplacement(120, 0)
particleTest_1:setAlphaMorphIn(255, .8)
particleTest_1:setAlphaMorphOut(0, 2)
particleTest_1:setColor(50,50,50, 255,255,255)
particleTest_1:setDirectionMorphIn(90,0.8, 60, 1)
particleTest_1:setDirectionMorphOut(-90, 1.7, -70, 1.7)

 
particleTest_2 = CParticles.new(particleGFX2, 10, 1.5, 1.5, "alpha")				
-- create particles...
particleTest_2:setColor(0, 0, 0, 20, 10, 255)
particleTest_2:setSpeed(250,350)										
particleTest_2:setDisplacement(0, 80)
particleTest_2:setSize(1, 3.5)
particleTest_2:setAlpha(0)
particleTest_2:setAlphaMorphIn(255, 0.4)
particleTest_2:setAlphaMorphOut(0, 0.4)
-- assign particles...


emitterTest_2:assignParticles(particleTest_2)								-- assign particle to emitter
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter
stage:addChild(logo)



-- start emitter
emitterTest_1:start()														-- start emitter
emitterTest_2:start()														-- start emitter


