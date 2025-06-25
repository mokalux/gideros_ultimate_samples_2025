CreeperBugParticles = Core.class(Sprite);

function CreeperBugParticles:init(scene)

self.scene = scene

---------------------------------------------------------------------
-- load graphics

local particles1 = self.scene.creeperBugAtlas:getTextureRegion("part1.png")
local particles2 = self.scene.creeperBugAtlas:getTextureRegion("part2.png")
local particles3 = self.scene.creeperBugAtlas:getTextureRegion("part3.png")
local particles4 = self.scene.creeperBugAtlas:getTextureRegion("leg1.png")
local particles5 = self.scene.creeperBugAtlas:getTextureRegion("head.png")

---------------------------------------------------------------------
-- particles 1
---------------------------------------------------------------------

local parts1 = CParticles.new(particles1, 8, 1.5, 0,"alpha")
parts1:setSpeed(30, 60)
parts1:setSize(0.05, .8)
parts1:setColor(255,255,255)
parts1:setLoopMode(1)
parts1:setRotation(0, -160, 360, 160)
--parts1:setAlphaMorphIn(100, .6)
parts1:setAlphaMorphOut(50, .3)
parts1:setDirection(0, 360)
--parts1:setSizeMorphOut(0.2, 0.9)
parts1:setGravity(10, 140)
--parts1:setSpeedMorphOut(450, 1, 450, 0.5)

---------------------------------------------------------------------
-- particles 2
---------------------------------------------------------------------

local parts2 = CParticles.new(particles2, 8, 1, 0,"alpha")
parts2:setSpeed(50, 70)
parts2:setSize(0.5, 1)
parts2:setLoopMode(1)
parts2:setColor(255,255,255)
parts2:setRotation(0, -160, 360, 160)
parts2:setAlphaMorphOut(50, .3)
parts2:setDirection(0, 360)
parts2:setGravity(10, 140)

---------------------------------------------------------------------
-- particles 3
---------------------------------------------------------------------

local parts3 = CParticles.new(particles3, 20, 1.1, 0,"alpha")
parts3:setSpeed(10, 50)
parts3:setSize(.5, 1)
parts3:setLoopMode(1)
parts3:setColor(255,255,255)
parts3:setRotation(0, -160, 360, 160)
parts3:setAlphaMorphOut(50, .2)
parts3:setDirection(0, 360)
parts3:setGravity(10, 50)

---------------------------------------------------------------------
-- particles 4
---------------------------------------------------------------------

local parts4 = CParticles.new(particles4, 6, 1, 0,"alpha")
parts4:setSpeed(40, 70)
parts4:setLoopMode(1)
parts4:setSize(1)
parts4:setColor(255,255,255)
parts4:setRotation(0, -160, 360, 160)
parts4:setAlphaMorphOut(50, .2)
parts4:setDirection(0,360)
parts4:setGravity(10, 50)


---------------------------------------------------------------------
-- assign particles to emitters

local emitter = CEmitter.new(0,0,-90, self)
self.emitter = emitter
table.insert(self.scene.particleEmitters, self.emitter)

emitter:assignParticles(parts1)
emitter:assignParticles(parts2)
emitter:assignParticles(parts3)
emitter:assignParticles(parts4)
--emitter:assignParticles(parts5)

---------------------------------------------------------------------
-- start emitters

end
