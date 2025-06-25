ClawParticles = Core.class(Sprite)

function ClawParticles:init(scene)

	self.scene = scene
	
	-- Spark particles

	local particles1 = self.scene.atlas[2]:getTextureRegion("spark.png")
	local particles2 = self.scene.atlas[2]:getTextureRegion("spark.png")

	-- particles 1

	local parts1 = CParticles.new(particles1, 10, .5, 0, "alpha")
	parts1:setSpeed(20, 40)
	parts1:setSize(0.2, .6)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setAlphaMorphOut(50, .2)
	parts1:setDirection(0, 360)
	parts1:setGravity(0, 250)

	-- particles 2

	local parts2 = CParticles.new(particles2, 10, .5, 0, "alpha")
	parts2:setSpeed(50, 100)
	parts2:setSize(0.3, .6)
	parts2:setLoopMode(1)
	parts2:setColor(255,255,255)
	parts2:setRotation(0, -160, 360, 160)
	parts2:setAlphaMorphOut(50, .2)
	parts2:setDirection(0, 360)
	parts2:setGravity(0, 140)

	local emitter = CEmitter.new(0,0,-90, self.scene.rube1)
	self.sparkEmitter = emitter
	table.insert(self.scene.particleEmitters, self.sparkEmitter)

	emitter:assignParticles(parts1)
	emitter:assignParticles(parts2)

	--self.sparkEmitter:start()

end


