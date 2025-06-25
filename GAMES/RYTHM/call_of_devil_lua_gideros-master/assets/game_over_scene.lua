GameOverScene = GameOverScene or Core.class(Sprite)

function GameOverScene:init(options)

	self.isSoundEnabled = options and options.isSoundEnabled or true
	self.isHardMode = options and options.isHardMode or true

	local bg = Bitmap.new(Texture.new("assets/images/bg_game_over_scene.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setScale(conf.WIDTH / bg:getWidth() * 1.2, 1)
	bg:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT)
	
	local retry_button_texture = Bitmap.new(Texture.new("assets/images/retry_button.png"))
	retry_button_texture:setAnchorPoint(0.5, 0.5)
	
	local retry_button_scale = conf.WIDTH / 2 / retry_button_texture:getWidth()
	
	retry_button_texture:setScale(retry_button_scale, retry_button_scale)
		
	local retry_button = Button.new(retry_button_texture, retry_button_texture)
	retry_button:setPosition(conf.MID_WIDTH, conf.HEIGHT * 2 / 3)
	
	retry_button:addEventListener("click", 
		function() 
			sceneManager:changeScene("menu_scene", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
				userData = {
					isSoundEnabled 	= self.isSoundEnabled,
					isHardMode 		= self.isHardMode,
				}
			})
		end)
		

	self:addChild(bg)
	self:addChild(retry_button)

end

