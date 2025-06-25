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

Game = Core.class(Sprite)

function Game:init()
	local bg = Bitmap.new(Texture.new("res/i_game.jpg", true))
	local scale = application:getContentWidth() / bg:getWidth() * 1.1
	bg:setScale(scale)
	bg:setPosition(0, 0)
	self:addChild(bg)

	self.player = Player.new()
	self.player:setPosition(application:getContentWidth() / 2, 260)
	self:addChild(self.player)

	for i = 1, 8 do
		self:addNewBlade()
	end

	self.seconds = 0
	self.timer = Timer.new(100, 0)
	self.timer:addEventListener(Event.TIMER, function()
		self:timeTick()
	end)
	self.timer:start()

	self.scoreField = TextField.new(g_font, g_convertToBurmeseNumber(self.seconds))
	self.scoreField:setX(application:getContentWidth() - self.scoreField:getWidth() - 25)
	self.scoreField:setY(50)
	self.scoreField:setTextColor(0xffffff)
	self:addChild(self.scoreField)

	self:addEventListener(Event.MOUSE_UP, self.onMouseRelease, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseTouch, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseTouch, self)
end

function Game:addNewBlade()
	local blade = Blade.new()
	self:addChild(blade)
	blade:addEventListener(Event.ENTER_FRAME, function()
		local bladeWidthHalf = blade:getWidth() / 2
		local bladeHeightHalf = blade:getHeight() / 2
		if (self.player:hitTestPoint(blade:getX() - bladeWidthHalf, blade:getY() - bladeHeightHalf)
			or self.player:hitTestPoint(blade:getX() - bladeWidthHalf, blade:getY() + bladeHeightHalf)
			or self.player:hitTestPoint(blade:getX() + bladeWidthHalf, blade:getY() - bladeHeightHalf)
			or self.player:hitTestPoint(blade:getX() + bladeWidthHalf, blade:getY() + bladeHeightHalf)
			or self.player:hitTestPoint(blade:getX(), blade:getY())
			) then
			self.timer:stop()
			g_sceneManager:changeScene("GameOver", 0, SceneManager.fade, easing.inOutQuadratic, {userData = self.seconds})
		end
	end, self)
end

function Game:timeTick()
	self.seconds = self.seconds + 0.1
	self.scoreField:setText(g_convertToBurmeseNumber(string.format("%0.1f", self.seconds)))
	self.scoreField:setX(application:getContentWidth() - self.scoreField:getWidth() - 25)
end

function Game:onMouseTouch(event)
	if (event.x > self.player:getX()) then
		self.player:moveRight()
	else
		self.player:moveLeft()
	end
end

function Game:onMouseRelease(event)
	self.player:stay()
end
