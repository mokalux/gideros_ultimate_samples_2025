--[[
*************************************************************
* Lightning object draws a randomly generated lightning with glow effect 
* from x and y coordinates, to other x and y coordinates.
* You can also specify lightning bolt color, width, lightning glow color, 
* width, detalization level and displacement offsets

* Adapted from:
* https://bitbucket.org/ndoss/box2djsontolua/src/d65d04ffab3f/lightning
*
* For more information, examples and online documentation visit: 
* http://appcodingeasy.com/Gideros-Mobile/Gideros-lightning-effect
**************************************************************
]]--


Lightning = gideros.class(Shape)

--initialize
function Lightning:init(config)
	-- Settings to control the lightning
	self.conf = {
		curDetail = 1,
		displace  = 100,
		boltWidth = 3,
		boltColor = 0xffff88,
		glow = true,
		glowWidth = 20,
		glowColor = 0xffffff,
		glowAlpha = 0.05
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	self:setVisible(false)
end

-- Draw lightning
function Lightning:drawLightning(x1, y1, x2, y2, displace)
   if displace < self.conf.curDetail then
		if self.conf.glow then
			--glow around lightning
			self:beginPath()
			self:setLineStyle(self.conf.glowWidth, self.conf.glowColor, self.conf.glowAlpha)
			self:moveTo(x1,y1)
			self:lineTo(x2,y2)
			self:endPath()
		end

		--bolt itself
		self:setLineStyle(self.conf.boltWidth, self.conf.boltColor, 1)
		self:moveTo(x1,y1)
		self:lineTo(x2,y2)
		self:endPath()
   else
		local midx = (x2+x1)/2
		local midy = (y2+y1)/2
		midx = midx + (math.random(0, 1) - 0.5)*displace
		midy = midy + (math.random(0, 1) - 0.5)*displace
		self:drawLightning(x1, y1, midx, midy, displace/2)
		self:drawLightning(x2, y2, midx, midy, displace/2)
   end
end

--show lightning
function Lightning:show(startX, startY, endX, endY)
	self:setVisible(true)
	self:drawLightning(startX, startY, endX, endY, self.conf.displace)
end

-- hide lightning
function Lightning:hide()
	self:clear()
	self:setVisible(false)
end