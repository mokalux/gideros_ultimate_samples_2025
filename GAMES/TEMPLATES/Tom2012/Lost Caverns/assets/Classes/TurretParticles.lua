TurretParticles = Core.class(Sprite);

function TurretParticles:init(scene)

	self.scene = scene

	---------------------------------------------------------------------
	-- load graphics

	local particles1 = self.scene.atlas[2]:getTextureRegion("turret particle 1.png");
	local particles2 = self.scene.atlas[2]:getTextureRegion("turret particle 2.png");

	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 40, 1, 1,"alpha")
	parts1:setSpeed(50, 120)
	parts1:setSize(0.05, .8)
	parts1:setColor(110,50,0, 190,110,50)
	parts1:setLoopMode(1)
	parts1:setAlphaMorphOut(50, .3)
	parts1:setRotation(0, -160, 360, 160)
	parts1:setDirection(-60, 60)
	parts1:setGravity(10, 140)

	---------------------------------------------------------------------
	-- particles 2
	---------------------------------------------------------------------

	local parts2 = CParticles.new(particles2, 20, 1, 1,"alpha")
	parts2:setSpeed(40, 100)
	parts2:setSize(0.5, 1)
	parts2:setLoopMode(1)
	parts2:setColor(50,144,44, 73,164,84)
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
