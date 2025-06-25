rows={1,3,3,5,5}
shipSpeed=2
bulletWallet=4
bulletSpeed=10
hiscore=10
invaderSpeedX=1 -- 10
invaderSpeedY=2 -- 16
shipY=640
border=20
earthY=670
alpha=0.8
 
--application:setKeepAwake(true)
application:setBackgroundColor(0x000000)
width=application:getContentWidth()
 
--local textures=TexturePack.new("Invaders.txt","Invaders.png",true)
--local tMoon=textures:getTextureRegion("moon.png")
--local bMoon=Bitmap.new(tMoon)
--local tRaster=Texture.new("raster.png",true)
--local bRaster=Bitmap.new(tRaster)

--local textures=TexturePack.new("Invaders.txt","Invaders.png",true)
--local tMoon=textures:getTextureRegion("moon.png")
local bMoon = Pixel.new(0x121212, 1, 32, 32)
local bRaster = Pixel.new(0x55ffff, 1, width, 0.1)
bRaster:setScaleY(800)
stage:addChild(bMoon)
 
playField=Sprite.new()
stage:addChild(playField)

--font=Font.new("space_invaders.txt","space_invaders.png",true)
font = nil
 
TextButton=Core.class(TextField)
function TextButton:init()
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end
 
function TextButton:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) then
		local clickEvent = Event.new("click")
		self:dispatchEvent(clickEvent)
	end
end
 
--tButtonUp=textures:getTextureRegion("buttonup.png")
--tButtonDown=textures:getTextureRegion("buttondown.png")
tButtonUp = Texture.new("gfx/end_down.png")
tButtonDown = Texture.new("gfx/end_up.png")
 
Button=Core.class(Sprite)
function Button:init(x,y,scale,r,g,b)
	self.up=Bitmap.new(tButtonUp)
	self.down=Bitmap.new(tButtonDown)
	self.up:setAnchorPoint(0.5,0.5)
	self.down:setAnchorPoint(0.5,0.5)
	self.pressed=false
	self:setScale(scale)
	self:setPosition(x,y)
	self:setColorTransform(r,g,b)
	self:setAlpha(alpha)
	self:updateState()
	self:addEventListener(Event.MOUSE_DOWN,self.onMouseDown,self)
	self:addEventListener(Event.MOUSE_MOVE,self.onMouseMove,self)
	self:addEventListener(Event.MOUSE_UP,self.onMouseUp,self)
	self:addEventListener(Event.TOUCHES_BEGIN,self.onTouchesBegin,self)
	self:addEventListener(Event.TOUCHES_MOVE,self.onTouchesMove,self)
	self:addEventListener(Event.TOUCHES_END,self.onTouchesEnd,self)
	self:addEventListener(Event.TOUCHES_CANCEL,self.onTouchesCancel,self)
end
 
function Button:onMouseDown(event)
	event.touch={x=event.x,y=event.y,id=0}
	self:onTouchesBegin(event)	
end
 
function Button:onMouseMove(event)
	event.touch={x=event.x,y=event.y,id=0}
	self:onTouchesMove(event)	
end
 
function Button:onMouseUp(event)
	event.touch={x=event.x,y=event.y,id=0}
	self:onTouchesEnd(event)	
end
 
function Button:onTouchesBegin(event)
	if self.touchId==nil and self:hitTestPoint(event.touch.x,event.touch.y) then
		self.touchId=event.touch.id
		self.pressed=true
		self:updateState()
		event:stopPropagation()
	end
end
 
function Button:onTouchesMove(event)
	if self.touchId==event.touch.id then
		if not self:hitTestPoint(event.touch.x,event.touch.y) then	
			self.touchId=nil
			self.pressed=false
			self:updateState()
		end
		event:stopPropagation()
	end
end
 
function Button:onTouchesEnd(event)
	if self.touchId==event.touch.id then
		self.touchId=nil
		self.pressed=false
		self:updateState()
		event:stopPropagation()
	end
end
 
function Button:onTouchesCancel(event)
	if self.touchId==event.touch.id then
		self.touchId=nil
		self.pressed=false
		self:updateState()
		event:stopPropagation()
	end
end
 
