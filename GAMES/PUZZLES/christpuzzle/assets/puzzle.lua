puzzle = gideros.class(Sprite)

function puzzle:init()
		self:addEventListener(Event.KEY_UP, self.onKeyUp, self)
bitmap={}
t={}
a1=0
b1=0
i=0
dx=0
dy=0
z=math.random(1,43)
texture = Texture.new("1/"..z.."_1.jpg")
a=texture:getWidth()
b=texture:getHeight()
for g=0,a-25,texture:getWidth()/5 do
for j=0,b-25,texture:getHeight()/8 do
i=i+1
t[i]=0
bitmap[i] = Bitmap.new(TextureRegion.new(texture, a1, b1, texture:getWidth()/5, texture:getHeight()/8))
stage:addChild(bitmap[i])
bitmap[i]:setPosition(math.random(0,application:getContentWidth()-bitmap[i]:getWidth()),math.random(0,application:getContentHeight()-bitmap[i]:getHeight()))
if i==1 or i==9 then
bitmap[i]:setPosition(a1,b1)
end
b1=b1+texture:getHeight()/8
end
a1=a1+texture:getWidth()/5
b1=0
end
	
self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
 self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
 self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
 self:addEventListener(Event.MOUSE_UP,   self.onMouseUp,   self)

end

function puzzle:onMouseDown(event)

for i=2,40 do
if (bitmap[i]:hitTestPoint(event.x, event.y) == true) and i~=9 and t[i]~=1 then 

		bitmap[i]:getParent():addChild(bitmap[i])
		bitmap[i].isMoving = true
		bitmap[i].x0 = event.x
		bitmap[i].y0 = event.y
		break
end
end
end

function puzzle:onMouseMove(event)
for i=2,40 do
	if bitmap[i].isMoving == true then  
		dx = event.x - bitmap[i].x0
		dy = event.y - bitmap[i].y0
		bitmap[i].x0 = event.x
		bitmap[i].y0 = event.y
		bitmap[i]:setX(dx + bitmap[i]:getX())
		bitmap[i]:setY(dy + bitmap[i]:getY())
		break
	end
end
end

