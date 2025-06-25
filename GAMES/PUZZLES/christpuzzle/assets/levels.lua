levels = gideros.class(Sprite)

function levels:init()
	back = Bitmap.new(Texture.new("img/back.jpg"))
	back:setScaleX(application:getContentWidth()/1024)
	back:setScaleY(application:getContentHeight()/768)
	self:addChild(back)
self.box0 = Button.new(Bitmap.new(Texture.new("img/start.png")), Bitmap.new(Texture.new("img/start.png")))
		self.box0:setPosition(application:getContentWidth()/2-self.box0:getWidth()/2,self.box0:getHeight())
	--	self.box0:setScale(0.67,0.67)
		self:addChild(self.box0)
		
				self.box0:addEventListener("click", 
		function()
		sceneManager:changeScene("puzzle", 1, SceneManager.overFromBottomWithFade, easing.outBack)
	
		end)
		self:addEventListener(Event.KEY_UP, self.onKeyUp, self)
end


function levels:onKeyUp(event)
	if event.keyCode == KeyCode.BACK then
	--self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		application:exit()
		
		
	end
end