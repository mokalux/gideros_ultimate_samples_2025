WalkingChestParticles = Core.class(Sprite)

function WalkingChestParticles:init(scene)

	self.scene = scene;

	---------------------------------------------------------------------
	-- load graphics

	local particles1 = self.scene.atlas[2]:getTextureRegion("chest part 1.png");
	local particles2 = self.scene.atlas[2]:getTextureRegion("chest part 2.png");

	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 6, 1.5, 0,"alpha")
	parts1:setSpeed(50, 120)
	parts1:setSize(0.05, .8)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setRotation(0, -160, 360, 160)
	--parts1:setAlphaMorphIn(100, .6)
	parts1:setAlphaMorphOut(50, .3)
	parts1:setDirection(-60, 60)
	--parts1:setSizeMorphOut(0.2, 0.9)
	parts1:setGravity(10, 140)
	--parts1:setSpeedMorphOut(450, 1, 450, 0.5)

	---------------------------------------------------------------------
	-- particles 2
	---------------------------------------------------------------------

	local parts2 = CParticles.new(particles2, 6, 1, 0,"alpha")
	parts2:setSpeed(50, 180)
	parts2:setSize(0.5, 1)
	parts2:setLoopMode(1)
	parts2:setColor(255,255,255)
	parts2:setRotation(0, -160, 360, 160)
	parts2:setAlphaMorphOut(50, .3)
	parts2:setDirection(-60, 60)
	parts2:setGravity(10, 140)

	---------------------------------------------------------------------
	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,-90, self)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	emitter:assignParticles(parts2)

	---------------------------------------------------------------------
	-- start emitters
	
	--emitter:start()

end