function Button:updateState()
	if self.pressed then
		if self:contains(self.up) then
			self:removeChild(self.up)
		end
		if not self:contains(self.down) then
			self:addChild(self.down)
		end
	else
		if self:contains(self.down) then
			self:removeChild(self.down)
		end
		if not self:contains(self.up) then
			self:addChild(self.up)
		end
	end
end
 
local sPanel=Sprite.new()
stage:addChild(sPanel)
stage:addChild(bRaster)
 
panelText={}
function addPanelText(pos,x,y,text)
	panelText[pos]=TextField.new(font,text)
	panelText[pos]:setScale(0.7)
	panelText[pos]:setTextColor(0xffffff)
	panelText[pos]:setAlpha(alpha)
	panelText[pos]:setPosition(x*15.1,(y+1)*20)
	sPanel:addChild(panelText[pos])
end
 
addPanelText(1,1,1,"Score<1>")
addPanelText(2,31,1,"Score<2>")
addPanelText(3,16,1,"Hi-Score")
addPanelText(4,3,3,0)
addPanelText(5,33,3,0)
addPanelText(6,17,3,hiscore)
addPanelText(7,30,34,"")
 
panelButton={}
panelButton[1]=Button.new(100,750,1,0,0.8,0.1)
panelButton[2]=Button.new(200,750,1,0,0.8,0.1)
panelButton[3]=Button.new(500,750,1,1,0,0)
for loop=1,3 do
	sPanel:addChild(panelButton[loop])
end
 
tInvader={}
for loop=1,6 do
--	tInvader[loop]=textures:getTextureRegion("invaders"..loop..".png")
	tInvader[loop]=Pixel.new(0xffffff, 1, 32, 32)
end
 
sfx={}
for loop=0,9 do
--	sfx[loop]=Sound.new(loop..".wav")
--	sfx[loop]=Sound.new("audio/Braam - Retro Pulse.wav")
end
 
invaders=Sprite.new()
playField:addChild(invaders)
 
count=0
y=5*30
for loop,row in ipairs(rows) do
	x=400
	for column=0,10 do
		count=count+1
		invaders[count]=Sprite.new()
		invaders[count].image=row
--		invaders[count].bitmap=Bitmap.new(tInvader[invaders[count].image])
		invaders[count].bitmap=Pixel.new(0x00ff00, 1, 32, 32)
		invaders[count].bitmap:setAnchorPoint(0.5,0.5)
		invaders[count].resetX=x
		invaders[count].resetY=y
		invaders[count].x=0
		invaders[count].y=0
		invaders:setAlpha(alpha)
		invaders[count]:setVisible(false)
		invaders[count]:addChild(invaders[count].bitmap)
		invaders:addChild(invaders[count])
		x=x-36
	end
	y=y+30
end
 
shipX=width/2
--tShip=textures:getTextureRegion("ship.png")
--bShip=Bitmap.new(tShip)
bShip=Pixel.new(0xffff00, 1, 32, 32)
bShip:setAnchorPoint(0.5,0.5)
bShip:setAlpha(0.7)
bShip:setPosition(shipX,shipY)
playField:addChild(bShip)
 
bullets=Sprite.new()
playField:addChild(bullets)
--tBullet=textures:getTextureRegion("bullet.png")
explode={}
for loop=1,2 do
--	explode[loop]=textures:getTextureRegion("explode"..loop..".png")
	explode[loop] = Pixel.new(0xff00ff, 1, 32, 32)
end
Bullet=Core.class(Sprite)
function Bullet:init(x,y)
--	self.bitmap=Bitmap.new(tBullet)
	self.bitmap=Pixel.new(0xffff00, 1, 32, 32)
	self:setAlpha(alpha)
	self.bitmap:setAnchorPoint(0.5,0.5)
	self.x=x
	self.y=y
	self.explode=0
	self:setPosition(x,y)
	self:addChild(self.bitmap)
end
 
sEarth=Shape.new()
sEarth:setLineStyle(4,0xffffff,alpha)
sEarth:beginPath()
sEarth:moveTo(0,0)
sEarth:lineTo(width,0)
sEarth:endPath()
sEarth:setPosition(0,earthY)
playField:addChild(sEarth)
 
vCounter=0
 
