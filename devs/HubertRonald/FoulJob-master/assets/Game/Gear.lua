
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




local Gear = Core.class(Sprite)

function Gear:init(config)
	
	-- setup info
	-- reference tile map
	self.conf = {
		
		scaleX = 1,
		scaleY = 1,
		alpha = .6,
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
		
		name="platformIndustrial_067.png",
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
	self.conf.name= string.len(self.conf.name)>0 and self.conf.name or "platformIndustrial_067.png"
	
	local pack = TexturePack.new(self.conf.dir.."txt", self.conf.dir.."png", true)
	--self.Gear = Bitmap.new(pack:getTextureRegion(self.conf.name))
	self.Gear = Bitmap.new(Texture.new("Canvas/Worlds/platformIndustrial_067.png",true))
	self.Gear:setAnchorPoint(self.conf.anchorX, self.conf.anchorY)
	
	
	self.Gear:set("scaleX",self.conf.scaleX); self.Gear:set("scaleY",self.conf.scaleY)
	self.conf.radius=self.Gear:getWidth()/2
	self.Gear:setAlpha(self.conf.alpha)
	self.Gear:setVisible(self.conf.visible)
	self.Gear.id = self.conf.id	--after you create self.Gear (It's a table)
	
	
	self:addChild(self.Gear)
	self:start()
end


function Gear:changeAngVel(w) self.conf.sw = self.conf.sw or w end

function Gear:onframe(e) self.Gear:setRotation(self.Gear:getRotation()+self.conf.sw) end
function Gear:start() self:addEventListener(Event.ENTER_FRAME, self.onframe, self) end
function Gear:stop() self:removeEventListener(Event.ENTER_FRAME, self.onframe, self) end



return Gear