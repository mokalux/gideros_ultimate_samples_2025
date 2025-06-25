--include box2d library
require "box2d"

--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class
scene = gideros.class(Sprite)

--declarations
local landLayer21 = Sprite.new()
local landLayer22 = Sprite.new()
local landLayer23 = Sprite.new()
local landLayer24 = Sprite.new()
--local landLayer25 = Sprite.new()

local landLayer11 = Sprite.new()
local landLayer12 = Sprite.new()
local landLayer13 = Sprite.new()
local landLayer14 = Sprite.new()
local landLayer15 = Sprite.new()
local landLayer16 = Sprite.new()

local baseWallLayer11 = Sprite.new()
local baseWallLayer12 = Sprite.new()
local baseWallLayer13 = Sprite.new()
local baseWallLayer14 = Sprite.new()
local baseWallLayer15 = Sprite.new()
local baseWallLayer16 = Sprite.new()

local lifeLayer = Sprite.new()
local scaleLayer = Sprite.new()

local isClicked = false
local xImpulse, yImpulse
local flag, rand
local pumpkin
local life, gameLife
local temp

--on scene initialization
function scene:init()
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	--initialization
	flag = 0
	life = 3
	temp = 30
	
	--get screen dimensions
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	
	--set world dimensions
	self.worldW = screenW*10
	self.worldH = screenH*1.37
	
	--create the game back ground.
	self.sky = self:createSky()
	self.grass = self:createGrass()
	self.landLayer2 = self:createLandLayer2()
	self.land1 = self:createLand1()
	self.baseWall = self:createBaseWall()
	self.baseScale = self:createScale() 
	
	--self:resetPosition()
	
	--create bounding walls to surround world and not screen
	self:wall(0,self.worldH/2,10,self.worldH/2*2)
	self:wall(self.worldW/2,0,self.worldW,10)
	self:wall(self.worldW,self.worldH/2,10,self.worldH)
	self:wall(self.worldW/2,self.worldH,self.worldW,10)
	self:wall(self.worldW/2,self.worldH-self.baseWall1:getHeight()*1.25,self.worldW,10)
	
	--create wall to hold the box2d pumpkin
	self:wall(self.pumpkinStick:getWidth()/2.9, self.pumpkinStick:getHeight()*2.61,10,50)
	self:wall(self.pumpkinStick:getWidth()/2.1, self.pumpkinStick:getHeight()*2.75,60,10)
	
	--create spring
	rand = math.random(600.00, 900.00)
	--self.spring = self:addSpring(randNum)
	bottom = self:wall(rand, 535, 10, 10)
	
	--some spring bounds
	springBound1 = self:springBound(rand - 31, 460, 0, 150)
	springBound2 = self:springBound(rand + 31, 460, 0, 150)
	
	self.spring = Bitmap.new(Texture.new("images/spring.png", true))
	self.spring:setAnchorPoint(0.5, 1)
	self.spring:setPosition(rand, 535)
	self.spring.original = self.spring:getHeight()
	self:addChild(self.spring)
	
	self.springTop = self:CreateSpring(rand, 490)
	
	local jointDef = b2.createDistanceJointDef(self.springTop.body, bottom.body, rand, 540, rand, 470)
	local distanceJoint = self.world:createJoint(jointDef)
	distanceJoint:setLength(60)
	distanceJoint:setDampingRatio(-0.2)
	distanceJoint:setFrequency(5)
	
	--create and store refrence to pumpkin
	self.pumpkin = self:createPumpkin(self.pumpkinStick:getWidth()/5+60, 430)
	self.pumpkin:setVisible(false)
	
	self:mouseEvents()
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	--debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT + b2.DebugDraw.JOINT_BIT)
	--self.world:setDebugDraw(debugDraw)
	--self:addChild(debugDraw)	
	
	--add life and score board
	self:addLife(3)
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self);
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self)
end

