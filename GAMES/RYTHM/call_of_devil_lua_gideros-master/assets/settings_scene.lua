SettingsScene = SettingsScene or Core.class(Sprite)

function SettingsScene:init() 

	local bg = Bitmap.new(Texture.new("assets/images/bg_settings_scene.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setScale(conf.WIDTH / bg:getWidth() * 1.2, 1)
	bg:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT)
	
	
	self:addChild(bg)

end