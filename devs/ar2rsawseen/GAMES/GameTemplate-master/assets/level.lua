--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--

level = gideros.class(Sprite)

function level:init()
	--get current pack
	local curPack = sets:get("curPack")
	print("curPack", curPack)
	local curLevel = sets:get("curLevel")
	print("curLevel", curLevel)

	-- key handler
	self:myKeyPressed()
end

function level:onEnterFrame() 
end

--removing event on exiting scene
function level:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function level:myKeyPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.ESC or e.keyCode == KeyCode.BACK then
			sceneManager:changeScene("level_select", 1, conf.transition, conf.easing) 
		end
	end)
end