function scene:createSky()
	self.sky1 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky1:setPosition(0,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky1)
	
	self.sky2 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky2:setPosition(self.sky1:getWidth(),self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky2)
	
	self.sky3 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky3:setPosition(self.sky1:getWidth()*2,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky3)
	
	self.sky4 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky4:setPosition(self.sky1:getWidth()*3,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky4)
	
	self.sky5 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky5:setPosition(self.sky1:getWidth()*4,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky5)
	
	self.sky6 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky6:setPosition(self.sky1:getWidth()*5,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky6)
	
	self.sky7 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky7:setPosition(self.sky1:getWidth()*6,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky7)
	
	self.sky8 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky8:setPosition(self.sky1:getWidth()*7,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky8)
	
	self.sky9 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky9:setPosition(self.sky1:getWidth()*8,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky9)
	
	self.sky10 = Bitmap.new(Texture.new("images/sky.png"))
	self.sky10:setPosition(self.sky1:getWidth()*9,self.worldH-self.sky1:getHeight()-self.sky1:getHeight()/1.9)
	self:addChild(self.sky10)
end

function scene:createGrass()
	self.grass1 = Bitmap.new(Texture.new("images/grass.png"))
	self.grass1:setPosition(0,self.worldH-self.grass1:getHeight()*4)
	self:addChild(self.grass1)
	
	self.grass2 = Bitmap.new(Texture.new("images/grass.png"))
	self.grass2:setPosition(self.grass1:getWidth(),self.worldH-self.grass1:getHeight()*4)
	self:addChild(self.grass2)
	
	self.grass3 = Bitmap.new(Texture.new("images/grass.png"))
	self.grass3:setPosition(self.grass1:getWidth()*2,self.worldH-self.grass1:getHeight()*4)
	self:addChild(self.grass3)
	
	self.grass4 = Bitmap.new(Texture.new("images/grass.png"))
	self.grass4:setPosition(self.grass1:getWidth()*3,self.worldH-self.grass1:getHeight()*4)
	self:addChild(self.grass4)
	
	self.grass5 = Bitmap.new(Texture.new("images/grass.png"))
	self.grass5:setPosition(self.grass1:getWidth()*4,self.worldH-self.grass1:getHeight()*4)
	self:addChild(self.grass5)
end

function scene:createLandLayer2()
	--********************* Land 2 Scene 1 Layer *********************
	self.land21 = Bitmap.new(Texture.new("images/land2.png"))
	landLayer21:addChild(self.land21)
	self.land21:setPosition(0,self.worldH-self.land21:getHeight()*3)
	
	self.house11 = Bitmap.new(Texture.new("images/house1.png"))
	landLayer21:addChild(self.house11)
	self.house11:setPosition(50,self.worldH-self.house11:getHeight()*2.4)
	
	self.house21 = Bitmap.new(Texture.new("images/house2.png"))
	landLayer21:addChild(self.house21)
	self.house21:setPosition(620,self.worldH-self.house21:getHeight()*2.4)
	
	
	self:addChild(landLayer21)
	
	--********************* Land 2 Scene 2 Layer *********************
	self.land22 = Bitmap.new(Texture.new("images/land2.png"))
	landLayer22:addChild(self.land22)
	self.land22:setPosition(self.land21:getWidth(),self.worldH-self.land22:getHeight()*3)
	
	self.house12 = Bitmap.new(Texture.new("images/house1.png"))
	landLayer22:addChild(self.house12)
	self.house12:setPosition(self.house11:getWidth()*9,self.worldH-self.house11:getHeight()*2.22)
	
	self.house22 = Bitmap.new(Texture.new("images/house2.png"))
	landLayer22:addChild(self.house22)
	self.house22:setPosition(self.house21:getWidth()*12,self.worldH-self.house21:getHeight()*2.22)
	
	self:addChild(landLayer22)
	
	--********************* Land 2 Scene 3 Layer *********************
	self.land23 = Bitmap.new(Texture.new("images/land2.png"))
	landLayer23:addChild(self.land23)
	self.land23:setPosition(self.land21:getWidth(),self.worldH-self.land21:getHeight()*3)
	
	self.house13 = Bitmap.new(Texture.new("images/house1.png"))
	landLayer23:addChild(self.house13)
	self.house13:setPosition(self.house13:getWidth()*10,self.worldH-self.house11:getHeight()*2.4)
	
	--self.house22 = Bitmap.new(Texture.new("images/house2.png"))
	--landLayer23:addChild(self.house22)
	--self.house22:setPosition(self.house21:getWidth()*15,self.worldH-self.house21:getHeight()*2.22)
	
	self:addChild(landLayer23)
	
	--********************* Land 2 Scene 4 Layer *********************
	self.land24 = Bitmap.new(Texture.new("images/land2.png"))
	landLayer24:addChild(self.land24)
	self.land24:setPosition(self.land21:getWidth(),self.worldH-self.land21:getHeight()*3)
	
	
	
	self.house24 = Bitmap.new(Texture.new("images/house2.png"))
	landLayer24:addChild(self.house24)
	self.house24:setPosition(self.house21:getWidth()*8.5,self.worldH-self.house21:getHeight()*2.33)
	
	--self.house14 = Bitmap.new(Texture.new("images/house1.png"))
	--landLayer24:addChild(self.house14)
	--self.house14:setPosition(self.house11:getWidth()*4,self.worldH-self.house11:getHeight()*2.1)
	
	self:addChild(landLayer24)
	
	--[[********************* Land 2 Scene 5 Layer *********************
	self.land25 = Bitmap.new(Texture.new("images/land2.png"))
	landLayer25:addChild(self.land25)
	self.land25:setPosition(self.land21:getWidth()*4,self.worldH-self.land21:getHeight()*3)
	
	self.house15 = Bitmap.new(Texture.new("images/house1.png"))
	landLayer25:addChild(self.house15)
	self.house15:setPosition(self.house11:getWidth()*32,self.worldH-self.house11:getHeight()*2.22)
	
	self.house25 = Bitmap.new(Texture.new("images/house2.png"))
	landLayer25:addChild(self.house25)
	self.house25:setPosition(self.house21:getWidth()*32,self.worldH-self.house21:getHeight()*2.22)
	
	self:addChild(landLayer25)]]
