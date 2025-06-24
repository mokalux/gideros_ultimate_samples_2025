----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 9        --
----------------------------------
-- Speed IN/OUT Moprh and Enable/Disable at run time
 
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

-- load graphics
local particleGFX = (Texture.new("ptexture.png"))								-- load particles sprite

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(160, 240, 0, stage)							
particleTest_1 = CParticles.new(particleGFX, 50, 2, 2, "add")				
 
-- create particles...
particleTest_1:setColor(0, 0, 0, 255, 255, 255)
particleTest_1:setSpeed(50)
particleTest_1:setDirection(0, 360)
particleTest_1:setSize(0.3)
particleTest_1:setSpeedMorphIn(150, .5)
particleTest_1:setSpeedMorphOut(10,2)
particleTest_1:setEnableSpeedMorph(false, false)

-- assign particles...
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter

-- start emitter
emitterTest_1:start()														-- start emitter


local function onMouseDown(event)
	dmin, dmout = particleTest_1:getSpeedMorphEnabled()
	
	dmin = not dmin
	dmout = not dmout

	particleTest_1:setEnableSpeedMorph(dmin, dmout)
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
