--local myPack = TexturePack.new({"ui/soundon.png","ui/sound off.png","ui/setting screen.png","ui/play.png"})
dx = application:getLogicalTranslateX() / application:getLogicalScaleX()
dy = application:getLogicalTranslateY() / application:getLogicalScaleY()

--Use following points for screen resolutionßß
x0=-dx
y0=-dy
screenW=application:getContentWidth()
screenH=application:getContentHeight()


sceneManager = SceneManager.new({
	
	["level1"] = level1,

})
stage:addChild(sceneManager)


sceneManager:changeScene("level1", 1, SceneManager.fade, easing.linear)

