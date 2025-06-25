ExitDoorParticles = Core.class(Sprite);

function ExitDoorParticles:init(scene)

self.scene = scene;

---------------------------------------------------------------------
-- load graphics

local particles1 = self.scene.atlas[3]:getTextureRegion("loot-particles-1.png");
local particles2 = self.scene.atlas[3]:getTextureRegion("loot-particles-2.png");

---------------------------------------------------------------------
-- particles 1
---------------------------------------------------------------------

local parts1 = CParticles.new(particles1, 10, .8, 0,"alpha")
parts1:setSpeed(30, 60)
parts1:setSize(0.2, .5)
parts1:setColor(255,255,255)
--parts1:setAlpha(80, 100)
parts1:setRotation(0, -160, 360, 160)
parts1:setLoopMode(1)
--parts1:setAlphaMorphIn(100, .6)
parts1:setAlphaMorphOut(0, .2)
parts1:setDirection(1, 360)
parts1:setSizeMorphOut(0.2, 0.9)
--parts1:setGravity(10, 140)
--parts1:setSpeedMorphOut(450, 1, 450, 0.5)
parts1:setColorMorphOut(255,255,255,1.2,180,10,180,1.5)

---------------------------------------------------------------------
-- particles 2
---------------------------------------------------------------------

local parts2 = CParticles.new(particles2, 10, .8, 0,"alpha")
parts2:setSpeed(30, 40)
parts2:setSize(0.2, .8)
parts2:setColor(255,255,255)
parts2:setRotation(0, -160, 360, 160)
parts2:setAlphaMorphOut(0, .2)
parts2:setLoopMode(1)
parts2:setDirection(1, 360)
--parts2:setGravity(10, 140)

---------------------------------------------------------------------
-- assign particles to emitters

local emitter = CEmitter.new(0,0,-90, self)
self.emitter = emitter;

emitter:assignParticles(parts1)
emitter:assignParticles(parts2)

---------------------------------------------------------------------
-- start emitters

end
