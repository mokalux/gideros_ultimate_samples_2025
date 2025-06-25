--[[
This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 
--]]

Bird = Core.class(Sprite)

function Bird:init(frameList)
	-- create a Bitmap for each frame
	self.frames = {}
	for i = 1, #frameList do
		local bird={
			type="mesh",
			vertices={0,0,0,1,0,0,1,1,0,0,1,0},
			indices={1,2,3,1,3,4},
			texcoords={0,0,1,0,1,1,0,1},
			normals={0,0,-1,0,0,-1,0,0,-1,0,0,-1},
			material="bird"
		}
		local birdmtl={
			bird = {
				textureFile=frameList[i]..".png",
				normalMapFile=frameList[i].."_n.png"
			}
		}
		
		self.frames[i] = G3DFormat.buildG3D(bird,birdmtl)
		Lighting.apply(self.frames[i])
		self.frames[i]:setAnchorPoint(0,0.5)
		self.frames[i]:setScale(100,41)
	end

	self.nframes = #frameList

	-- add first Bitmap as a child
	self.frame = 1
	self:addChild(self.frames[1])
	
	-- subframe is used to adjust the speed of animation
	self.subframe = 0

	-- set initial position
	self:setPosition(540, math.random(160) + 40, 0)

	-- set the speed of the bird
	self.speedy = math.random(-500, 500) / 2000
	self.speedx = math.random(2000, 4000) / 1000
	self.speedz = 0
	
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
end

function Bird:onEnterFrame()
	self.subframe = self.subframe + 1
	
	-- for every 10 frames, we remove the old frame and add the new frame as a child
	if self.subframe > 40 then
		self:removeChild(self.frames[self.frame])

		self.frame = self.frame + 1
		if self.frame > self.nframes then
			self.frame = 1
		end

		self:addChild(self.frames[self.frame])

		self.subframe = 0
	end
	
	-- get the current position
	local x,y,z = self:getPosition()
		
	-- change the position according to the speed
	x = x - self.speedx
	y = y + self.speedy
	z = z + self.speedz

	-- if the bird is out of the screen, set new speed and position
	if x < -100 then 
		self.speedy = math.random(-500, 500) / 2000
		self.speedx = math.random(2000, 4000) / 1000
		self.speedz = 0.001
		x = 540
		y = math.random(160) + 40
		z = 0
	end

	-- set the new position
	self:setPosition(x, y, z)
end
