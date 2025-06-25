KeyDoor = Core.class(Sprite)

function KeyDoor:init(scene,x,y,id)

	self.scene = scene

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("keydoor door.png"));
	img:setAnchorPoint(0,.5)
	self:addChild(img)
	self.scene.behindRube:addChild(img)
	img:setPosition(x-37,y)
	self.door = img
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("keydoor frame 1.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.behindRube:addChild(img)
	img:setPosition(x-22,y-6)

	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("keydoor frame 2.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.frontLayer:addChild(img)
	img:setPosition(x+22,y-6)
	
	
	self.id = id

	-- Body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(34,50,0,5,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}
	fixture.parent = self
	fixture.name = "keyDoor"
	self.body = body

	local filterData = {categoryBits = 512, maskBits = 1+2+4+4096}
	fixture:setFilterData(filterData)

	self.scene.keyDoors[id] = self

	-- shudder anim
	
	-- Up tween
	
	local tween = GTween.new(self.door, .08, {x = self.door:getX()+5},{autoplay=false, repeatCount=6, reflect=true})
	tween:setPaused(true)
	self.shudder = tween

	-- sounds
	
	if(not(self.scene.creakyDoorSound)) then
		self.scene.creakyDoorSound = Sound.new("Sounds/creaky door.wav")
		
	end

end




function KeyDoor:openDoor()
	
	local channel1 = self.scene.creakyDoorSound:play()
	channel1:setVolume(.4*self.scene.soundVol)

	self.scene.claw:resetClaw()

	Timer.delayedCall(100, self.destroyBody, self)

	-- anim for open door
	
	self.scene.keys[self.id]:setVisible(false)
	
	Timer.delayedCall(100, self.doorOpenAnim, self)

end


function KeyDoor:doorOpenAnim()

	local tween = GTween.new(self.door, 1, {scaleX = 0},{ease = easing.outQuadratic})

end



function KeyDoor:destroyBody()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body) -- remove physics body
	
	local key = self.scene.keys[self.id]
	key.destroyed = true
	self.scene.world:destroyBody(key.body) -- remove physics body
	key:getParent():removeChild(key)
	
	-- reset the hero / claw anim

	--self.scene.behindRube:removeChild(self)

end



function KeyDoor:shudderAnim()

	self.shudder:setPaused(false)
	
end