end

function scene:createLand1()
	--********************* Land 1 Scene 1 Layer *********************
	self.land11 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer11:addChild(self.land11)
	self.land11:setPosition(0,self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	--********************* Land 1 Scene 2 Layer *********************
	self.land12 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer12:addChild(self.land12)
	self.land12:setPosition(0,self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	self:addChild(landLayer12)
	
	--********************* Land 1 Scene 3 Layer *********************
	self.land13 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer13:addChild(self.land13)
	self.land13:setPosition(self.land11:getWidth(),self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	self:addChild(landLayer13)
	
	--********************* Land 1 Scene 4 Layer *********************
	self.land14 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer14:addChild(self.land14)
	self.land14:setPosition(self.land11:getWidth()*2,self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	self:addChild(landLayer14)
	
	--********************* Land 1 Scene 5 Layer *********************
	self.land15 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer15:addChild(self.land15)
	self.land15:setPosition(self.land11:getWidth()*3,self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	self:addChild(landLayer15)
	
	--********************* Land 1 Scene 6 Layer *********************
	self.land16 = Bitmap.new(Texture.new("images/land1.png"))
	landLayer16:addChild(self.land16)
	self.land16:setPosition(self.land11:getWidth()*4,self.worldH-self.land11:getHeight() - self.land11:getHeight()/5)
	
	self:addChild(landLayer16)
	
	--********************* add fence to landLayer11 *********************
	self.fence1 = Bitmap.new(Texture.new("images/fence.png"))
	landLayer11:addChild(self.fence1)
	self.fence1:setPosition(self.fence1:getWidth(),self.worldH-self.land11:getHeight() - self.land11:getHeight()/3)
	
	self:addChild(landLayer11)
end

function scene:createBaseWall()
	--********************* base wall Scene 1 Layer *********************
	self.baseWall1 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer11:addChild(self.baseWall1)
	self.baseWall1:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar1 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer11:addChild(self.baseBar1)
	self.baseBar1:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	--Add Stand, Stick, and Pumpkin Stick
	self.stand = Bitmap.new(Texture.new("images/stand.png"))
	baseWallLayer11:addChild(self.stand)
	self.stand:setPosition(115, self.worldH-self.baseWall1:getHeight()*1.8)
	
	self.pumpkinStick = Bitmap.new(Texture.new("images/pumpkinStick.png"))
	baseWallLayer11:addChild(self.pumpkinStick)
	self.pumpkinStick:setAnchorPoint(0.5,1.0)
	self.pumpkinStick:setRotation(30)
	self.pumpkinStick:setVisible(true)
	self.pumpkinStick:setPosition(self.pumpkinStick:getWidth()/1.5, self.worldH-self.baseWall1:getHeight()*1.78)
	
	self.stick = Bitmap.new(Texture.new("images/stick.png"))
	baseWallLayer11:addChild(self.stick)
	self.stick:setAnchorPoint(0.5,1.0)
	self.stick:setRotation(30)
	--self.stick:setVisible(false)
	self.stick:setPosition(self.pumpkinStick:getWidth()/1.5, self.worldH-self.baseWall1:getHeight()*1.78)
	
	self:addChild(baseWallLayer11)
	
	--********************* base wall Scene 2 Layer *********************
	self.baseWall2 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer12:addChild(self.baseWall2)
	self.baseWall2:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar2 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer12:addChild(self.baseBar2)
	self.baseBar2:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	self:addChild(baseWallLayer12)
	
	--********************* base wall Scene 3 Layer *********************
	self.baseWall3 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer13:addChild(self.baseWall3)
	self.baseWall3:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar3 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer13:addChild(self.baseBar3)
	self.baseBar3:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	self:addChild(baseWallLayer13)
	
	--********************* base wall Scene 4 Layer *********************
	self.baseWall4 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer14:addChild(self.baseWall4)
	self.baseWall4:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar4 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer14:addChild(self.baseBar4)
	self.baseBar4:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	self:addChild(baseWallLayer14)
	
	--********************* base wall Scene 5 Layer *********************
	self.baseWall5 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer15:addChild(self.baseWall5)
	self.baseWall5:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar5 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer15:addChild(self.baseBar5)
	self.baseBar5:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	self:addChild(baseWallLayer15)
	
	--********************* base wall Scene 6 Layer *********************
	self.baseWall6 = Bitmap.new(Texture.new("images/wall.png"))
	baseWallLayer16:addChild(self.baseWall6)
	self.baseWall6:setPosition(0,self.worldH-self.baseWall1:getHeight())
	
	self.baseBar6 = Bitmap.new(Texture.new("images/baseBar.png"))
	baseWallLayer16:addChild(self.baseBar6)
	self.baseBar6:setPosition(0,self.worldH-self.baseBar1:getHeight()*1.5)
	
	self:addChild(baseWallLayer16)
end

function scene:createScale()
	--local font = TTFont.new("fonts/tahoma.ttf", 20, true)
	
	function addLines(xPos, yPos, lineWidth, lineHeight, thickness)
		local line = Shape.new()
		--print(xPos .. yPos .. lineWidth .. lineHeight .. thickness)
		line:setLineStyle(thickness, 0x000000, 1)
		line:beginPath()
		line:moveTo(0,0)
		line:lineTo(lineWidth, lineHeight)
		line:endPath()
		line:setPosition(xPos, yPos)
		scaleLayer:addChild(line)
	end
	-- Add a horizontal line
	addLines(0, 531, self.worldW, 0, 2)
	--Add vertical lines
	
	
	
	self:addChild(scaleLayer)
end

function scene:springBound(x, y, width, height)
	local springBound = Shape.new()
	--define wall shape
	springBound:beginPath()
	
	--we make use (0;0) as center of shape,
	--thus we have half of width and half of height in each direction
	springBound:moveTo(-width/2,-height/2)
	springBound:lineTo(width/2, -height/2)
	springBound:lineTo(width/2, height/2)
	springBound:lineTo(-width/2, height/2)
	springBound:closePath()
	springBound:endPath()
	springBound:setPosition(x,y)
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(springBound:getX(), springBound:getY())
	body:setAngle(springBound:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(springBound:getWidth()/2, springBound:getHeight()/2)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	fixture:setFilterData({categoryBits = 4, maskBits = 9})
	springBound.body = body
	springBound.body.type = "springBound"
	
	--add to scene
	self:addChild(springBound)
	
	--return created object
	return springBound
end

function scene:CreateSpring(x, y)
	springTop = Bitmap.new(Texture.new("images/SpringTOp.png"));
	springTop:setAnchorPoint(0.5, 0.5)
	springTop:setPosition(x, y);
	stage:addChild(springTop);
	
	--local radius = spring:getWidth() / 2
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.DYNAMIC_BODY, fixedRotation = true}
	body:setPosition(springTop:getX(), springTop:getY())
	body:setAngle(springTop:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(30, 5)
	local fixture = body:createFixture{shape = poly, density = -0.1, friction = 15, restitution = 1}
	fixture:setFilterData({categoryBits = 8, maskBits = 7})
	springTop.body = body
	springTop.body.type = "springTop"
	self:addChild(springTop)
	
	--return created object
	return springTop
end

function scene:mouseEvents()
	function onMouseDown(event)
		if self.pumpkinStick:hitTestPoint(event.x, event.y) then
			isClicked = true
			self.pumpkinStick:setVisible(true)
			self.stick:setVisible(false)
			self.pumpkin:setVisible(false)
			self.pumpkin.body:setPosition(self.pumpkinStick:getWidth()/5+60, 430)
		end
	end
	
	function onMouseMove(event)
		if isClicked == true then
			self.pumpkin:setVisible(false)
			self.pumpkinStick:setVisible(true)
			self.stick:setVisible(false)
			local a = math.atan((event.y + 180 - self.pumpkinStick:getY()) / (event.x - self.pumpkinStick:getX())) * 180 / math.pi
			if math.ceil(a) <= -30 then
				self.pumpkinStick:setRotation(-30)
				self.pumpkinStick:setVisible(true)
				self.stick:setVisible(false)
			elseif math.ceil(a) >= 30 then
				self.pumpkinStick:setRotation(30)
				self.pumpkinStick:setVisible(true)
				self.stick:setVisible(false)
			else
				self.pumpkinStick:setRotation(a)
			end
		end
	end
	
	function onMouseUp(event)
		if isClicked == true then
			local theta
			if self.pumpkinStick:getRotation() > 0 then
				theta = (30 - self.pumpkinStick:getRotation())/2
			elseif self.pumpkinStick:getRotation() < 0 then
				theta = (30 + (-1 * self.pumpkinStick:getRotation()))/2
			else
				theta = 15
			end
			--print("Pumpkin Rotation angle = " .. self.pumpkinStick:getRotation())
			--print("Theta = " .. theta)
			
			
			xImpulse = ((theta) / 30) * 8
			--xImpulse = -1
			
			self.pumpkinStick:setRotation(30)
			self.stick:setVisible(true)
			self.pumpkinStick:setVisible(false)
			self.pumpkin:setVisible(true)
			
			--if xImpulse < 4 and xImpulse ~= 0 then
			--	xImpulse = xImpulse*6
			--end
			yImpulse = (-1*xImpulse) - 2
			--print("xImpulse = " .. xImpulse)
			local x, y = self.pumpkin.body:getPosition()
			self.pumpkin.body:applyLinearImpulse(xImpulse*60 , yImpulse*25, x, y)
			flag = 1
			isClicked = false
		end
	end
	
	self.pumpkinStick:addEventListener(Event.MOUSE_DOWN, onMouseDown)
	self.pumpkinStick:addEventListener(Event.MOUSE_MOVE, onMouseMove)
	self.pumpkinStick:addEventListener(Event.MOUSE_UP, onMouseUp)
end

function scene:wall(x, y, width, height)
	local wall = Shape.new()
	--define wall shape
	wall:beginPath()
	
	--we make use (0;0) as center of shape,
	--thus we have half of width and half of height in each direction
	wall:moveTo(-width/2,-height/2)
	wall:lineTo(width/2, -height/2)
	wall:lineTo(width/2, height/2)
	wall:lineTo(-width/2, height/2)
	wall:closePath()
	wall:endPath()
	wall:setPosition(x,y)
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(wall:getX(), wall:getY())
	body:setAngle(wall:getRotation() * math.pi/180)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(wall:getWidth()/2, wall:getHeight()/2)
	local fixture = body:createFixture{shape = poly, density = 1.0, friction = 0.1, restitution = 0.8}
	fixture:setFilterData({categoryBits = 1, maskBits = 14})
	wall.body = body
	wall.body.type = "wall"
	
	--add to scene
	self:addChild(wall)
	
	--return created object
	return wall
end

function scene:createPumpkin(x, y)
	
	pumpkin = Bitmap.new(Texture.new("images/pumpkin.png"))
	pumpkin:setAnchorPoint(0.5, 0.5)
	pumpkin:setPosition(x,y)
	
	--get radius
	local radius = pumpkin:getWidth()/2
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(pumpkin:getX(), pumpkin:getY())
	body:setAngle(pumpkin:getRotation() * math.pi/180)
	local circle = b2.CircleShape.new(0, 0, radius)
	local fixture = body:createFixture{shape = circle, density = 10, friction = 10, restitution = 0.1}
	fixture:setFilterData({categoryBits = 2, maskBits = 9})
	pumpkin.body = body
	pumpkin.body.type = "pumpkin"
	
	--add to scene
	self:addChild(pumpkin)
	
	--return created object
	return pumpkin
end

function scene:onBeginContact(e)
	--getting contact bodies
    local fixtureA = e.fixtureA
    local fixtureB = e.fixtureB
    local bodyA = fixtureA:getBody()
    local bodyB = fixtureB:getBody()
    --check if first colliding body is a pumpkin
    if bodyA.type and bodyA.type == "springTop" then
		bodyA.velX, bodyA.velY = bodyA:getLinearVelocity()
		bodyA:setLinearVelocity(5,-20)
		bodyA:setAngularVelocity(0)
    end
	if bodyB.type and bodyB.type == "pumpkin" then
		bodyB.velX, bodyB.velY = bodyB:getLinearVelocity()
        bodyB:setLinearVelocity(0, 0)
		bodyB:setAngularVelocity(0)
    end
	
	if bodyA.type and bodyB.type then
		if bodyA.type == "pumpkin" and bodyB.type == "springTop" then
			self.spring.colliding = true
		elseif bodyB.type == "pumpkin" and bodyA.type == "springTop" then
			self.spring.colliding = true
		end
	end
end

function scene:addLife(nofl)
	for i = 1, nofl do
		gameLife = Bitmap.new(Texture.new("images/pumpkin.png"))
		gameLife:setPosition(temp, 10)
		lifeLayer:addChild(gameLife)
		temp = temp+50
	end
	--self.scoreBoard = Bitmap.new(Texture.new("images/scoreBoard.png"))
	--self.scoreBoard:setPosition(620, 10)
	--lifeLayer:addChild(self.scoreBoard)
	self:addChild(lifeLayer)
	temp = 30
end


function scene:showPopup()
	function onComplete(event)
		if event.buttonText == "OK" then
			if event.text ~= "" then
				self:setX(0)
				self:setY(0)
				self.pumpkin.body:setPosition(self.pumpkinStick:getWidth()/5+60, 430)
				baseWallLayer11:setPosition(0,0)
				landLayer11:setPosition(0,0)
				landLayer21:setPosition(0,0)
				self.grass1:setPosition(0,self.worldH-self.grass1:getHeight()*4)
				
				if life > 0 then
					for i = 1, lifeLayer:getNumChildren() do
						lifeLayer:removeChildAt(1)
					end
					life = life - 1
					self:addLife(life)
				else
					--self:calculateScore()
					self:endGame()
				end
			else
				self:showPopup()
			end
		else
			self:showPopup()
		end
	end
	textInputDialog = TextInputDialog.new("BumpyPumpkin", "Enter the distance covered", "", "OK")
	textInputDialog:setInputType(TextInputDialog.NUMBER)
	textInputDialog:show()
	textInputDialog:addEventListener(Event.COMPLETE, onComplete)
end	


--running the world
function scene:onEnterFrame() 
	--get screen dimensions
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	
	--define offsets
	local offsetX = 0
	local offsetY = 0
	
	--print(self.pumpkin:getY())
	--print(application:getContentWidth() .. " , " .. application:getContentHeight()/2)
	--print(self.worldH)
	--local x, y = self.pumpkin.body:getLinearVelocity()
	--print(x)
	
	--check if we are not too close to left or right wall
	--so we won't go further that wall
	if((self.worldW - self.pumpkin:getX()) < screenW/2) then
		offsetX = (-self.worldW + screenW)
	elseif(self.pumpkin:getX() >= screenW/2) then
		offsetX = -(self.pumpkin:getX() - screenW/2)
	end
	
	--apply offset so scene
	--print(offsetX)
	self:setX(offsetX)
	lifeLayer:setX(-offsetX)
	
	--check if we are not too close to upper or bottom wall
	--so we won't go further that wall
	if((self.worldH - self.pumpkin:getY()) < screenH/2) then
		offsetY = -self.worldH + screenH 
	elseif(self.pumpkin:getY()>= screenH/2) then
		offsetY = -(self.pumpkin:getY() - screenH/2)
	end
	
	--apply offset so scene
	self:setY(offsetY)
	lifeLayer:setY(-offsetY)
	
	self.world:step(1/60, 8, 3)
	--iterate through all child sprites
	for i = 1, self:getNumChildren() do
		--get specific sprite
		local sprite = self:getChildAt(i)
		-- check if sprite HAS a body (ie, physical object reference we added)
		if sprite.body then
			--update position to match box2d world object's position
			--get physical body reference
			local body = sprite.body
			--get body coordinates
			local bodyX, bodyY = body:getPosition()
			--apply coordinates to sprite
			sprite:setPosition(bodyX, bodyY)
			--apply rotation to sprite
			sprite:setRotation(body:getAngle() * 180 / math.pi)
		end
	end
	
	local distance = self.spring:getY() - self.springTop:getY()
	local newScale=distance/self.spring.original
	local oldScale = self.spring:getScaleY()
	self.spring:setScaleY(newScale)
	--print(newScale)
	if self.spring.colliding and oldScale <= newScale and newScale > 0.75 then
		self.spring.colliding = false
		self.pumpkin.body:setLinearVelocity(self.pumpkin.body.velX, self.pumpkin.body.velY*-1)
		
	end
	
	if flag == 1 then
		local lvX, lvY = self.pumpkin.body:getLinearVelocity()
		local pX, pY = self.pumpkin.body:getPosition()
		lvX = math.ceil(lvX)
		lvY = math.ceil(lvY)
		pX = math.ceil(pX)
		pY = math.ceil(pY)
		
		if self.pumpkin:getX() >= screenW/2 then
			self.grass1:setX(-offsetX*0.9)
			self.grass2:setX(self.grass1:getWidth()+(-offsetX*0.9))
			self.grass3:setX(self.grass1:getWidth()*2+(-offsetX*0.9))
			self.grass4:setX(self.grass1:getWidth()*3+(-offsetX*0.9))
			self.grass5:setX(self.grass1:getWidth()*4+(-offsetX*0.9))
	
			landLayer21:setX(-offsetX*0.7)
			landLayer22:setX((-offsetX*0.7))
			landLayer23:setX(self.land21:getWidth()+(-offsetX*0.7))
			landLayer24:setX(self.land21:getWidth()*2+(-offsetX*0.7))
			--landLayer25:setX(self.land21:getWidth()*4+(-offsetX*0.7))
	
			landLayer11:setX(-offsetX*0.5)
			landLayer12:setX(self.land11:getWidth()+(-offsetX*0.5))
			landLayer13:setX(self.land11:getWidth()+(-offsetX*0.5))
			landLayer14:setX(self.land11:getWidth()+(-offsetX*0.5))
			landLayer15:setX(self.land11:getWidth()+(-offsetX*0.5))
			landLayer16:setX(self.land11:getWidth()+(-offsetX*0.5))
	
			baseWallLayer11:setX(-offsetX*0.4)
			baseWallLayer12:setX(self.baseWall1:getWidth()+(-offsetX*0.4))
			baseWallLayer13:setX(self.baseWall1:getWidth()*2+(-offsetX*0.4))
			baseWallLayer14:setX(self.baseWall1:getWidth()*3+(-offsetX*0.4))
			baseWallLayer15:setX(self.baseWall1:getWidth()*4+(-offsetX*0.4))
			baseWallLayer16:setX(self.baseWall1:getWidth()*5+(-offsetX*0.4))
		end
		
		if lvX == 0 and lvY == 0 and pX ~= self.pumpkinStick:getWidth()/5+60 and pY ~= 430 and math.ceil(self.pumpkin:getY()) >= 507 then
			self:showPopup()
			flag = 0
		end
	end
end


function scene:endGame()
	self.pumpkinStick:removeEventListener(Event.MOUSE_DOWN, onMouseDown)
	self.pumpkinStick:removeEventListener(Event.MOUSE_MOVE, onMouseMove)
	self.pumpkinStick:removeEventListener(Event.MOUSE_UP, onMouseUp)
	textInputDialog:removeEventListener(Event.COMPLETE, onComplete)
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	for i = 1, stage:getNumChildren() do
		stage:removeChildAt(1)
	end
end

--removing event on exiting scene
--just in case you're using SceneManager
function scene:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

--add created scene to stage or sceneManager
local mainScene = scene.new()
stage:addChild(mainScene)