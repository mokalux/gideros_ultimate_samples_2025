 

SceneManager = Core.class(Sprite)

function SceneManager.moveFromRight(scene1, scene2, t)
	local width = application:getContentWidth()
	
	scene1:setX(-t * width)
	scene2:setX((1 - t) * width)
end

function SceneManager.moveFromLeft(scene1, scene2, t)
	local width = application:getContentWidth()

	scene1:setX(t * width)
	scene2:setX((t - 1) * width)
end

function SceneManager.changeWithoutAnim(scene1, scene2, t)
	t=0
	local width = application:getContentWidth()

	scene1:setX(t * width)
	scene2:setX(0)
end

function SceneManager.overFromRight(scene1, scene2, t)
	local width = application:getContentWidth()

	scene2:setX((1 - t) * width)
end

function SceneManager.overFromLeft(scene1, scene2, t)
	local width = application:getContentWidth()

	scene2:setX((t - 1) * width)
end

function SceneManager.moveFromRightWithFade(scene1, scene2, t)
	local width = application:getContentWidth()

	scene1:setAlpha(1 - t)
	scene1:setX(-t * width)
	scene2:setX((1 - t) * width)
end

function SceneManager.moveFromLeftWithFade(scene1, scene2, t)
	local width = application:getContentWidth()

	scene1:setAlpha(1 - t)
	scene1:setX(t * width)
	scene2:setX((t - 1) * width)
end

function SceneManager.overFromRightWithFade(scene1, scene2, t)
	local width = application:getContentWidth()

	scene1:setAlpha(1 - t)
	scene2:setX((1 - t) * width)
end

function SceneManager.overFromLeftWithFade(scene1, scene2, t)
	local width = application:getContentWidth()

	scene1:setAlpha(1 - t)
	scene2:setX((t - 1) * width)
end

function SceneManager.moveFromBottom(scene1, scene2, t)
	local height = application:getContentHeight()
	
	scene1:setY(-t * height)
	scene2:setY((1 - t) * height)
end

function SceneManager.moveFromTop(scene1, scene2, t)
	local height = application:getContentHeight()

	scene1:setY(t * height)
	scene2:setY((t - 1) * height)
end

function SceneManager.overFromBottom(scene1, scene2, t)
	local height = application:getContentHeight()
	
	scene2:setY((1 - t) * height)
end

function SceneManager.overFromTop(scene1, scene2, t)
	local height = application:getContentHeight()

	scene2:setY((t - 1) * height)
end

function SceneManager.moveFromBottomWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
	
	scene1:setAlpha(1 - t)
	scene1:setY(-t * height)
	scene2:setY((1 - t) * height)
end

function SceneManager.moveFromTopWithFade(scene1, scene2, t)
	local height = application:getContentHeight()

	scene1:setAlpha(1 - t)
	scene1:setY(t * height)
	scene2:setY((t - 1) * height)
end


function SceneManager.overFromBottomWithFade(scene1, scene2, t)
	local height = application:getContentHeight()
	
	scene1:setAlpha(1 - t)
	scene2:setY((1 - t) * height)
end

function SceneManager.overFromTopWithFade(scene1, scene2, t)
	local height = application:getContentHeight()

	scene1:setAlpha(1 - t)
	scene2:setY((t - 1) * height)
end

function SceneManager.fade(scene1, scene2, t)
	if t < 0.5 then
		scene1:setAlpha((0.5 - t) * 2)
	else
		scene1:setAlpha(0)
	end

	if t < 0.5 then
		scene2:setAlpha(0)
	else
		scene2:setAlpha((t - 0.5) * 2)
	end
end

function SceneManager.crossfade(scene1, scene2, t)
	scene1:setAlpha(1 - t)
	scene2:setAlpha(t)
end

function SceneManager.flip(scene1, scene2, t)
	local width = application:getContentWidth()

	if t < 0.5 then
		local s = (0.5 - t) * 2
		scene1:setScaleX(s)
		scene1:setX((1 - s) * width * 0.5)
	else
		scene1:setScaleX(0)
		scene1:setX(width * 0.5)
	end

	if t < 0.5 then
		scene2:setScaleX(0)
		scene2:setX(width * 0.5)
	else
		local s = (t - 0.5) * 2
		scene2:setScaleX(s)
		scene2:setX((1 - s) * width * 0.5)
	end
end

