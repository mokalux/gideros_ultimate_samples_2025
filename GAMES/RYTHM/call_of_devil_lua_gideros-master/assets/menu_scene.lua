MenuScene = MenuScene or Core.class(Sprite)

function MenuScene:init(options)

	self.isSoundEnabled = options and options.isSoundEnabled or true
	self.isHardMode = options and options.isHardMode or true

	local bg = Bitmap.new(Texture.new("assets/images/bg_menu_scene.png"))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setScale(conf.WIDTH / bg:getWidth() * 1.2, 1)
	bg:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT)
	
	local start_button_texture = Bitmap.new(Texture.new("assets/images/menu_button_start.png"))
	start_button_texture:setAnchorPoint(0.5, 0.5)
	
	local start_button_scale = conf.PLAY_BUTTON_SCALE / start_button_texture:getHeight()
	start_button_texture:setScale(start_button_scale, start_button_scale)
		
	local start_button = Button.new(start_button_texture, start_button_texture)
	start_button:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT + start_button_texture:getHeight() / 2)
	
	start_button:addEventListener("click", 
		function() 
			sceneManager:changeScene("level_scene", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
				userData = {
					isSoundEnabled 	= self.isSoundEnabled,
					isHardMode 		= self.isHardMode,
				}
			})
		end)
		
	local game_mode_texture = Texture.new("assets/images/settings_button.png")
	self.game_mode_texture_easy = Bitmap.new(TextureRegion.new(game_mode_texture, 0, 0, 70, 40))
	self.game_mode_texture_hard = Bitmap.new(TextureRegion.new(game_mode_texture, 70, 0, 70, 40))
	
	self.game_mode_texture_easy:setAnchorPoint(0.5, 0.5)
	self.game_mode_texture_hard:setAnchorPoint(0.5, 0.5)
	
	local game_mode_scale = 1
	
	self.game_mode_texture_easy:setScale(game_mode_scale, game_mode_scale)
	self.game_mode_texture_hard:setScale(game_mode_scale, game_mode_scale)
		
	self.game_mode_button = ButtonSimple.new(self.game_mode_texture_easy)
	self.game_mode_button:setPosition(conf.MID_WIDTH, conf.MID_HEIGHT * 3 / 2)
	
	self.game_mode_button:addEventListener("click", function() 
        if self.isHardMode then
            self.isHardMode = false
            self.game_mode_button:removeChild(self.game_mode_button.sprite)
            self.game_mode_button.sprite = self.game_mode_texture_easy
            self.game_mode_button:addChild(self.game_mode_texture_easy)
        else
            self.isHardMode = true
            self.game_mode_button:removeChild(self.game_mode_button.sprite)
            self.game_mode_button.sprite = self.game_mode_texture_hard
            self.game_mode_button:addChild(self.game_mode_texture_hard)
        end
    end)
	
	local github = Bitmap.new(Texture.new("assets/images/github-icon.png"))
    github:setAnchorPoint(0.5, 0.5)
	
    local github_scale = conf.BUTTON_GITHUB_SCALE / github:getWidth()
    github:setScale(github_scale, github_scale)
    
    local github_button = ButtonSimple.new(github)
    github_button:setPosition(conf.WIDTH - github:getWidth() / 2, conf.HEIGHT - conf.MENU_BUTTON_BOTTOM_OFFSET)
   	
	
	self.on = Bitmap.new(Texture.new("assets/images/sound_on.png"))
    self.on:setAnchorPoint(0.5, 0.5)
	
    local sound_on_off_scale = conf.SOUND_ON_OFF_SCALE / self.on:getWidth()
    
    self.on:setScale(sound_on_off_scale, sound_on_off_scale)
    
    self.off = Bitmap.new(Texture.new("assets/images/sound_off.png"))
    self.off:setAnchorPoint(0.5, 0.5)
    self.off:setScale(sound_on_off_scale, sound_on_off_scale)
    
    self.sound_button = nil 
    if self.isSoundEnabled then
        self.sound_button = ButtonSimple.new(self.on)
    else
        self.sound_button = ButtonSimple.new(self.off)
    end
    
    self.sound_button:setPosition(self.on:getWidth() / 2, conf.HEIGHT - conf.MENU_BUTTON_BOTTOM_OFFSET)
    
    self.sound_button:addEventListener("click", function() 
        if self.isSoundEnabled then
            self.isSoundEnabled = false
            self.sound_button:removeChild(self.sound_button.sprite)
            self.sound_button.sprite = self.off
            self.sound_button:addChild(self.off)
        else
            self.isSoundEnabled = true
            self.sound_button:removeChild(self.sound_button.sprite)
            self.sound_button.sprite = self.on
            self.sound_button:addChild(self.on)
        end
    end)

	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	github_button:addEventListener("click", self.onClickedGitHubButton, self)
	
	self:addChild(bg)
	self:addChild(start_button)
	self:addChild(github_button)
	--self:addChild(self.game_mode_button)
	self:addChild(self.sound_button)

end


function MenuScene:onKeyDown(event)
    if event.keyCode == KeyCode.BACK then 
        if application:getDeviceInfo() == "Android" then
            application:exit()
        end
    end
end

function MenuScene:onClickedGitHubButton(event)
    event:stopPropagation()
    if application:getDeviceInfo() == "Android" then
        application:openUrl("http://github.com/ar0ne/" .. conf.GITHUB_REPOSITORY)   
    end
end

