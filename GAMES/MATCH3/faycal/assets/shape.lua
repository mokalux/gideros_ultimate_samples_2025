shapes = Core.class(Sprite)

 

function shapes:move(t,f,iv)
if (iv and not t) then
 local dumdum=GTween.new(self, 0.2, {x = self:getX() + f}, { ease = easing. outBack,dispatchEvents = true })
 return dumdum
elseif  iv and t  then
  local dumdum=GTween.new(self, 0.2, {y = self:getY() + f}, { ease = easing. outBack,dispatchEvents = true})
 return dumdum 
elseif not iv and not t  then
return GTween.new(self, 0.15, {x = self:getX() + f}, { ease = easing.outBack,repeatCount = 2, reflect = true})
 
elseif  not iv and t  then
return GTween.new(self, 0.15, {y = self:getY() + f}, { ease = easing.outBack,repeatCount = 2, reflect = true})
end

end




function shapes:explode(varx,vary,marx,mary,size)

  
 local tweeny=GTween.new(self, 0.2, {x = self:getX()-20,y =self:getY() -20,scaleX=2,scaleY=2}, { ease = easing.inBack,dispatchEvents = true })
print(""..varx.." rr "..vary)

tweeny:addEventListener("complete", function()
 
  
self:init(size,6,varx,vary)
 self:setPosition(self:getX()+20,self:getY()+20)
 self:setScale(1,1)
 stage:addChild(self)
 self:removeChild(self.image)
local frames = {}
	local bmp
	for i = 1, 5 do
		bmp = Bitmap.new(Texture.new("anim/explosionred0"..i..".png", true))
		bmp:setAnchorPoint(0.5, 0.5)
		frames[#frames+1] = bmp
	end
	--arrange frames
	Animated_menu_bg = MovieClip.new{
		{1, 5, frames[1]}, 
		{6,10, frames[2]}, 
		{11,15, frames[3]}, 
		{16,20, frames[4]}, 
		{21,25, frames[5]}, 
	}
	--loop animation
	 	--start playing
	Animated_menu_bg:gotoAndPlay(1)
	Animated_menu_bg:setPosition(20,20)
	local spr=Sprite.new()
	spr:addChild(Animated_menu_bg)
	self:addChild(spr)
	Timer.delayedCall(300, function () 
	self:removeChild(spr) 
	end)

end)

end



 function shapes:onMouseDown( event)
	if self:hitTestPoint(event.x, event.y) then
		self.isFocus = true

		self.x0 = event.x
		self.y0 = event.y
	 
		event:stopPropagation()
	end
end

  function shapes:onMouseMove( event)
	if self.isFocus then


if event.x>self.x0+20 then
		
		self.isFocus = false
		  local clickEvent = Event.new("clickright")
    self:dispatchEvent(clickEvent)
		
end
if event.x<self.x0-20 then

		self.isFocus = false
	  local clickEvent = Event.new("clickleft")
    self:dispatchEvent(clickEvent)	
end
if event.y>self.y0+20 then
		self.isFocus = false
	  local clickEvent = Event.new("clickdown")
    self:dispatchEvent(clickEvent)	
end
if event.y<self.y0-20 then
		self.isFocus = false	
		  local clickEvent = Event.new("clickup")
    self:dispatchEvent(clickEvent)
end
		

		event:stopPropagation()
		
	end
end

  function shapes:onMouseUp(  event)
	if self.isFocus then
		self.isFocus = false
		   event:stopPropagation()
 
	end
end



function shapes:init(w,t,x,y)

self.xx=x
self.yy=y
self.tt=t

self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
		self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
		self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)


if t~=6 then 
local texture = Texture.new("img/bean ("..t..").png",true)
self.image = Bitmap.new(texture)
self.image:setAnchorPoint(0.5, 0.5)
self.image:setPosition(w/2,w/2)
 

 

 self:addChild(self.image)
end 
end
