local Ring = Core.class(Sprite)

Ring.TYPES_COUNT  = 4
Ring.STATES_COUNT = 4
Ring.TYPE_RADIUS = {
	64.5,
	48.5,
	35,
	24
}

local MORPH_TIME = 1
local TRANSITION_TIME = 0.5


function Ring:init(ringType, state)
	self.type  = utils.setDefaultIfNil(ringType, 1)
	self.state = utils.setDefaultIfNil(state, 1)

	-- load all possible states for ring 
	-- TODO: make all static
	self.textures = { } -- state, type(radius)
	for i = 1, Ring.STATES_COUNT do
		local typeTextures = {}
		for j = 1, Ring.TYPES_COUNT do
			local texturePath = "assets/rings/" .. tostring(i) .. "/" .. tostring(j) .. ".png"		
			typeTextures[j] = Texture.new(texturePath, false)
		end
		self.textures[i] = typeTextures
	end

	self.primaryBmp = Bitmap.new(self.textures[self.state][self.type])
	self:addChild(self.primaryBmp)
	self.primaryBmp:setAnchorPoint(0.5, 0.5)
	self.radius = Ring.TYPE_RADIUS[self.type]
	-- transitions
	self.isTransitioning = false
	self.currentTransitionTime = 0
	-- size changes
	self.isMorphing = false
	self.morphDir = 0
	self.currentMorphTime = 0
end

function Ring:swapState(newState)
	-- possible error when in constructor given wrong state
	if self.isTransitioning then 
		return false
	end
	newState = utils.setDefaultIfNil(newState, self.state)
	if (newState > Ring.STATES_COUNT) or (newState < 1) then 
		newState = self.state
	end
	if newState == self.state then
		return true
	end
	-- add new bmp with new state ang with zero alpha
	self.secondaryBmp = Bitmap.new(self.textures[newState][self.type])
	self.secondaryBmp:setAlpha(0)
	self.secondaryBmp:setAnchorPoint(0.5, 0.5)
	self:addChild(self.secondaryBmp)
	-- start transition
	self.isTransitioning = true
	self.state = newState
	self.currentTransitionTime = 0	
	
	return true
end

function Ring:swapType(newType)
	newType = utils.setDefaultIfNil(newType, self.type)
	if (newType > Ring.TYPES_COUNT) or (newType < 1) then 
		newType = self.type
	end
	if newType == self.type then 
		return true
	end
	-- add new scaled bmp
	return true
end

function Ring:update(deltaTime)
	if self.isTransitioning and (not self.isMorphing) then 
		if self.currentTransitionTime >= TRANSITION_TIME then
			self.isTransitioning = false
			self.primaryBmp, self.secondaryBmp = self.secondaryBmp, self.primaryBmp
			self:removeChild(self.secondaryBmp)
			self.currentTransitionTime = 0;
		else 
			local newSecondaryAlpha = self.currentTransitionTime / TRANSITION_TIME
			self.primaryBmp:setAlpha(1 - newSecondaryAlpha)
			self.secondaryBmp:setAlpha(newSecondaryAlpha)
			self.currentTransitionTime = self.currentTransitionTime + deltaTime
		end
	end
	local isInversed = (self.type % 2 == 0) and 1 or (-1)
	self:setRotation(self:getRotation() + deltaTime * self.type * isInversed * self.state)
end

return Ring