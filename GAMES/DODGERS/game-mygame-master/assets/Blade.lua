--[[
   Copyright 2014 MySQUAR

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]--

Blade = Core.class(Sprite)

function Blade:init()
	local img = Bitmap.new(g_sprites:getTextureRegion("i_sword_" .. math.random(3) .. ".png"))
	img:setAnchorPoint(0.5, 0.5)
	self:respawn()
	self:addChild(img)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Blade:onEnterFrame(event)
	self:setY(self:getY() + self.velocity)
	if (self:getY() > application:getContentHeight()) then
		self:respawn()
	end
end

function Blade:respawn()
--	self.velocity = 1 + math.random(6)
	self.velocity = math.random(3)
	self:setPosition(math.random(application:getContentWidth()), 0)
end
