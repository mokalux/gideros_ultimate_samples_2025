----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 7        --
----------------------------------
-- Size IN/OUT Moprh and Enable/Disable at run time
 
-- init program
application:setBackgroundColor(0x000000)
application:setKeepAwake(true)	

-- load graphics
local particleGFX = (Texture.new("ptexture.png"))								-- load particles sprite

-- create new emitter called emitterTest_1
emitterTest_1 = CEmitter.new(160, 240, 0, stage)							
particleTest_1 = CParticles.new(particleGFX, 40, 3, 3, "add")				
 
-- create particles...
particleTest_1:setColor(0, 0, 0, 255, 255, 255)
particleTest_1:setSpeed(50, 80)
particleTest_1:setDirection(0, 360)
particleTest_1:setSize(0.3)
particleTest_1:setAlpha(255)
particleTest_1:setSizeMorphIn(1.5, 1.5)
particleTest_1:setSizeMorphOut(.1, 1.5)
particleTest_1:setEnableSizeMorph(false, false)

-- assign particles...
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter

-- start emitter
emitterTest_1:start()														-- start emitter


local function onMouseDown(event)
	dmin, dmout = particleTest_1:getSizeMorphEnabled()
	
	dmin = not dmin
	dmout = not dmout


	particleTest_1:setEnableSizeMorph(dmin, dmout)
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
