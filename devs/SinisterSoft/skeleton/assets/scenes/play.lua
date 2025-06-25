Play=gideros.class(Sprite)

local fudlr,oldFudlr,debouncedFudlr=0,0,0 -- fire, up, down, left, right

function Play:init(t)
	attractMode=0 -- game playng mode

	self.done=false
	self.playerScore=0
	self.timer=5*60
	
-- add score text
	self.score=TextField.new(nil,"")
	self.score:setTextColor(0xffffff)
	self.score:setScale(2)
	self.score:setAnchorPoint(0,0)
	self.score:setPosition(10,20)
	self:addChild(self.score)
	
-- add countdown text
	self.countdown=TextField.new(nil,"")
	self.countdown:setTextColor(0xffffff)
	self.countdown:setScale(2)
	self.countdown:setAnchorPoint(1,0)
	self.countdown:setPosition(310,20)
	self:addChild(self.countdown)
	
	self:updateScore()
	self:updateCountdown()

	self:addEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
	self:addEventListener("exitEnd",self.onTransitionOutEnd,self)
end

function Play:updateScore()
	self.score:setText("Score: "..self.playerScore)
	self.score:setAnchorPoint(0,0)
end

function Play:updateCountdown()
	self.countdown:setText("Countdown: "..self.timer)
	self.countdown:setAnchorPoint(1,0)
end

function Play:quit()
	if not self.done and sceneManager:changeScene("gameover",0.5,transitions[math.random(#transitions)]) then self.done=true end
end

function Play:onTransitionOutEnd()
	self:removeEventListener(Event.ENTER_FRAME,self.onEnterFrame,self)
end

function Play:onEnterFrame(Event)
	processPads()
	
	if debouncedFudlr&0b10000~=0 then
		self.playerScore+=1
		self:updateScore()
	end
	
	self.timer-=1
	if self.timer<0 then
		self:quit()
	else
		self:updateCountdown()
	end
	
end
