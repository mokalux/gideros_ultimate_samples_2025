LevelScene = LevelScene or Core.class(Sprite)

function LevelScene:init(options)

	self.level_height 	= conf.HEIGHT
	self.level_width 	= conf.WIDTH
	
	self.paused 		= false
	
	self.isSoundEnabled = options and options.isSoundEnabled or true
	self.isHardMode 	= options and options.isHardMode or true
	

	self.background = Background.new {
		level = self,
	}
		
	self.pentagram = Pentagram.new {
		level = self,
	}
	
	self.score = Score.new {
		level = self,
		count = 0,
	}
	
	self.moon = Moon.new {
		level = self,
	}
	
	self.devil = Devil.new {
		level = self,
		isSoundEnabled = self.isSoundEnabled,
		isHardMode = self.isHardMode,
	}
	
	self.items = Items.new {
		level = self,
	}
	
	self.rain = Rain.new {
		level = self,
	}
	
	self.round_timer = Timer.new(1000, conf.ROUND_TIME)
	
	if self.isSoundEnabled then 
		local gametune = Sound.new("assets/sounds/gametune.mp3")
		self.channel = gametune:play()
	end
	
	
	self.round_timer:start()
	
	self:addChild(self.moon)
	self:addChild(self.background)
	self:addChild(self.pentagram)
	self:addChild(self.rain)
	self:addChild(self.items)
	self:addChild(self.devil)
	self:addChild(self.score)
	
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("TAP_ITEM", self.onTapItem, self)
	self.round_timer:addEventListener(Event.TIMER_COMPLETE, self.onRoundEnd, self)

end


function LevelScene:onEnterFrame()
	
end

function LevelScene:onTapItem(event)

	event:stopPropagation()
    
    if not self.paused then
        
		self.pentagram:changeDoorStatus(self.devil.devil_mc:getY(), conf.HEIGHT - self.devil.devil_height/2)

		self.score:dispatchEvent(Event.new("INCREMENT_SCORE"))
		
		self.devil:dispatchEvent(Event.new("CALL_DEVIL"))
		
    end
end


function LevelScene:onKeyDown(event)
	event:stopPropagation()
    if event.keyCode == KeyCode.BACK then 
        if application:getDeviceInfo() == "Android" then
			self.devil.timer:stop()
			self.round_timer:stop()
			if self.channel  then 
				self.channel :stop()
			end
            sceneManager:changeScene("menu_scene", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
				userData = {
					isSoundEnabled 	= self.isSoundEnabled,
					isHardMode 		= self.isHardMode,
				}
			})
        end
    end
end

function LevelScene:onRoundEnd()
	self.devil.timer:stop()
	if self.channel  then 
		self.channel:stop()
	end
	sceneManager:changeScene("game_over_scene", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
		userData = {
			isSoundEnabled 	= self.isSoundEnabled,
			isHardMode 		= self.isHardMode,
		}
	})
end

