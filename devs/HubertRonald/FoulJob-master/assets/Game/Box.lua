
--[[

	---------------------------------------------
	Fool Job
	a game by hubert ronald
	---------------------------------------------
	a game of liquid puzzle
	Gideros SDK Power and Lua coding.

	Artwork: Kenney Game Assets
			Platform Pack Industrial
			http://kenney.nl/assets/platformer-pack-industrial
	
	Design & Coded
	by Hubert Ronald
	contact: hubert.ronald@gmail.com
	Development Studio: [-] Liasoft
	Date: Aug 26th, 2017
	
	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator

	The MIT License (MIT)
	
	Copyright (C) 2017 Hubert Ronald

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	
	---------------------------------------------
	FILE: BOX
	---------------------------------------------
	
--]]




local Box = Core.class(Sprite)

function Box:init(config)
	
	-- setup info
	-- reference tile map
	self.conf = {
		
		scaleX = 1,
		scaleY = 1,
		alpha = 1,
		x=0,
		y=0,
		
		anchorX = 0.5,
		anchorY = 0.5,
		
		shape="circle",
		type="canvas",
		radius=32,
		height = 64,
		width = 64,
		
		sw=.5,		--	angular velocity
		id=1,
		visible=true,
		
		name="platformIndustrial_072.png",
		dir="Canvas/Worlds/platformIndustrial_sheet.",
		
		rotation=0,
		properties={},	

	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key] = value
		end
	end
	self:setPosition(self.conf.x+self.conf.radius, self.conf.y+self.conf.radius)
	
	--because name is "" on tilemap
	self.conf.name= string.len(self.conf.name)>0 and self.conf.name or "platformIndustrial_072.png"
	
	local pack = TexturePack.new(self.conf.dir.."txt", self.conf.dir.."png", true)
	--self.Box = Bitmap.new(pack:getTextureRegion(self.conf.name))
	self.Box = Bitmap.new(Texture.new("Canvas/Worlds/platformIndustrial_072.png",true))
	self.Box:setAnchorPoint(self.conf.anchorX, self.conf.anchorY)
	
	
	self.Box:set("scaleX",self.conf.scaleX); self.Box:set("scaleY",self.conf.scaleY)
	self.conf.radius=self.Box:getWidth()/2
	self.conf.width=self.Box:getWidth()/2
	self.conf.height=self.Box:getHeight()/2
	self.Box:setAlpha(self.conf.alpha)
	self.Box:setVisible(self.conf.visible)
	self.Box.id = self.conf.id	--after you create self.Box (It's a table)
	
	self:addChild(self.Box)
	self.isFocus = false
	self:start()
end
--if you use with box2d function bellow don't work, you need create a new event
--doesn't work with touch
function Box:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.isFocus = true
		self.x0, self.y0 = event.x, event.y
		--============
		self:dispatchEvent(Event.new("jointDown"))
		--============
		event:stopPropagation()
	end
end
--
function Box:onMouseMove(event)
	if self.isFocus then
		self.dx = event.x - self.x0
		self.dy = event.y - self.y0

		self:setX(self:getX() + self.dx)
		self:setY(self:getY() + self.dy)

		self.x0, self.y0 = event.x, event.y
		--============
		self:dispatchEvent(Event.new("jointMove"))
		--============
		event:stopPropagation()
	end
end

--check this post
--http://giderosmobile.com/forum/discussion/7064/event-dispatcher-causes-memory-leak#Item_3
function Box:onMouseUp(event)
	if self.isFocus then
		self.isFocus = false
		self:dispatchEvent(Event.new("jointUp"))
		-------------------
		collectgarbage()	--<--	only here because collectgabage can affect performance of your applications
		-------------------
		event:stopPropagation()
	end
end

--touches doesn't work in physic object dragabble
--[[
function Box:onTouchesCancel(event)
	if self.focus then
		self.focus = false
		self:dispatchEvent(Event.new("jointUp"))
		event:stopPropagation()
	end
end
]]

function Box:changeAngVel(w) self.conf.sw = self.conf.sw or w end


function Box:start()
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)


end
function Box:stop()
	
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)

end



return Box