function puzzle:onMouseUp(event)
for i=2,40 do
if (bitmap[i].isMoving == true) then 
 bitmap[i].isMoving = false
 
 if bitmap[i]:getX()>-20 and bitmap[i]:getX()<(bitmap[i]:getWidth()+20) and i<9 then 
 if i==1 or i==9 or i==17 or i==25 or i==33 then
 if bitmap[i]:getY()>-20 and bitmap[i]:getY()<bitmap[i]:getHeight()+20 then
    t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(0,0)
 end
 end
  if i==2 or i==10 or i==18 or i==26 or i==34 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight() and bitmap[i]:getY()<bitmap[i]:getHeight()*2+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
    bitmap[i]:setPosition(0,bitmap[i]:getHeight())
 end
 end
   if i==3 or i==11 or i==19 or i==27 or i==35 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*2 and bitmap[i]:getY()<bitmap[i]:getHeight()*3+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*2)
 end
 end
  if i==4 or i==12 or i==20 or i==28 or i==36 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*3 and bitmap[i]:getY()<bitmap[i]:getHeight()*4+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*3)
 end
 end
   if i==5 or i==13 or i==21 or i==29 or i==37 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*4 and bitmap[i]:getY()<bitmap[i]:getHeight()*5+20 then
    t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*4)
 end
 end
  if i==6 or i==14 or i==22 or i==30 or i==38 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*5 and bitmap[i]:getY()<bitmap[i]:getHeight()*6+20 then
    t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*5)
 end
 end
  if i==7 or i==15 or i==23 or i==31 or i==39 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*6 and bitmap[i]:getY()<bitmap[i]:getHeight()*7+20 then
    t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*6)
 end
 end
  if i==8 or i==16 or i==24 or i==32 or i==40 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*7 and bitmap[i]:getY()<bitmap[i]:getHeight()*8+20 then
    t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(0,bitmap[i]:getHeight()*7)
 end
 end
 end
  if bitmap[i]:getX()>-20+bitmap[i]:getWidth() and bitmap[i]:getX()<(bitmap[i]:getWidth()*2+20) and i<17 and i>8 then 
 if i==1 or i==9 or i==17 or i==25 or i==33 then
 if bitmap[i]:getY()>-20 and bitmap[i]:getY()<bitmap[i]:getHeight()+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),0)
 end
 end
  if i==2 or i==10 or i==18 or i==26 or i==34 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight() and bitmap[i]:getY()<bitmap[i]:getHeight()*2+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight())
 end
 end
   if i==3 or i==11 or i==19 or i==27 or i==35 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*2 and bitmap[i]:getY()<bitmap[i]:getHeight()*3+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*2)
 end
 end
  if i==4 or i==12 or i==20 or i==28 or i==36 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*3 and bitmap[i]:getY()<bitmap[i]:getHeight()*4+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*3)
 end
 end
   if i==5 or i==13 or i==21 or i==29 or i==37 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*4 and bitmap[i]:getY()<bitmap[i]:getHeight()*5+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*4)
 end
 end
  if i==6 or i==14 or i==22 or i==30 or i==38 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*5 and bitmap[i]:getY()<bitmap[i]:getHeight()*6+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*5)
 end
 end
  if i==7 or i==15 or i==23 or i==31 or i==39 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*6 and bitmap[i]:getY()<bitmap[i]:getHeight()*7+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*6)
 end
 end
  if i==8 or i==16 or i==24 or i==32 or i==40 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*7 and bitmap[i]:getY()<bitmap[i]:getHeight()*8+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth(),bitmap[i]:getHeight()*7)
 end
 end
 end
  if bitmap[i]:getX()>-20+bitmap[i]:getWidth()*2 and bitmap[i]:getX()<(bitmap[i]:getWidth()*3+20) and i<25 and i>16 then 
 if i==1 or i==9 or i==17 or i==25 or i==33 then
 if bitmap[i]:getY()>-20 and bitmap[i]:getY()<bitmap[i]:getHeight()+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,0)
 end
 end
  if i==2 or i==10 or i==18 or i==26 or i==34 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight() and bitmap[i]:getY()<bitmap[i]:getHeight()*2+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight())
 end
 end
   if i==3 or i==11 or i==19 or i==27 or i==35 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*2 and bitmap[i]:getY()<bitmap[i]:getHeight()*3+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*2)
 end
 end
  if i==4 or i==12 or i==20 or i==28 or i==36 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*3 and bitmap[i]:getY()<bitmap[i]:getHeight()*4+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*3)
 end
 end
   if i==5 or i==13 or i==21 or i==29 or i==37 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*4 and bitmap[i]:getY()<bitmap[i]:getHeight()*5+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*4)
 end
 end
  if i==6 or i==14 or i==22 or i==30 or i==38 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*5 and bitmap[i]:getY()<bitmap[i]:getHeight()*6+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*5)
 end
 end
  if i==7 or i==15 or i==23 or i==31 or i==39 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*6 and bitmap[i]:getY()<bitmap[i]:getHeight()*7+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*6)
 end
 end
  if i==8 or i==16 or i==24 or i==32 or i==40 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*7 and bitmap[i]:getY()<bitmap[i]:getHeight()*8+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*2,bitmap[i]:getHeight()*7)
 end
 end
 end
  if bitmap[i]:getX()>-20+bitmap[i]:getWidth()*3 and bitmap[i]:getX()<(bitmap[i]:getWidth()*4+20) and i<33 and i>24 then 
 if i==1 or i==9 or i==17 or i==25 or i==33 then
 if bitmap[i]:getY()>-20 and bitmap[i]:getY()<bitmap[i]:getHeight()+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*3,0)
 end
 end
  if i==2 or i==10 or i==18 or i==26 or i==34 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight() and bitmap[i]:getY()<bitmap[i]:getHeight()*2+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight())
 end
 end
   if i==3 or i==11 or i==19 or i==27 or i==35 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*2 and bitmap[i]:getY()<bitmap[i]:getHeight()*3+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
   bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*2)
 end
 end
  if i==4 or i==12 or i==20 or i==28 or i==36 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*3 and bitmap[i]:getY()<bitmap[i]:getHeight()*4+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*3)
 end
 end
   if i==5 or i==13 or i==21 or i==29 or i==37 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*4 and bitmap[i]:getY()<bitmap[i]:getHeight()*5+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*4)
 end
 end
  if i==6 or i==14 or i==22 or i==30 or i==38 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*5 and bitmap[i]:getY()<bitmap[i]:getHeight()*6+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*5)
 end
 end
  if i==7 or i==15 or i==23 or i==31 or i==39 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*6 and bitmap[i]:getY()<bitmap[i]:getHeight()*7+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*6)
 end
 end
  if i==8 or i==16 or i==24 or i==32 or i==40 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*7 and bitmap[i]:getY()<bitmap[i]:getHeight()*8+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
	--	channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*3,bitmap[i]:getHeight()*7)
 end
 end
 end
  if bitmap[i]:getX()>-20+bitmap[i]:getWidth()*4 and bitmap[i]:getX()<(bitmap[i]:getWidth()*5+20) and i<41 and i>32 then 
 if i==1 or i==9 or i==17 or i==25 or i==33 then
 if bitmap[i]:getY()>-20 and bitmap[i]:getY()<bitmap[i]:getHeight()+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*4,0)
 end
 end
  if i==2 or i==10 or i==18 or i==26 or i==34 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight() and bitmap[i]:getY()<bitmap[i]:getHeight()*2+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight())
 end
 end
   if i==3 or i==11 or i==19 or i==27 or i==35 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*2 and bitmap[i]:getY()<bitmap[i]:getHeight()*3+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
     bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*2)
 end
 end
  if i==4 or i==12 or i==20 or i==28 or i==36 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*3 and bitmap[i]:getY()<bitmap[i]:getHeight()*4+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*3)
 end
 end
   if i==5 or i==13 or i==21 or i==29 or i==37 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*4 and bitmap[i]:getY()<bitmap[i]:getHeight()*5+20 then
   t[i]=1
--  	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*4)
 end
 end
  if i==6 or i==14 or i==22 or i==30 or i==38 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*5 and bitmap[i]:getY()<bitmap[i]:getHeight()*6+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*5)
 end
 end
  if i==7 or i==15 or i==23 or i==31 or i==39 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*6 and bitmap[i]:getY()<bitmap[i]:getHeight()*7+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*6)
 end
 end
  if i==8 or i==16 or i==24 or i==32 or i==40 then
 if bitmap[i]:getY()>-20+bitmap[i]:getHeight()*7 and bitmap[i]:getY()<bitmap[i]:getHeight()*8+20 then
   t[i]=1
 -- 	music = Sound.new("mus/yes.mp3")	
--		channel  = music:play(0, 1)
  bitmap[i]:setPosition(bitmap[i]:getWidth()*4,bitmap[i]:getHeight()*7)
 end
 end
 end
 break
end
end
total=0
for i=1,40 do
total=total+t[i]
end
end

function puzzle:onEnterFrame(event)

end

function puzzle:onKeyUp(event)
	if event.keyCode == KeyCode.BACK then
	--self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		sceneManager:changeScene("levels", 1, SceneManager.overFromBottomWithFade, easing.outBack)
		
		
	end
end