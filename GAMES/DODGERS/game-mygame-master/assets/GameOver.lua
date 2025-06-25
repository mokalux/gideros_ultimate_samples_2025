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

GameOver = Core.class(Sprite)

function GameOver:init(score)
	local bg = Bitmap.new(Texture.new("res/i_game.jpg", true))
	local scale = application:getContentWidth() / bg:getWidth() * 1.1
	bg:setScale(scale)
	bg:setPosition(0, 0)
	self:addChild(bg)

	local gameOverText = Bitmap.new(g_sprites:getTextureRegion("i_text_gameover.png"))
	gameOverText:setScale(200 / gameOverText:getWidth())
	gameOverText:setPosition(application:getContentWidth() / 2 - gameOverText:getWidth() / 2,
							application:getContentHeight() / 2 - gameOverText:getHeight() * 2)
	self:addChild(gameOverText)

	local scoreField = TextField.new(g_font, g_convertToBurmeseNumber(string.format("%0.1f", score)))
	scoreField:setX(application:getContentWidth() / 2 - scoreField:getWidth() / 2)
	scoreField:setY(gameOverText:getY() + gameOverText:getHeight() + 30)
	scoreField:setTextColor(0xffffff)
	self:addChild(scoreField)

	local playBtn = Button.new(Bitmap.new(Texture.new("res/i_play_btn_normal.png")),
							Bitmap.new(Texture.new("res/i_play_btn_pressed.png")))
	playBtn.isClicked = false
	playBtn:addEventListener("click", function()
		if (not playBtn.isClicked) then
			playBtn.isClicked = true
			g_sceneManager:changeScene("Game", 0, SceneManager.fade, easing.inOutQuadratic)
		end
	end, playBtn)
	playBtn:setScale(0.7)
	playBtn:setX(application:getContentWidth() / 2 - playBtn:getWidth() / 2)
	playBtn:setY(scoreField:getY() + scoreField:getHeight() + 10)
	self:addChild(playBtn)
end