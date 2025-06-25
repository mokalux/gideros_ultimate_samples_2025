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

application:setKeepAwake(true)
--application:setOrientation(Application.LANDSCAPE_RIGHT)

--g_font = TTFont.new("res/f_zawgyi_one.ttf", 30, nil, true) -- (filename, size, text, filtering, outlineSize)
g_font = TTFont.new("res/f_zawgyi_one.ttf", 30) -- (filename, size, text, filtering, outlineSize)
g_sprites = TexturePack.new("res/i_sprites.txt", "res/i_sprites.png", true)
g_themeSound = Sound.new("res/m_theme.mp3")
g_gameOverSound = Sound.new("res/s_game_over.wav")

g_sceneManager = SceneManager.new({
	["Game"] = Game,
	["GameOver"] = GameOver
})

stage:addChild(g_sceneManager)
g_sceneManager:changeScene("Game", 0, SceneManager.fade, easing.inOutQuadratic)
