----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 1        --
----------------------------------


-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	
-- load graphics
local particleGFX = (Texture.new("ember.png"))								-- load particles sprite

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(160, 400, -90, stage)							-- create emitter positioned at x 160 y 390 direction -90 degree

-- create particles...
particleTest_1 = CParticles.new(particleGFX, 40, 3, 3, "add")				-- create 15 particles, maxLife 1 sec, max delay 1 sec using alpha blending
particleTest_1:setSpeed(250, 450)											-- set particles speed min 150 pixel/sec max 350 Pixel/sec
particleTest_1:setDirection(-8, 8)
particleTest_1:setColor(0,0,0, 255,255,255)							-- set current color for all particles
particleTest_1:setAlpha(0)													-- set current color for all particles
particleTest_1:setSizeMorphIn(5, 1.5, 3)
particleTest_1:setGravityForce(0,250)
particleTest_1:setGravity(0,250)
particleTest_1:setAlphaMorphIn(255, 1)
particleTest_1:setAlphaMorphOut(0, 1.5)
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter

-- start emitter
emitterTest_1:start()														-- start emitter
