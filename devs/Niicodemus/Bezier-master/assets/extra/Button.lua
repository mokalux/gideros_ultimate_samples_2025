-- The MIT License (MIT)

-- Copyright (c) 2013 Nathan Shafer

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

Button = Core.class(Sprite)

function Button:init(name, upState, downState)
	--print("Button:init", self, name)
	self.name = name
	self.upState = upState
	self.downState = downState
	
	self.state = false
	self.focus = false
	
	-- set the visual state as "up"
	self:updateVisualState(self.state)
	
	-- register to touch events
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function Button:setState(state, suppressEvent)
	if state ~= self.state then
		--print("Button:setState", self.name, self.state, " -> ", state)
		self.state = state
		self:updateVisualState(self.state)
		
		if not suppressEvent then
			local event
			if state then
				event = Event.new("down")
			else
				event = Event.new("up")
			end
			event.name = self.name
			event.state = self.state
			self:dispatchEvent(event)
		end
	end
end

function Button:onTouchesBegin(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) then
		--print("Button:onTouchesBegin", self.name, self.state)
		self.focus = true
		self:setState(true)
		event:stopPropagation()
	end
end

function Button:onTouchesMove(event)
	if self.focus then
		if not self:hitTestPoint(event.touch.x, event.touch.y) then	
			self.focus = false
			-- Update state and visuals without calling setState, we don't want to send an event
			self:setState(false, true)
		end
		event:stopPropagation()
	end
end

function Button:onTouchesEnd(event)
	if self.focus then
		--print("Button:onTouchesEnd", self.name, self.state)
		self.focus = false
		self:setState(false)
		event:stopPropagation()
	end
end

function Button:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:updateVisualState(false)
		event:stopPropagation()
	end
end

-- if state is true show downState else show upState
function Button:updateVisualState(state)
	--print("Button:updateVisualState", self.name, state)
	if state then
		if self:contains(self.upState) then
			self:removeChild(self.upState)
		end
		
		if not self:contains(self.downState) then
			self:addChild(self.downState)
		end
	else
		if self:contains(self.downState) then
			self:removeChild(self.downState)
		end
		
		if not self:contains(self.upState) then
			self:addChild(self.upState)
		end
	end
end
