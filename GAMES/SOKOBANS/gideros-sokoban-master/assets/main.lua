--application:setScaleMode("pixelPerfect")
--application:setOrientation(Application.LANDSCAPE_LEFT)

local FontName = "calibrib.ttf"
local CurrentColor = 0x000000;

function setColor(color)
	CurrentColor = color
end

function Sprite:addText(text, x, y, scale) 
	local fsize = 20
	
	if scale == nil then 
		fsize = fsize
	else
		fsize = fsize * scale 
	end
	
	local font = TTFont.new(FontName, fsize)
	tf = TextField.new(font, text)
	tf:setPosition(x, y)
	tf:setTextColor(CurrentColor)
	self:addChild(tf)
	return tf
end

local sceneManager = SceneManager.new({
	["scene1"] = sceneInGame
})
local scenes = { "scene1", "scene2", "scene3" }

stage:addChild(sceneManager)
sceneManager:changeScene("scene1")