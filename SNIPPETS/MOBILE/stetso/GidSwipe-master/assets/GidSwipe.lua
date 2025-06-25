--[[
	Swipe and Tap detection library for Gideros.
	
	README:
		- simply create a new instance of GidSwipe e.g. local swipe = GidSwipe.new()
		- GidSwipe will then dispatch Event.TAP and Event.SWIPE events to the <stage> object
		- listen to these events and do something :)
		- event parameters are passed to the listener as follows:
			Event.TAP   - contains the same parameters as a normal TOUCHES_END event (i.e. x,y,id,rx,ry etc)
			Event.SWIPE - also contains these parameters but additionally has
				ev.startX and ev.startY: raw start coordinates of the swipe
				ev.direction: direction of the swipe (depends on opts.nSwipeDirections - see below)
		- currently three options can be changed via the GidSwipe.setOption(option, value) method:
			"maxTapDistance": 	the maximum amount of pixel a finger may move while being on the screen for
								the Event.TAP to trigger
			"maxHoldTime":		the maximum time in ms the finger may be on the screen for any event to trigger
			"nSwipeDirections":	the number of swipe directions available - for the values 4 and 8 special values
								are returned
									4: one of "up","right","down","left"
									8" one of "up-left","up","up-right","right","down-right","down","down-left","left"
								this is probably enough for most use cases, however, every other number of "nSwipeDirection"
								setting will return a number (imagine a circle divided into the amount of directions)
	


	CHANGELOG: 
		v1 - Apr 27, 2017 
			initial release
	
	
	LICENSE:
		This software is distributed under the terms of the MIT LICENSE
		Copyright (c) 2017 Stetso
		Permission is hereby granted, free of charge, to any person obtaining a
		copy of this software and associated documentation files (the
		"Software"), to deal in the Software without restriction, including
		without limitation the rights to use, copy, modify, merge, publish,
		distribute, sublicense, and/or sell copies of the Software, and to
		permit persons to whom the Software is furnished to do so, subject to
		the following conditions:
		The above copyright notice and this permission notice shall be included
		in all copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
		OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
		IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
		CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
		TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
		SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]


GidSwipe = Core.class(EventDispatcher)

local sqrt, atan2, floor = math.sqrt, math.atan2, math.floor

local function getTimeMS() return floor(os.timer() * 1000) end
local function pointDistance(x1,y1,x2,y2) return sqrt((x1-x2)^2+(y1-y2)^2) end

Event.TAP = "tap"
Event.SWIPE = "swipe"

local swipeDir4 = {"up","right","down","left"}
local swipeDir8 = {"up-left","up","up-right","right","down-right","down","down-left","left"}

function GidSwipe:init()

	self.opts = {
		maxTapDistance = 20,
		maxHoldTime = 300,
		nSwipeDirections = 4
	}

	stage:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	stage:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	
	self.tStartTime = 0
	self.tEndTime = 0
	self.tStartX = 0
	self.tStartY = 0
end

function GidSwipe:onTouchesBegin(ev)
	local tData = unpack(ev.touches)
	self.tStartTime = getTimeMS()
	self.tStartX = tData.rx
	self.tStartY = tData.ry	
end

function GidSwipe:onTouchesEnd(ev)
	
	local tData = unpack(ev.touches)
	local tEndTime = getTimeMS()
	
	if tEndTime - self.tStartTime < self.opts.maxHoldTime then
		if pointDistance(tData.rx,tData.ry,self.tStartX,self.tStartY) < self.opts.maxTapDistance then
			local e = Event.new(Event.TAP)
			for k,v in pairs(tData) do e[k] = v end
			stage:dispatchEvent(e)
		else 
			local e = Event.new(Event.SWIPE)
			for k,v in pairs(tData) do e[k] = v end
			local startX, startY = self.tStartX, self.tStartY
			local endX, endY = tData.rx, tData.ry
			e.startX = startX
			e.startY = startY
			local deltaX = startX - endX
			local deltaY = startY - endY
			local ang = atan2(deltaY, deltaX) -  (3.14/self.opts.nSwipeDirections)
			ang = ang < 0 and 6.28 + ang or ang -- 2*pi
			ang = ang/6.28
			local dirNum = floor(ang*self.opts.nSwipeDirections)+1
			if self.opts.nSwipeDirections == 4 then
				e.direction = swipeDir4[dirNum]
			elseif self.opts.nSwipeDirections == 8 then
				e.direction = swipeDir8[dirNum]
			else
				e.direction = dirNum
			end
			stage:dispatchEvent(e)
		end
	end
end


function GidSwipe:setOption(opt, val)
	assert(type(opt) == "string", "Option name must be a string")
	
	if self.opts[opt] then
		self.opts[opt] = val
	else error("Unknown option: ".. opt) 
	end
	
end

