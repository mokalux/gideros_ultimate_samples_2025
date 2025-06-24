----------------------------------
-- TNT Particles Engine         --
-- By Gianluca D'Angelo         --
-- (C) 2012 All Right Reserved. --
-- Very Simple Example 8        --
----------------------------------
-- Alpha IN/OUT Moprh and Enable/Disable at run time
 
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
particleTest_1:setSpeed(50, 70)
particleTest_1:setDirection(0, 360)
particleTest_1:setSize(0.6)
particleTest_1:setAlpha(50)
particleTest_1:setAlphaMorphIn(255, 1.5)
particleTest_1:setAlphaMorphOut(0, 1.5)
particleTest_1:setEnableAlphaMorph(false, false)

-- assign particles...
emitterTest_1:assignParticles(particleTest_1)								-- assign particle to emitter

-- start emitter
emitterTest_1:start()														-- start emitter


local function onMouseDown(event)
	dmin, dmout = particleTest_1:getAlphaMorphEnabled()
	
	dmin = not dmin
	dmout = not dmout

--	if dmin then
	--	particleTest_1:setAlpha(255)
--	end

	particleTest_1:setEnableAlphaMorph(dmin, dmout)
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown, event)
