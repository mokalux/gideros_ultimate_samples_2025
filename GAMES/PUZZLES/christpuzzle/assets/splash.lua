splash= gideros.class(Sprite)

function splash:init( pageNo, parent)
splash=Bitmap.new(Texture.new("img/logo.png"))
self:addChild(splash)
splash:setScaleX(0.1)
splash:setScaleY(0.1)
splashscale=0.1
splash:setPosition(application:getContentWidth()/6, application:getContentHeight()/3)
timer = Timer.new(500, 1)
function onTimer(e)
sceneManager:changeScene("levels", 1, SceneManager.overFromBottomWithFade, easing.outBack)
--sceneManager:changeScene(nextScene())
self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
--self:removeEventListener(Event.ADDED_TO_STAGE, elf.onAddedToStage, self)
end
	self:addEventListener("enterFrame", self.onEnterFrame, self)
self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)	
end

function splash:onAddedToStage()
	-- we need mouse functions to interact with the toy
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	timer:addEventListener(Event.TIMER, onTimer)
	timer:start()
end

function splash:onMouseDown(event)

end
function splash:onEnterFrame(event)
splashscale=splashscale+0.1
splash:setScale(splashscale/10)
end