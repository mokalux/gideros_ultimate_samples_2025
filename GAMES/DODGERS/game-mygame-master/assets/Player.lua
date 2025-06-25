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

Player = Core.class(Sprite)
Player.VELOCITY = 3

function Player:init()
	self.velocity = 0
	self.targetX = 0
	self.frames = 5
	self.movieClip = MovieClip.new{
		-- front
		{ self.frames * 0 + 1, self.frames * 1, Bitmap.new(g_sprites:getTextureRegion("i_player_front_1.png")) },
		{ self.frames * 1 + 1, self.frames * 2, Bitmap.new(g_sprites:getTextureRegion("i_player_front_2.png")) },
		{ self.frames * 2 + 1, self.frames * 3, Bitmap.new(g_sprites:getTextureRegion("i_player_front_3.png")) },
		{ self.frames * 3 + 1, self.frames * 4, Bitmap.new(g_sprites:getTextureRegion("i_player_front_4.png")) },

		{ self.frames * 4 + 1, self.frames * 5, Bitmap.new(g_sprites:getTextureRegion("i_player_left_1.png")) },
		{ self.frames * 5 + 1, self.frames * 6, Bitmap.new(g_sprites:getTextureRegion("i_player_left_2.png")) },
		{ self.frames * 6 + 1, self.frames * 7, Bitmap.new(g_sprites:getTextureRegion("i_player_left_3.png")) },
		{ self.frames * 7 + 1, self.frames * 8, Bitmap.new(g_sprites:getTextureRegion("i_player_left_4.png")) },

		{ self.frames * 8 + 1, self.frames * 9, Bitmap.new(g_sprites:getTextureRegion("i_player_right_1.png")) },
		{ self.frames * 9 + 1, self.frames * 10, Bitmap.new(g_sprites:getTextureRegion("i_player_right_2.png")) },
		{ self.frames * 10 + 1, self.frames * 11, Bitmap.new(g_sprites:getTextureRegion("i_player_right_3.png")) },
		{ self.frames * 11 + 1, self.frames * 12, Bitmap.new(g_sprites:getTextureRegion("i_player_right_4.png")) },
	}
	self.movieClip:setGotoAction(4, 1)
	self.movieClip:setGotoAction(self.frames * 4, self.frames * 0 + 1)
	self.movieClip:setGotoAction(self.frames * 8, self.frames * 4 + 1)
	self.movieClip:setGotoAction(self.frames * 12, self.frames * 8 + 1)
	self:addChild(self.movieClip)
	self.movieClip:play()
	self.movieClip:setPosition(-self.movieClip:getWidth()/2, -self.movieClip:getHeight()/2)

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Player:onEnterFrame(event)
	if (self:getX() + self.velocity <= application:getContentWidth() and self:getX() + self.velocity >= 0) then
		self:setX(self:getX() + self.velocity)
	end
end

function Player:moveLeft()
	if (self.velocity >= 0) then
		self.velocity = -Player.VELOCITY
		self.movieClip:gotoAndPlay(self.frames * 4 + 1)
	end
end

function Player:moveRight()
	if (self.velocity <= 0) then
		self.velocity = Player.VELOCITY
		self.movieClip:gotoAndPlay(self.frames * 8 + 1)
	end
end

function Player:stay()
	self.velocity = 0
	self.movieClip:gotoAndPlay(self.frames * 3 + 1)
end