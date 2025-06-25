LootParticles = Core.class(Sprite);

function LootParticles:init(scene)

	self.scene = scene

	---------------------------------------------------------------------
	-- load graphics

	local particles1 = self.scene.atlas[2]:getTextureRegion("loot-particles-1.png");
	local particles2 = self.scene.atlas[2]:getTextureRegion("loot-particles-2.png");

	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 10, .6, 0,"alpha")
	parts1:setSpeed(80, 120)
	parts1:setSize(0.4, .9)
	parts1:setColor(255,255,255)
	--parts1:setAlpha(80, 100)
	parts1:setRotation(0, -160, 360, 160)
	parts1:setLoopMode(1)
	--parts1:setAlphaMorphIn(100, .6)
	parts1:setAlphaMorphOut(0, .2)
	parts1:setDirection(-90, 90)
	parts1:setSizeMorphOut(0.2, 0.9)
	parts1:setGravity(10, 140)
	--parts1:setSpeedMorphOut(450, 1, 450, 0.5)
	--parts1:setColorMorphOut(255,255,255,1.2,180,10,180,1.5)

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
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	emitter:assignParticles(parts2)





-- Sad fruit particles

	-- Bad fruit particles

	if(self.scene.fruitAtlas) then
	
		local emitter = CEmitter.new(0,0,-90, self)
		table.insert(self.scene.particleEmitters, emitter)
	
		-- particles 1
		
		local particles1 = self.scene.fruitAtlas:getTextureRegion("swap fruit splat.png")

		local parts = CParticles.new(particles1, 15, 1, 0, "alpha")
		parts:setSpeed(40, 60)
		parts:setSize(0.2, .6)
		parts:setColor(255,255,255)
		parts:setLoopMode(1)
		parts:setAlphaMorphOut(50, .5)
		parts:setDirection(-80, 80)
		parts:setGravity(0, 100)
		
		emitter:assignParticles(parts)
		
		-- particles 2
		
		local particles1 = self.scene.fruitAtlas:getTextureRegion("swap fruit splat 2.png")
		
		local parts = CParticles.new(particles1, 15, 1, 0, "alpha")
		parts:setSpeed(40, 60)
		parts:setSize(0.2, .6)
		parts:setColor(255,255,255)
		parts:setLoopMode(1)
		parts:setAlphaMorphOut(50, .5)
		parts:setDirection(-80, 80)
		parts:setGravity(0, 100)

		emitter:assignParticles(parts)
		
		self.badFruitEmitter = emitter
		
		--emitter:start()
	
	end
	
	


end


