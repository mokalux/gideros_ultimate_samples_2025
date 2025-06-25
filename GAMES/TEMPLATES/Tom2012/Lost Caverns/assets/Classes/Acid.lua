Acid = Core.class(Sprite)

function Acid:init(scene,x,y,animName)

	self.scene = scene

	-- If this is first instance
	
		-- Create anim loaders
	
	if(not(self.scene.acidAnimLoader)) then
	

	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Acid.tan", self.scene.atlas['Acid'], true)
		self.scene.acidAnimLoader = animLoader
	end

	local anim = CTNTAnimator.new(self.scene.acidAnimLoader)
	anim:setAnimation('ACID')
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self.anim = anim
	self:addChild(anim)
	self:setPosition(x,y)
	self.scene.layer0:addChild(self)
	
	
	-- Now do particles

	---------------------------------------------------------------------
	-- load graphics

	local particles1 = self.scene.atlas['Acid']:getTextureRegion("acid particle.png")


	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 5, 1.2, .8,"alpha")
	parts1:setSpeed(20, 50)
	parts1:setAlpha(0)
	parts1:setColor(255,255,255)
	parts1:setParticlesOffset(50,0)
	parts1:setRotation(0, -160, 360, 160)
	parts1:setAlphaMorphOut(0, .8)
	parts1:setDirection(0)
	parts1:setSize(.1,1.5)
	parts1:setAlphaMorphIn(155, .3)
	
	---------------------------------------------------------------------
	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,-90, self)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	emitter:start()
	table.insert(self.scene.particleEmitters, self.emitter)

	---------------------------------------------------------------------
	-- start emitters

	-- Add timer to move emitter

	local timer = Timer.new(80, math.huge)
	timer:addEventListener(Event.TIMER, self.moveEmitter, self)
	timer:start()
	
end


function Acid:moveEmitter()

	self.emitter:setPosition(math.random(-120,30),20)

end




