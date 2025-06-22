
--[[
	---------------------------------------------
	A generic button class
	---------------------------------------------
	Adapted from:
	gideros mobile studio
	by hubert ronald
	
	This code is MIT licensed, see
	http://www.opensource.org/licenses/mit-license.php
	(C) 2010 - 2011 Gideros Mobile
	---------------------------------------------
]]
--[[
	---------------------------------------------
	Note
	---------------------------------------------
	- Version 2
	Update friday 28, june 2013
	by hubert ronald
	it supports touch events and you can configure
	scale, anchor, alpha and position of button,
	any time.
	- Version 3
	Perform wednesday 22, march 2017
	- Version 4
	Dynamic animation with Gtween
	Saturday 24, june 2017
	---------------------------------------------
	This script is modified by hubert ronald
	---------------------------------------------
]]--

-- initialize class
local Button = gideros.class(Sprite)

-- initialize
function Button:init(config)
	-- setup
	
	local conf = {
		baseButton = Bitmap.new(Texture.new("Canvas/UI/buttonSwitchBase.png",true)) or Sprite.new(),
		upState = Sprite.new(),
		downState = Sprite.new(),
		
		scalebB = 1,
		scaleUp = 1,
		scaleDown = 0.9,
		
		posbB = {x=0,y=0},
		pos = {x=0,y=0},
		
		anchorbB_X = 0.5,
		anchorbB_Y = 0.5,
		
		anchorUpX = 0.5,
		anchorUpY = 0.5,
		
		anchorDownX = 0.5,
		anchorDownY = 0.5,
		
		Gtween = false,
		
		alpha = 1,
		pause = false,
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			conf[key] = value
		end
	end
	
	self.baseButton = conf.baseButton
	self.upState = conf.upState
	self.downState = conf.downState
	self.scale = conf.scalebB
	self.posbB = conf.posbB
	self.pos = conf.pos
	self.alpha = conf.alpha
	self.gtweenEffect = conf.Gtween
	self.pause = conf.pause
	
	
	-- config anchor point
	self.baseButton:setAnchorPoint(conf.anchorbB_X, conf.anchorbB_Y)
	self.upState:setAnchorPoint(conf.anchorUpX, conf.anchorUpY)
	self.downState:setAnchorPoint(conf.anchorDownX, conf.anchorDownY)
	
	-- config scale and alpha for both
	self.baseButton:setAlpha(self.alpha)
	self.baseButton:setPosition(self.posbB.x, self.posbB.y)
	
	self:configBoth("alpha", 1)
	self:configBoth("x",self.pos.x)
	self:configBoth("y",self.pos.y)
	
	-- different scales
	self.baseButton:setScale(self.scale)
	self:configUp("scaleX", conf.scaleUp)
	self:configUp("scaleY", conf.scaleUp)
	self:configDown("scaleX", conf.scaleDown)
	self:configDown("scaleY", conf.scaleDown)
	
	self:addChild(self.baseButton)
	self:updateFocusVisual(false)
	self:startTouch()
	
	if self.gtweenEffect then
		self.Gtween = GTween.new(
				self.upState, 1,
				{y=self.upState:getY()+3},
				{ease = easing.linear, reflect=true, repeatCount=-1,autoPlay = true}
			)
	end
	
end



-- helper function
function Button:configBoth(param,value)
	self.upState:set(tostring(param), value)
	self.downState:set(tostring(param), value)
end


-- helper function Up Button
function Button:configUp(param,value)
	self.upState:set(tostring(param), value)
end

-- helper function Down Button
function Button:configDown(param,value)
	self.downState:set(tostring(param), value)
end



-- if button is on focus, stop propagation of touch events
function Button:onTouchesBegin(e)
	if self:hitTestPoint(e.touch.x, e.touch.y) then
		self:updateFocusVisual(true)
		e:stopPropagation() --in camera don't move if is activated but in mars tap it's ok
	end
end



-- if button is on focus, stop propagation of touch events
function Button:onTouchesMove(e)
	if self.isFocus then
		if not self:hitTestPoint(e.touch.x, e.touch.y) then
			self:updateFocusVisual(false)
			-- update children text or sprite over button parents
			self:dispatchEvent(Event.new("clickCancel"))
		end
		e:stopPropagation()  --in camera don't move if is activated
		
	end
end



-- if button is on focus, stop propagation of touch events
function Button:onTouchesEnd(e)
	if self.isFocus then
		self:updateFocusVisual(false)
		self:dispatchEvent(Event.new("click"))
		e:stopPropagation()	--in camera don't move if is activated
	end
end



-- if touches are cancelled, reset the state of the button
function Button:onTouchesCancel(e)
	if self.isFocus then
		self:updateFocusVisual(false)
		e:stopPropagation()	--in camera don't move if is activated
	end
end



-- helper function update touch button
function Button:updateFocusVisual(Condition)
	self.isFocus = Condition
	self:updateVisualState(Condition)
end



-- if state is true show downState else show upState
function Button:updateVisualState(state)
	if state then
		if self.baseButton:contains(self.upState) then
			self.baseButton:removeChild(self.upState)
		end
		
		if not self.baseButton:contains(self.downState) then
			self.baseButton:addChild(self.downState)
		end
	else
		if self.baseButton:contains(self.downState) then
			self.baseButton:removeChild(self.downState)
		end
		
		if not self.baseButton:contains(self.upState) then
			self.baseButton:addChild(self.upState)
		end
	end
end

-- start events touch
function Button:startTouch()
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

-- pause events touch
function Button:pauseTouch()
	self:removeEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:removeEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:removeEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:removeEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function Button:removeCancel()
	self:removeEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

return Button