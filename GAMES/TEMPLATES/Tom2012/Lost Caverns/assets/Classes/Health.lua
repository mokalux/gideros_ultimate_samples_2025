Health = Core.class(Sprite)

function Health:init(scene)

	--health=math.huge

	self.scene = scene

	self.hearts = {}
	
	if(not(health)) then
		health = 4
	end
	
	if(health<4) then
		health = 4
	end
	
	self:updateHealth()
	
	

end




function Health:reduceHealth(number)

	health = health - number
	self:updateHealth()

end



function Health:increaseHealth(number)

	health = health + number
	self:updateHealth()

end



function Health:updateHealth()
		
	-- remove all hearts
	
	for i,v in pairs(self.hearts) do
		self:removeChild(v)
	end
	
	self.hearts = {}
	self.heartX = 0

	if(health <= -1) then
	
		self.scene.hero:die()
		self.scene:dispatchEvent(Event.new("onExit", self.scene))
		self.scene.gameEnded = true
	end

	if(health>=1) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart left.png"));
		self:addChild(heart)
		self.heartX = self.heartX + 11
		table.insert(self.hearts, heart)
	end
		
	if(health>=2) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart right.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=3) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart left.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=4) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart right.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=5) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart left.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=6) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart right.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=7) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart left.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=8) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart right.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end
	
	if(health>=9) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart left.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end

	if(health>=10) then
		local heart = Bitmap.new(self.scene.atlas[2]:getTextureRegion("half heart right.png"));
		self:addChild(heart)
		heart:setX(self.heartX)
		self.heartX = self.heartX +11
		table.insert(self.hearts, heart)
	end
	
	

end