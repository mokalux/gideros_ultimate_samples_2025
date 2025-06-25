BallParticles = Core.class(Sprite);

function BallParticles:init(scene)

	self.scene = scene;

	---------------------------------------------------------------------
	-- load graphics

	local particles1 = self.scene.atlas[2]:getTextureRegion("skull particle 1.png")
	local particles2 = self.scene.atlas[2]:getTextureRegion("skull particle 2.png")
	local particles3 = self.scene.atlas[2]:getTextureRegion("skull particle 3.png")

	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 30, 3, 0,"alpha")
	parts1:setSpeed(50, 120)
	parts1:setSize(0.05, .2)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setRotation(0, -160, 360, 160)
	--parts1:setAlphaMorphIn(100, .6)
	parts1:setAlphaMorphOut(50, .3)
	parts1:setDirection(0, 360)
	--parts1:setSizeMorphOut(0.2, 0.9)
	parts1:setGravity(50, 140)
	--parts1:setSpeedMorphOut(450, 1, 450, 0.5)

	---------------------------------------------------------------------
	-- particles 2
	---------------------------------------------------------------------

	local parts2 = CParticles.new(particles2, 10, 4, 0,"alpha")
	parts2:setSpeed(30, 60)
	parts2:setSize(0.5, 1)
	parts2:setLoopMode(1)
	parts2:setColor(255,255,255)
	parts2:setRotation(0, -160, 360, 160)
	parts2:setAlphaMorphOut(50, .3)
	parts2:setDirection(-60, 60)
	parts2:setGravity(50, 140)
	
	---------------------------------------------------------------------
	-- particles 3
	---------------------------------------------------------------------

	local parts3 = CParticles.new(particles3, 10, 4, 0,"alpha")
	parts3:setSpeed(20, 30)
	parts3:setLoopMode(1)
	parts3:setColor(255,255,255)
	parts3:setRotation(0, -160, 360, 160)
	parts3:setAlphaMorphOut(50, .3)
	parts3:setDirection(-60, 60)
	parts3:setGravity(50, 140)

	---------------------------------------------------------------------
	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,-90, self)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	--emitter:assignParticles(parts2)
	--emitter:assignParticles(parts3)

	---------------------------------------------------------------------
	-- start emitters
	
	--emitter:start()

end