heartBeat=0
fire=false
players={}
for loop=1,2 do
	players[loop]={}
	players[loop].score=0
end
player=1
reset=count
wave=1
invadersActive=true

function gameLoop(event)
	vCounter=vCounter+1
 
	if invadersActive then
		if reset>0 then
			dirX=invaderSpeedX
			dirY=0
			movement=0
			x=invaders[reset].resetX
			y=invaders[reset].resetY
			invaders[reset].x,invaders[reset].y=x,y
			invaders[reset]:setPosition(x,y)
			invaders[reset]:setVisible(true)
			reset=reset-1
			if reset==0 then
				panelText[7]:setText("Wave "..wave)
			else
				panelText[7]:setText("")
			end
		else
 
			local moved=false
			for loop=1,count do
				movement=movement-1
 
				if movement<1 then
					dirY=0
					for loop2=1,count do
						newx=invaders[loop2].x+dirX
						if newx<border or newx>(width-border) then
							dirX=-dirX
							dirY=invaderSpeedY
							break
						end
					end
					movement=count
					heartBeat=heartBeat+1
					if heartBeat==4 then
						heartBeat=0
					end
--					sfx[4+heartBeat]:play()
					if heartBeat%2==0 then
						for loop2=1,count do
--							invaders[loop2].bitmap:setTextureRegion(tInvader[invaders[loop2].image])
						end
					else
						for loop2=1,count do
--							invaders[loop2].bitmap:setTextureRegion(tInvader[invaders[loop2].image+1])
						end
					end
				end
 
				if invaders[movement]:isVisible() then
					invaders[movement].x=invaders[movement].x+dirX
					invaders[movement].y=invaders[movement].y+dirY
					invaders[movement]:setPosition(invaders[movement].x,invaders[movement].y)
					moved=true
					break
				end
			end
			if moved==false then
				reset=count
				wave=wave+1
			end
		end
 
		if panelButton[1].pressed then
			shipX=shipX-shipSpeed
		end
		if panelButton[2].pressed then
			shipX=shipX+shipSpeed
		end
		if shipX<border then
			shipX=border
		elseif shipX>(width-border) then
			shipX=width-border
		end
		bShip:setPosition(shipX,shipY)
 
		if panelButton[3].pressed and fire==false then
			fire=true
			if bulletWallet>0 then
--				sfx[1]:play()
				bulletWallet=bulletWallet-1
				bullets:addChild(Bullet.new(shipX,shipY))
			end
		elseif panelButton[3].pressed==false then
			fire=false
		end
		for loop=bullets:getNumChildren(),1,-1 do
			local bullet=bullets:getChildAt(loop)
			if bullet.explode>0 then
				bullet.explode=bullet.explode-1
				if bullet.explode==0 then		
					bullet:removeChild(bullet.bitmap)
					bullet:removeFromParent()
				end
			else
				bullet.y=bullet.y-bulletSpeed
				for loop=1,count do
					if invaders[loop]:isVisible() and invaders[loop].bitmap:hitTestPoint(bullet.x,bullet.y) then
--						sfx[3]:play()
						bullet.explode=20
						bullet.x,bullet.y=invaders[loop].x,invaders[loop].y
						invaders[loop]:setVisible(false)
--						bullet.bitmap:setTextureRegion(explode[1])
						bulletWallet=bulletWallet+1
						players[player].score=players[player].score+1
					end
				end
				if bullet.y<100 then
					bullet.explode=20
--					bullet.bitmap:setTextureRegion(explode[2])
					bulletWallet=bulletWallet+1
				else
					bullet:setPosition(bullet.x,bullet.y)
				end
			end
		end
 
		for loop=1,count do
			if invaders[loop]:isVisible() then
				if invaders[loop].bitmap:hitTestPoint(shipX,shipY) then
					invaders[loop]:setVisible(false)
				end
				if invaders[loop].bitmap:hitTestPoint(invaders[loop].x,earthY) then
					invadersActive=false
				end
			end
		end
	end
 
	panelText[3+player]:setText(players[player].score)
	if players[player].score>hiscore then
		hiscore=players[player].score
		panelText[6]:setText(hiscore)
	end
end
 
stage:addEventListener(Event.ENTER_FRAME,gameLoop)