function SceneManager.flipWithFade(scene1, scene2, t)
	local width = application:getContentWidth()

	if t < 0.5 then
		local s = (0.5 - t) * 2
		scene1:setScaleX(s)
		scene1:setX((1 - s) * width * 0.5)
		scene1:setAlpha(s)
	else
		scene1:setScaleX(0)
		scene1:setX(width * 0.5)
		scene1:setAlpha(0)
	end

	if t < 0.5 then
		scene2:setScaleX(0)
		scene2:setX(width * 0.5)
		scene2:setAlpha(0)
	else
		local s = (t - 0.5) * 2
		scene2:setScaleX(s)
		scene2:setX((1 - s) * width * 0.5)
		scene2:setAlpha(s)
	end
end

function SceneManager.flipWithShade(scene1, scene2, t)
	local width = application:getContentWidth()

	if t < 0.5 then
		local s = (0.5 - t) * 2
		scene1:setScaleX(s)
		scene1:setX((1 - s) * width * 0.5)
		scene1:setColorTransform(1 - t, 1 - t, 1 - t, 1)
	else
		scene1:setScaleX(0)
		scene1:setX(width * 0.5)
		scene1:setColorTransform(0.5, 0.5, 0.5, 1)
	end

	if t < 0.5 then
		scene2:setScaleX(0)
		scene2:setX(width * 0.5)
		scene2:setColorTransform(0.5, 0.5, 0.5, 1)
	else
		local s = (t - 0.5) * 2
		scene2:setScaleX(s)
		scene2:setX((1 - s) * width * 0.5)
		scene2:setColorTransform(t, t, t, 1)
	end
end

local function dispatchEvent(dispatcher, name)
	if dispatcher:hasEventListener(name) then
		dispatcher:dispatchEvent(Event.new(name))
	end
end

local function defaultEase(ratio)
	return ratio
end

function SceneManager:init(scenes)
	self.scenes = scenes
	self.tweening = false
	self.transitionEventCatcher = Sprite.new()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function SceneManager:changeScene(scene, duration, transition, ease, options)
	self.eventFilter = options and options.eventFilter
	GTween.pauseAll = false
	if self.tweening then
		return
	end
	
	if self.scene1 == nil then
		self.scene1 = self.scenes[scene].new(options and options.userData)
		self:addChild(self.scene1)
		dispatchEvent(self, "transitionBegin")
		dispatchEvent(self.scene1, "enterBegin")
		dispatchEvent(self, "transitionEnd")
		dispatchEvent(self.scene1, "enterEnd")
		return
	end

	self.duration = duration
	self.transition = transition
	self.ease = ease or defaultEase

	self.scene2 = self.scenes[scene].new(options and options.userData)
	self.scene2:setVisible(false)
	self:addChild(self.scene2)
	
	self.time = 0
	self.currentTimer = os.timer()
	self.tweening = true
end

function SceneManager:filterTransitionEvents(event)
	event:stopPropagation()
end

function SceneManager:onTransitionBegin()
	if self.eventFilter then
		stage:addChild(self.transitionEventCatcher)
		for i,event in ipairs(self.eventFilter) do
			self.transitionEventCatcher:addEventListener(event, self.filterTransitionEvents, self)
		end
	end
end

function SceneManager:onTransitionEnd()
	if self.eventFilter then
        	for i,event in ipairs(self.eventFilter) do
			self.transitionEventCatcher:removeEventListener(event, self.filterTransitionEvents, self)
		end
		self.transitionEventCatcher:removeFromParent()
	end
end

function SceneManager:onEnterFrame(event)
	if not self.tweening then
		return
	end
	
	if self.time == 0 then
		self:onTransitionBegin()
		self.scene2:setVisible(true)
		dispatchEvent(self, "transitionBegin")
		dispatchEvent(self.scene1, "exitBegin")
		dispatchEvent(self.scene2, "enterBegin")
	end
	
	local timer = os.timer()
	local deltaTime = timer - self.currentTimer
	self.currentTimer = timer

	local t = (self.duration == 0) and 1 or (self.time / self.duration)

	self.transition(self.scene1, self.scene2, self.ease(t), t)

	if self.time == self.duration then
		dispatchEvent(self, "transitionEnd")
		dispatchEvent(self.scene1, "exitEnd")
		dispatchEvent(self.scene2, "enterEnd")
		self:onTransitionEnd()
		
		self:removeChild(self.scene1)	
		self.scene1 = self.scene2
		self.scene2 = nil
		self.tweening = false
		
		collectgarbage()
	end

	self.time = self.time + deltaTime
	
	if self.time > self.duration then
		self.time = self.duration
	end

end