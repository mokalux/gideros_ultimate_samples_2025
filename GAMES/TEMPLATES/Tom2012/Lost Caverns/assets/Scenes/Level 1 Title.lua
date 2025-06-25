level1Title = Core.class(Sprite)
function level1Title:init()

	print("Level 1 Title here")
	
	Timer.delayedCall(600, self.changeLevel, self)

end







function level1Title:changeLevel()

	sceneManager:changeScene("Level 1", 0, SceneManager.flipWithFade, easing.outBack)
	
	local signText = BMTextField.new(self.scene.signTextFont, self.text, 300*self.scene.deviceScale, "center")
	signText:setScale(self.scene.scalex, self.scene.scaley)
	self.signSprite:addChild(signText)
	self.signText = signText

end


