--include box2d library
require "box2d"

LoadGame = gideros.class(Sprite)

--local bgLayer1, bgLayer2
--local layer
local lineLayer = Sprite.new()
local textLayer = Sprite.new()

--local pumpkin
local bushes1, bushes2
local surface21, surface22
local surface11, surface12
local house11, house12
local house21, house22
local base1, base2
local stand
local pumpkinStick
local stick

local spring, springTop--, sPositionX, stPostitionX

local rand
local bottom
local springBound1, springBound2
local exLife
local line
local text
local textInputDialog
local score
local bonus
local myScore
local targetHit
local lblBonus, lblScore, sScore, sBonus

--local startpoint = {}
local xImpulse
local yImpulse
--local xVect
--local yVect
local flag
local life0, life1, life2
local life
local isClicked = false

local gameTune
local endTune

-- Play tune
local function playTune(fileName)
	gameTune = Sound.new(fileName)
	endTune = gameTune:play(100,true)
end

function LoadGame:init(soundCheck)
	if soundCheck == 1 then
		playTune("sounds/BackGroundSound.mp3")
	end
	
	local bg = Bitmap.new(Texture.new("images/Background.png"));
	bg:setPosition(0,0)
	stage:addChild(bg)
	
	--playTune("sounds/BackGroundSound.mp3")
	--endTune:stop()
	--create world instance
	self.world = b2.World.new(0, 10, true)
	
	--Intitialization
	life = 3
	score = 0
	bonus = 0
	flag = 0
	
	local screenW = application:getContentWidth()
	local screenH = application:getContentHeight()
	
	--print("Content " .. screenW .. " " .. screenH)
	--print(application:getLogicalWidth() .. " " .. application:getLogicalHeight())
	
	--Create Bounding Walls Outside The Scene
	self:wall(0, screenH/2, 0, screenH) --Left wall
	self:wall(screenW/2, -10, screenW*5, 0) --Top wall
	self:wall(screenW, screenH/2, 0, screenH) --Right wall
	self:wall(screenW/2, 255, screenW*5, 0) -- Buttom wall
	
	-- wall to hold pumpkin
	self:wall(25, 185, 0, 18) --left
	--self:wall(50, 185, 0, 18) --right
	self:wall(40, 195, 25, 0) --buttom
	
	--In Stage Game Background
	self:GameBackground1()
	------------------------------------------------------------------------------
	rand = math.random(200, 350)
	
	bottom = self:wall(rand, 250, 0, 0)
	
	
	--some spring bounds
	springBound1 = self:springBound(rand - 31, 225, 0, 60)
	springBound2 = self:springBound(rand + 31, 225, 0, 60)
	
	--self:wall(x + 20, 230, 1, 50)
	--self:wall(x - 15, 230, 1, 50)
	
	self.spring = Bitmap.new(Texture.new("images/Springs.png", true))
	self.spring:setAnchorPoint(0.5, 1)
	self.spring:setPosition(rand, 265)
	self.spring.original = self.spring:getHeight()
	self:addChild(self.spring)
	
	self.springTop = self:CreateSpring(rand, 235)
	
	local jointDef = b2.createDistanceJointDef(self.springTop.body, bottom.body, rand, 235, rand, 265)
	local distanceJoint = self.world:createJoint(jointDef)
	distanceJoint:setLength(65)
	distanceJoint:setDampingRatio(0.5)
	distanceJoint:setFrequency(5)
	------------------------------------------------------------------------------
	
	--Out Stage Game Background
	--self:GameBackground2()
	
	--Create GameStage 1
	self:GameStage()
	
	--Create GameStage 2
	--self:GameStage2()
	
	--Create Pumpkin box2d
	self.pumpkin = self:createPumpkin(38, 180)
	self.pumpkin:setVisible(false)
	--print("Mass of Pumpkin = " .. self.pumpkin.body:getMass())
	
	--self.pumpkin = self:createPumpkin(rand, 0)
	--self.pumpkin.body:setLinearVelocity(0, 60)
	--self.pumpkin.body:applyForce(0, 2111, 0, 0)
	
	--Add Life
	self:addLife(30)
	
	--Draw Target Lines
	self:drawLines()
	
	--Add Scale Numbers
	self:addScaleNum()
	
	self:actions()
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT + b2.DebugDraw.JOINT_BIT)
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)	
end
	
function LoadGame:actions()
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self);
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self);
	
	--remove event on exiting scene
	self:addEventListener("exitBegin", self.onExitBegin, self);
	
	function onMouseDown(event)
		--print("ABC")
		if pumpkinStick:hitTestPoint(event.x, event.y) then
			isClicked = true
			pumpkinStick:setVisible(true)
			stick:setVisible(false)
			self.pumpkin:setVisible(false)
			self.pumpkin.body:setPosition(38, 180)
			--pumpkinStick.startpoint.x = event.x
			--pumpkinStick.startpoint.y = event.y
			--pumpkinStick:removeEventListener(Event.MOUSE_DOWN, onMouseDown)
		end
	end
	
	function onMouseMove(event)
		if isClicked == true then
			self.pumpkin:setVisible(false)
			pumpkinStick:setVisible(true)
			stick:setVisible(false)
			local a = math.atan((event.y - pumpkinStick:getY()) / (event.x - pumpkinStick:getX())) * 180 / math.pi
			if math.ceil(a) <= -25 then
				pumpkinStick:setRotation(-25)
				pumpkinStick:setVisible(true)
				stick:setVisible(false)
			elseif math.ceil(a) >= 25 then
				pumpkinStick:setRotation(25)
				pumpkinStick:setVisible(true)
				stick:setVisible(false)
			else
				pumpkinStick:setRotation(a)
			end
			--pumpkinStick:removeEventListener(Event.MOUSE_MOVE, onMouseMove)
			
			--[[xImpulse = math.cos(pumpkinStick:getRotation() * math.pi / 180) * 10
			yImpulse = math.sin(pumpkinStick:getRotation() * math.pi / 180) * 10
			print(math.random(8,11))
			print("pumpkinStick:getRotation = " .. (pumpkinStick:getRotation() * math.pi / 180) * 10)
			print("xImpulse = " .. xImpulse)
			print("yImpulse = " .. yImpulse)]]
			
			--xVect = (pumpkinStick.startpoint.x-event.x)
			--yVect = (pumpkinStick.startpoint.y-event.y)
			--print("xVect = " .. xVect)
			--print("yVect = " .. yVect)
			
			--pumpkinStick.startpoint.x = event.x
			--pumpkinStick.startpoint.y = event.y
			
		end
	end
	
	function onMouseUp(event)
		if isClicked == true then
			local theta
			if pumpkinStick:getRotation() > 0 then
				theta = 50 - pumpkinStick:getRotation()
			elseif pumpkinStick:getRotation() < 0 then
				theta = 25 - (-1 * pumpkinStick:getRotation())
			else
				theta = 12
			end
			--print("Hello" .. theta)
			-- if theta is less then the speed should be more
			-- as we drag down the angle changes from 25 to 0
			
			
			--print(pumpkinStick:getRotation())
			--print("Theta " .. theta)
			--local strength = 1
			--local xVect = (pumpkinStick.startpoint.x-event.x)*strength
			--local yVect = (pumpkinStick.startpoint.y-event.y)*strength
			--xImpulse = math.cos(theta) * strength
			xImpulse = ((25 - theta) / 25) * 8 --* self.pumpkin:getX())
			yImpulse = (-1 * xImpulse) - 2 --* self.pumpkin:getY())
			--print(yImpulse)
			pumpkinStick:setRotation(25)
			stick:setVisible(true)
			pumpkinStick:setVisible(false)
			self.pumpkin:setVisible(true)
			if xImpulse < 4 and xImpulse ~= 0 then
				xImpulse = 4
			end
			local x, y = self.pumpkin.body:getPosition()
			self.pumpkin.body:applyLinearImpulse(xImpulse*50 , yImpulse*50, x, y)
			flag = 1
			isClicked = false
		end
		
	end

	-- register for mouse events
	pumpkinStick:addEventListener(Event.MOUSE_DOWN, onMouseDown)
	pumpkinStick:addEventListener(Event.MOUSE_MOVE, onMouseMove)
	pumpkinStick:addEventListener(Event.MOUSE_UP, onMouseUp)
end

function LoadGame:validateEnteredValue(enteredValue)
	--print(enteredValue)
	local pumPosition = math.ceil(self.pumpkin:getX())
	if (pumPosition >= 150 and pumPosition < 190 and enteredValue == 0) or (pumPosition > 190 and pumPosition < 270 and enteredValue == 1) or (pumPosition > 270 and pumPosition < 350 and enteredValue == 2) or (pumPosition > 350 and pumPosition == 430 and enteredValue == 3) or (pumPosition > 430 and pumPosition <= 470 and enteredValue == 4) then
		-- show correct message
		
	elseif  (pumPosition == 190 and enteredValue == 0.5) or (pumPosition == 270 and enteredValue == 1.5) or (pumPosition == 350 and enteredValue == 2.5) or (pumPosition == 430 and enteredValue == 3.5) then
		-- show correct message
		
	else
	end
end

function LoadGame:calculateScore()
	local pumPosition = math.ceil(self.pumpkin:getX())
	if pumPosition == 150 or pumPosition == 230 or pumPosition == 310 or pumPosition == 390 or pumPosition == 470 then
		-- Provide bonus.
		bonus = bonus + 1
		score = score + 100
	elseif pumPosition == 190 or pumPosition == 270 or pumPosition == 350 or pumPosition == 430 then
		-- provide score
		score = score + 50
	else
		-- provide less score
		score = score + 20
	end
	--print(pumPosition)
	
	stage:removeChild(sScore)
	sScore = TextField.new(nil, score)
	--sScore = TextField.new(TTFont.new("font/tahoma.ttf", 12), score)
	sScore:setPosition(245, 30)
	sScore:setTextColor(0x31B404)
	stage:addChild(sScore)
	
	stage:removeChild(sBonus)
	sBonus = TextField.new(nil, bonus)
	--sBonus = TextField.new(TTFont.new("font/tahoma.ttf", 12), bonus)
	sBonus:setPosition(370, 30)
	sBonus:setTextColor(0x31B404)
	stage:addChild(sBonus)
end

function LoadGame:showPopup()
	
	function onComplete(event)
		if event.buttonText == "OK" then
			if event.text ~= "" then
				if life > 0 then
					life = life - 1
					if life == 2 then
						life2:setVisible(false)
					elseif life == 1 then
						life1:setVisible(false)
					elseif life == 0 then
						life0:setVisible(false)
					end
					bushes1:setX(0)
					bushes2:setX(480)
					
					surface21:setX(0);
					surface22:setX(480);
					
					house11:setX(10);
					house12:setX(630);
					
					house21:setX(385);
					house22:setX(780);
					
					surface11:setX(0);
					surface12:setX(480);
					
					base1:setX(0);
					base2:setX(480);
					
					stand:setX(60);
					
					pumpkinStick:setX(75);
					
					stick:setX(73);
					
					--lineLayer:setX(150)
					--textLayer:setX(148)
					lineLayer:setPosition(0, 0)
					textLayer:setPosition(0, 0)
					self.spring:setX(rand)
					bottom.body:setPosition(rand, 250)
					springBound1.body:setPosition(rand - 31, 225)
					springBound2.body:setPosition(rand + 31, 225)
					self.springTop.body:setPosition(rand, 200.62121582031)
					
					--self.springTop.body:setPosition(rand, self.springTop:getY())
					
					--self.spring.body:setPosition(, math.ceil(self.spring:getY()))
					--self.springTop.body:setPosition(, math.ceil(self.springTop:getY()))
					
					self:validateEnteredValue(event.text)
					self:calculateScore()
					self.pumpkin.body:setPosition(38, 180)
					self.pumpkin:setVisible(false)
					pumpkinStick:setVisible(true)
					stick:setVisible(false)
				else
					self:calculateScore()
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

-- for creating objects using shape
-- as example - bounding walls
function LoadGame:wall(x, y, width, height)
	local wall = Shape.new()
	wall:setFillStyle(Shape.SOLID, 0xff0000) 
	--Define Wall Shape
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
	local fixture = body:createFixture{shape = poly, density = -0.5, friction = 5, restitution = 0.1}
	fixture:setFilterData({categoryBits = 1, maskBits = 14})
	wall.body = body
	wall.body.type = "wall"
	
	--add to scene
	self:addChild(wall)
	
	--return created object
	return wall
end

function LoadGame:springBound(x, y, width, height)
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

--[[function LoadGame:PositionReset1(bushesSpeed, Surface2Speed, House1Speed, House2Speed, Surface1Speed, BaseSpeed)
	--print(bushesSpeed .. Surface2Speed .. House1Speed .. House2Speed .. Surface1Speed .. BaseSpeed)
	bushes1:setPosition(0 - bushesSpeed, 100);
	surface21:setPosition(0 - Surface2Speed, 130);
	house11:setPosition(20 - House1Speed, 40);
	house21:setPosition(385 - House2Speed, 50);
	surface11:setPosition(0 - Surface1Speed, 160);
	base1:setPosition(0 - BaseSpeed, 255);
	stand:setPosition(60 - BaseSpeed, 227);
	pumpkinStick:setPosition(75 - BaseSpeed,207);
	stick:setPosition(73 - BaseSpeed,212);
end]]

function LoadGame:GameBackground1()
	-- Bushes on Screen
	bushes1 = Bitmap.new(Texture.new("images/Bushes.png"));
	bushes1:setPosition(0, 100);
	stage:addChild(bushes1);
	-- Bushes outside Screen
	bushes2 = Bitmap.new(Texture.new("images/Bushes.png"));
	bushes2:setPosition(480, 100);
	stage:addChild(bushes2);
	
	-- Surface 2 on Screen
	surface21 = Bitmap.new(Texture.new("images/Surface2.png"));
	surface21:setPosition(0, 130);
	stage:addChild(surface21);
	-- Surface 2 outside Screen
	surface22 = Bitmap.new(Texture.new("images/Surface2.png"));
	surface22:setPosition(480, 130);
	stage:addChild(surface22);
	
	-- House 1 on Screen
	house11 = Bitmap.new(Texture.new("images/House1.png"));
	house11:setPosition(10, 20);
	stage:addChild(house11);
	-- House 1 outside Screen
	house12 = Bitmap.new(Texture.new("images/House1.png"));
	house12:setPosition(630, 50);
	stage:addChild(house12);
	
	-- House 2 on Screen
	house21 = Bitmap.new(Texture.new("images/House2.png"));
	house21:setPosition(385, 60);
	stage:addChild(house21);
	-- House 2 outside Screen
	house22 = Bitmap.new(Texture.new("images/House2.png"));
	house22:setPosition(780, 40);
	stage:addChild(house22);
	
	-- Surface 1 on Screen
	surface11 = Bitmap.new(Texture.new("images/Surface1.png"));
	surface11:setPosition(0, 160);
	stage:addChild(surface11);
	-- Surface 1 outside Screen
	surface12 = Bitmap.new(Texture.new("images/Surface1.png"));
	surface12:setPosition(480, 160);
	stage:addChild(surface12);
	
	-- Base on Screen
	base1 = Bitmap.new(Texture.new("images/Base.png"));
	base1:setPosition(0, 255);
	stage:addChild(base1);
	-- Base outside Screen
	base2 = Bitmap.new(Texture.new("images/Base.png"));
	base2:setPosition(480, 255);
	stage:addChild(base2);
	
	------------------------------------------------------------------------------------------
	--stage:addChild(CreateSpring.new());
	
	------------------------------------------------------------------------------------------
	
	-- Stand
	stand = Bitmap.new(Texture.new("images/Stand.png"));
	stand:setPosition(60, 227);
	stage:addChild(stand);
	
	-- Stick with Pumpkin
	pumpkinStick = Bitmap.new(Texture.new("images/StickWithPumpkin.png"));
	pumpkinStick:setPosition(75,207);
	pumpkinStick:setRotation(25);
	pumpkinStick:setAnchorPoint(0.5,0.5);
	stage:addChild(pumpkinStick);
	pumpkinStick:setVisible(true);
	
	-- Stick Without Pumpkin
	stick = Bitmap.new(Texture.new("images/PumpkinHolder.png"));
	stick:setPosition(73,212);
	stick:setRotation(25);
	stick:setAnchorPoint(0.5,0.5);
	stage:addChild(stick);
	stick:setVisible(false);
	
	--self.PositionReset1(0, 0, 0, 0, 0, 0, 0)

	--bgLayer1 = Sprite.new()
	--function createBackground(xPos, yPos, imageName)
	--	local img1 = Bitmap.new(Texture.new(imageName));
	--	bgLayer1:addChild(img1)
	--	img1:setPosition(xPos, yPos)
	--end
	
	--createBackground(0, 100, "images/Bushes.png")
	--createBackground(0, 130, "images/Surface2.png")
	--createBackground(20, 40, "images/House1.png")
	--createBackground(385, 50, "images/House2.png")
	--createBackground(0, 160, "images/Surface1.png")
	--createBackground(0, 255, "images/Base.png")
	--createBackground(60, 227, "images/Stand.png")
	
	--stage:addChild(bgLayer1)
	--pumpkinStick.startpoint = {}	
end



--[[function LoadGame:PositionReset2(bushesSpeed, Surface2Speed, House1Speed, House2Speed, Surface1Speed, BaseSpeed)
	--print(bushesSpeed .. Surface2Speed .. House1Speed .. House2Speed .. Surface1Speed .. BaseSpeed)
	bushes2:setPosition(480 - bushesSpeed, 100);
	surface22:setPosition(480 - Surface2Speed, 130);
	house12:setPosition(500 - House1Speed, 40);
	house22:setPosition(865 - House2Speed, 50);
	surface12:setPosition(480 - Surface1Speed, 160);
	base2:setPosition(480 - BaseSpeed, 255);
end]]

--[[function LoadGame:GameBackground2()
	-- Bushes
	bushes2 = Bitmap.new(Texture.new("images/Bushes.png"));
	bushes2:setPosition(480, 100);
	stage:addChild(bushes2);
	
	-- Surface 2
	surface22 = Bitmap.new(Texture.new("images/Surface2.png"));
	surface22:setPosition(480, 130);
	stage:addChild(surface22);
	
	-- House 1
	house12 = Bitmap.new(Texture.new("images/House1.png"));
	house12:setPosition(500, 40);
	stage:addChild(house12);
	
	-- House 2
	house22 = Bitmap.new(Texture.new("images/House2.png"));
	house22:setPosition(865, 50);
	stage:addChild(house22);
	
	-- Surface 1
	surface12 = Bitmap.new(Texture.new("images/Surface1.png"));
	surface12:setPosition(480, 160);
	stage:addChild(surface12);
	
	-- Base
	base2 = Bitmap.new(Texture.new("images/Base.png"));
	base2:setPosition(480, 255);
	stage:addChild(base2);
	
	--self.PositionReset2(0, 0, 0, 0, 0, 0, 0)
	bgLayer2 = Sprite.new()
	function createBackground(xPos, yPos, imageName)
		local img2 = Bitmap.new(Texture.new(imageName));
		bgLayer2:addChild(img2)
		img2:setPosition(xPos, yPos)
	end
	
	createBackground(480, 100, "images/Bushes.png")
	createBackground(480, 130, "images/Surface2.png")
	createBackground(500, 40, "images/House1.png")
	createBackground(865, 50, "images/House2.png")
	createBackground(480, 160, "images/Surface1.png")
	createBackground(480, 255, "images/Base.png")
	--createBackground(540, 227, "images/Stand.png")
	
	stage:addChild(bgLayer2)
end]]

function LoadGame:GameStage()
	--local isClicked = false;
	--playTune("sounds/BackGroundSound.mp3")
	--endTune:stop()
	
	--bgLayer = Sprite.new()
	--bushes = Bitmap.new(Texture.new("images/Bushes.png"));
	--bushes:setPosition(0, 100);
	--stage:addChild(bushes);
	
	--surface2 = Bitmap.new(Texture.new("images/Surface2.png"));
	--surface2:setPosition(0, 130);
	--stage:addChild(surface2);
	
	--house1 = Bitmap.new(Texture.new("images/House1.png"));
	--house1:setPosition(20, 40);
	--stage:addChild(house1);
	
	--house2 = Bitmap.new(Texture.new("images/House2.png"));
	--house2:setPosition(385, 50);
	--stage:addChild(house2);
	
	--surface1 = Bitmap.new(Texture.new("images/Surface1.png"));
	--surface1:setPosition(0, 160);
	--stage:addChild(surface1);
	
	--stage:addChild(CreateSpring.new());
	
	--base = Bitmap.new(Texture.new("images/Base.png"));
	--base:setPosition(0, 255);
	--stage:addChild(base);
	
	--stand = Bitmap.new(Texture.new("images/Stand.png"));
	--stand:setPosition(60, 227);
	--stage:addChild(stand);

	
	lblScore = TextField.new(nil, "Score : ")
	--lblScore = TextField.new(TTFont.new("font/tahoma.ttf", 12), "Score : ")
	lblScore:setPosition(200, 30)
	lblScore:setTextColor(0x31B404)
	stage:addChild(lblScore)
	
	lblBonus = TextField.new(nil, "Target Hit : ")
	--lblBonus = TextField.new(TTFont.new("font/tahoma.ttf", 12), "Target Hit : ")
	lblBonus:setPosition(300, 30)
	lblBonus:setTextColor(0x31B404)
	stage:addChild(lblBonus)
	
	sScore = TextField.new(nil, score)
	--sScore = TextField.new(TTFont.new("font/tahoma.ttf", 12), score)
	sScore:setPosition(245, 30)
	sScore:setTextColor(0x31B404)
	stage:addChild(sScore)
	
	sBonus = TextField.new(nil, bonus)
	--sBonus = TextField.new(TTFont.new("font/tahoma.ttf", 12), bonus)
	sBonus:setPosition(370, 30)
	sBonus:setTextColor(0x31B404)
	stage:addChild(sBonus)
end

function LoadGame:createPumpkin(x, y)
	
	--create ball bitmap object from ball graphic
	pumpkin = Bitmap.new(Texture.new("images/Pumpkin.png"))
	--reference center of the ball for positioning
	pumpkin:setAnchorPoint(0.5,0.5)
	
	--print("Hello Sushil X = " .. x .. " and Y = " .. y)
	pumpkin:setPosition(x,y)
	
	
	--get radius
	local radius = pumpkin:getWidth()/2
	
	--create box2d physical object
	local body = self.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(pumpkin:getX(), pumpkin:getY())
	body:setAngle(pumpkin:getRotation() * math.pi/180)
	local circle = b2.CircleShape.new(0, 0, radius)
	local fixture = body:createFixture{shape = circle, density = 100, friction = 10, restitution = 0.1}
	fixture:setFilterData({categoryBits = 2, maskBits = 9})
	pumpkin.body = body
	pumpkin.body.type = "pumpkin"
	
	--add to scene
	self:addChild(pumpkin)
	
	--return created object
	return pumpkin
end

function LoadGame:CreateSpring(x, y)
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

function LoadGame:addLife(nofl)
	function addPumpkin(x, y)
		exLife = Bitmap.new(Texture.new("images/Pumpkin.png"))
		exLife:setPosition(x, y)
		stage:addChild(exLife)
		return exLife
	end
	
	life0 = addPumpkin(15, 10)
	life1 = addPumpkin(45, 10)
	life2 = addPumpkin(75, 10)
end

function LoadGame:drawLines()
	function newLine(xPos, yPos, x, y, thikness)
		line = Shape.new()
		line:setLineStyle(thikness, 0x000000, 1)
		line:beginPath()
		line:moveTo(0,0)
		line:lineTo(x, y)
		line:endPath()
		lineLayer:addChild(line)
		line:setPosition(xPos, yPos)
	end
	
	--for horizontal line
	newLine(0, 255, 480, 0, 1)
	--for vertical lines
	newLine(150, 256, 0, 5, 2) --line for 0
	newLine(190, 256, 0, 3, 2) --line for 0.5
	newLine(230, 256, 0, 5, 2) --line for 1
	newLine(270, 256, 0, 3, 2) --line for 1.5
	newLine(310, 256, 0, 5, 2) --line for 2
	newLine(350, 256, 0, 3, 2) --line for 2.5
	newLine(390, 256, 0, 5, 2) --line for 3
	newLine(430, 256, 0, 3, 2) --line for 3.5
	newLine(470, 256, 0, 5, 2) --line for 4
	
	newLine(510, 256, 0, 3, 2) --line for 4.5
	newLine(550, 256, 0, 5, 2) --line for 5
	newLine(590, 256, 0, 3, 2) --line for 5.5
	newLine(630, 256, 0, 5, 2) --line for 6
	newLine(670, 256, 0, 3, 2) --line for 6.5
	newLine(710, 256, 0, 5, 2) --line for 7
	newLine(750, 256, 0, 3, 2) --line for 7.5
	newLine(790, 256, 0, 5, 2) --line for 8
	
	newLine(830, 256, 0, 3, 2) --line for 8.5
	newLine(870, 256, 0, 5, 2) --line for 9
	newLine(910, 256, 0, 3, 2) --line for 9.5
	newLine(950, 256, 0, 5, 2) --line for 10
	newLine(990, 256, 0, 3, 2) --line for 10.5
	newLine(1030, 256, 0, 5, 2) --line for 11
	newLine(1070, 256, 0, 3, 2) --line for 11.5
	newLine(1110, 256, 0, 5, 2) --line for 12
	
	newLine(1150, 256, 0, 3, 2) --line for 12.5
	newLine(1190, 256, 0, 5, 2) --line for 13
	newLine(1230, 256, 0, 3, 2) --line for 13.5
	newLine(1270, 256, 0, 5, 2) --line for 14
	newLine(1310, 256, 0, 3, 2) --line for 14.5
	newLine(1350, 256, 0, 5, 2) --line for 15
	newLine(1390, 256, 0, 3, 2) --line for 15.5
	newLine(1430, 256, 0, 5, 2) --line for 16
	
	newLine(1470, 256, 0, 3, 2) --line for 16.5
	newLine(1510, 256, 0, 5, 2) --line for 17
	newLine(1550, 256, 0, 3, 2) --line for 17.5
	newLine(1590, 256, 0, 5, 2) --line for 18
	newLine(1630, 256, 0, 3, 2) --line for 18.5
	newLine(1670, 256, 0, 5, 2) --line for 19
	newLine(1710, 256, 0, 3, 2) --line for 19.5
	newLine(1750, 256, 0, 5, 2) --line for 20
	
	stage:addChild(lineLayer)
	lineLayer:setPosition(0, 0)
end

function LoadGame:addScaleNum()
	function addText(x, y, txt)
		text = TextField.new(nil, txt)
		--text = TextField.new(TTFont.new("font/tahoma.ttf", 10), txt)
		text:setPosition(x, y)
		textLayer:addChild(text)
	end
	
	addText(148, 270, 0) 	-- text 0
	addText(184, 268, 0.5)	-- text 0.5
	addText(228, 270, 1) 	-- text 1
	addText(265, 268, 1.5) 	-- text 1.5
	addText(308, 270, 2) 	-- text 2
	addText(345, 268, 2.5) 	-- text 2.5
	addText(388, 270, 3) 	-- text 3
	addText(425, 268, 3.5) 	-- text 3.5
	addText(467, 270, 4)   	-- text 4
	
	addText(504, 268, 4.5)	-- text 4.5
	addText(548, 270, 5) 	-- text 5
	addText(584, 268, 5.5) 	-- text 5.5
	addText(628, 270, 6) 	-- text 6
	addText(664, 268, 6.5) 	-- text 6.5
	addText(708, 270, 7) 	-- text 7
	addText(744, 268, 7.5) 	-- text 7.5
	addText(788, 270, 8)   	-- text 8
	
	addText(825, 268, 8.5)	-- text 8.5
	addText(869, 270, 9) 	-- text 9
	addText(904, 268, 9.5) 	-- text 9.5
	addText(945, 270, 10) 	-- text 10
	addText(980, 268, 10.5) 	-- text 10.5
	addText(1025, 270, 11) 	-- text 11
	addText(1061, 268, 11.5) 	-- text 11.5
	addText(1105, 270, 12)   	-- text 12
	
	addText(1140, 268, 12.5)	-- text 12.5
	addText(1185, 270, 13) 	-- text 13
	addText(1220, 268, 13.5) 	-- text 13.5
	addText(1265, 270, 14) 	-- text 14
	addText(1300, 268, 14.5) 	-- text 14.5
	addText(1346, 270, 15) 	-- text 15
	addText(1380, 268, 15.5) 	-- text 15.5
	addText(1426, 270, 16)   	-- text 16
	
	addText(1460, 268, 16.5)	-- text 16.5
	addText(1505, 270, 17) 	-- text 17
	addText(1540, 268, 17.5) 	-- text 17.5
	addText(1585, 270, 18) 	-- text 18
	addText(1620, 268, 18.5) 	-- text 18.5
	addText(1665, 270, 19) 	-- text 19
	addText(1700, 268, 19.5) 	-- text 19.5
	addText(1745, 270, 20)   	-- text 20
	
	stage:addChild(textLayer)
	textLayer:setPosition(0, 0)
end


-- for creating objects using image
-- as example - pumpkin
function LoadGame:onBeginContact(e)
	--getting contact bodies
    local fixtureA = e.fixtureA
    local fixtureB = e.fixtureB
    local bodyA = fixtureA:getBody()
    local bodyB = fixtureB:getBody()
     
    --check if first colliding body is a ball
    if bodyA.type and bodyA.type == "pumpkin" then
		bodyA.velX, bodyA.velY = bodyA:getLinearVelocity()
		bodyA:setLinearVelocity(0, 0)
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


--running the world
function LoadGame:onEnterFrame() 
	--print(math.ceil(self.pumpkin:getX()) .. " and " .. math.ceil(self.pumpkin:getY()))
	--print(lineLayer:getPosition())
	--sPositionX = self.spring:getX()
	--stPostitionX = self.springTop:getX()
	
	--print(sPositionX)
	--print(stPostitionX)
	
	self.world:step(1/60, 8, 3)
	--print("Flag = " .. flag)
	
	--[[if flag == 1 then
		--flag = 0
		local lvX, lvY = self.pumpkin.body:getLinearVelocity()
		local pX, pY = self.pumpkin.body:getPosition()
		lvX = math.ceil(lvX)
		lvY = math.ceil(lvY)
		pX = math.ceil(pX)
		pY = math.ceil(pY)
		--print(lvX .. " Linear Velocity " .. lvY)
		--print(pX .. " Pumpkin Position " .. pY)
		--print(math.ceil(self.pumpkin:getY()))
		
		if math.ceil(lvX) == 0 or math.ceil(lvY) == 0 then
			local x1, y1 = bgLayer1:getPosition()
			bgLayer1:setPosition(x1, y1)
			print("Hello ")
			local x2, y2 = bgLayer2:getPosition()
			bgLayer2:setPosition(x2, y2)
		end
		if math.ceil(self.pumpkin:getX()) >= application:getContentWidth() / 2 then
		--print(lineLayer:getPosition())
			--print(lvX .. " Linear Velocity " .. lvY)
			bushes1:setX(bushes1:getX() - lvX / 4.5)
			bushes2:setX(bushes2:getX() - lvX / 4.5)
			if math.ceil(bushes1:getX()) == -480 then
				bushes1:setX(480)
			end
			
			if math.ceil(bushes2:getX()) == -480 then
				bushes2:setX(480)
			end
			
			surface21:setX(surface21:getX() - lvX / 3.5);
			surface22:setX(surface22:getX() - lvX / 3.5);
			if math.ceil(surface21:getX()) == -480 then
				surface21:setX(480)
			end
			
			if math.ceil(surface22:getX()) == -480 then
				surface22:setX(480)
			end
			
			house11:setX(house11:getX() - lvX / 2.5);
			house12:setX(house12:getX() - lvX / 2.5);
			if math.ceil(house11:getX()) == -480 then
				house11:setX(480)
			end
			
			if math.ceil(house12:getX()) == -480 then
				house12:setX(480)
			end
			
			house21:setX(house21:getX() - lvX / 2);
			house22:setX(house22:getX() - lvX / 2);
			if math.ceil(house21:getX()) == -480 then
				house21:setX(480)
			end
			
			if math.ceil(house22:getX()) == -480 then
				house22:setX(480)
			end
			
			
			--layer:setX(layer:getX() - lvX / 3)
			
			surface11:setX(surface11:getX() - lvX / 2);
			surface12:setX(surface12:getX() - lvX / 2);
			if math.ceil(surface11:getX()) == -480 then
				surface11:setX(480)
			end
			
			if math.ceil(surface12:getX()) == -480 then
				surface12:setX(480)
			end
			
			
			self.pumpkin.body:applyForce(-4, 4, 0.5, 0.5)
			--self.pumpkin.body:setLinearVelocity(lvX - 1/30, lvY + 1/30)
			--self.pumpkin.body:applyLinearImpulse(math.ceil(self.pumpkin:getX()) - lvX / 3, math.ceil(self.pumpkin:getY()), 0, 0)
			--self.pumpkin.body:setPosition(self.pumpkin:getX() - 3, self.pumpkin:getY())
			
			
			base1:setX(base1:getX() -  lvX / 3.5);
			base2:setX(base2:getX() -  lvX / 3.5);
			if math.ceil(base1:getX()) == -480 then
				base1:setX(480)
			end
			
			if math.ceil(base2:getX()) == -480 then
				base2:setX(480)
			end
			
			stand:setX(stand:getX() - lvX / 3);
			
			pumpkinStick:setX(pumpkinStick:getX() - lvX / 3);
			
			stick:setX(stick:getX() - lvX / 3);
			
			--print(self.spring:getX())
			--self.spring.body:setPosition(math.ceil(self.spring:getX()) - 2, math.ceil(self.spring:getY()))
			--self.springTop.body:setPosition(math.ceil(self.springTop:getX()) - 2, math.ceil(self.springTop:getY()))
			
			lineLayer:setX(lineLayer:getX() - lvX / 3.5)
			textLayer:setX(textLayer:getX() - lvX / 3.5)
			--textLayer:setX(textLayer:getX() - lvX / 2)
			
			self.spring:setX(self.spring:getX() - lvX / 3.5)
			local x, y = bottom.body:getPosition()
			local p, q = springBound1.body:getPosition()
			local a, b = springBound2.body:getPosition()
			local i, j = self.springTop.body:getPosition()
			--print("I = " .. i .. " J = " .. j)
			bottom.body:setPosition(x - lvX / 3.5, y)
			springBound1.body:setPosition(p - lvX / 3.5, q)
			springBound2.body:setPosition(a - lvX / 3.5, b)
			self.springTop.body:setPosition(i - lvX / 3.5, j)
			--bottom.body:setPosition(bottom:getX() - lvX / 3.5, bottom:getY())
			--self.springTop:setPosition(-self.springTop:getX() + application:getContentWidth() / 2, -self.springTop:getY() + application:getContentWidth() / 2)
			--self.springTop.body:setPosition(self.springTop:getX() - lvX / 3.5, self.springTop:getY())
			
			if base1:getX() == -480 then
				bushes1:setX(480)
				surface21:setX(480);
				house11:setX(630);
				house21:setX(780);
				surface11:setX(480);
				base1:setX(480);
			end
			
			
			
		end
			
		if lvX == 0 and lvY == 0 and pX ~= 38 and pY ~= 180 and math.ceil(self.pumpkin:getY()) == 243 then
			self:showPopup()
			flag = 0
		end
	end]]
	
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
	
	--update spring
	local distance = self.spring:getY() - self.springTop:getY()
	local newScale=distance/self.spring.original
	local oldScale = self.spring:getScaleY()
	self.spring:setScaleY(newScale)
	if self.spring.colliding and oldScale < newScale and newScale > 0.75 then
		self.spring.colliding = false
		self.pumpkin.body:setLinearVelocity(self.pumpkin.body.velX, self.pumpkin.body.velY*-1)
	end
		
end

function LoadGame:endGame()
	endTune:stop()
	playTune("sounds/StartEnd.mp3")
	
	pumpkinStick:removeEventListener(Event.MOUSE_DOWN, onMouseDown)
	pumpkinStick:removeEventListener(Event.MOUSE_MOVE, onMouseMove)
	pumpkinStick:removeEventListener(Event.MOUSE_UP, onMouseUp)
	textInputDialog:removeEventListener(Event.COMPLETE, onComplete)
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	for i = 1, stage:getNumChildren() do
		stage:removeChildAt(1)
	end
	
	--[[stage:removeChild(bushes)
	--bushes = nil
	stage:removeChild(surface2)
	--surface2 = nil
	stage:removeChild(surface1)
	--surface1 = nil
	stage:removeChild(house1)
	--house1 = nil
	stage:removeChild(house2)
	--house2 = nil
	stage:removeChild(stand)
	--stand = nil
	stage:removeChild(stick)
	--stick = nil
	stage:removeChild(pumpkinStick)
	--pumpkinStick = nil
	stage:removeChild(base)
	--base = nil
	
	stage:removeChild(self) -- to remove pumpkin
	--self = nil
	
	stage:removeChild(line)]]
	
	local bg = Bitmap.new(Texture.new("images/Background.png"));
	bg:setPosition(0,0)
	stage:addChild(bg)
	
	myScore = TextField.new(nil, "Total Score : " .. score)
	--myScore = TextField.new(TTFont.new("font/tahoma.ttf", 20), "Total Score : " .. score)
	myScore:setPosition(math.floor((application:getContentWidth() - myScore:getWidth())/2), 100)
	myScore:setScale(2)
	stage:addChild(myScore)
	
	targetHit = TextField.new(nil, "Total Target Hit : " .. bonus)
	--targetHit = TextField.new(TTFont.new("font/tahoma.ttf", 20), "Total Target Hit : " .. bonus)
	targetHit:setPosition(math.floor((application:getContentWidth() - targetHit:getWidth())/2), 130)
	targetHit:setScale(2)
	stage:addChild(targetHit)
	
	--[[stage:removeChild(sScore)
	--sScore = nil
	stage:removeChild(sBonus)
	--sBonus = nil
	stage:removeChild(lblBonus)
	--lblBonus = nil
	stage:removeChild(lblScore)
	--lblScore = nil]]
	
	local function playTouch(imgPlayBtn, event)
		-- See if the Start Button object was touched
		if imgPlayBtn:hitTestPoint(event.touch.x, event.touch.y) then
			imgPlayBtn:removeEventListener(Event.TOUCHES_END, playTouch)
			-- Clean up our objects
			--stage:removeChild(imgPlayBtn)
			--imgPlayBtn=nil
			--stage:removeChild(myScore)
			--myScore = nil
			--stage:removeChild(targetHit)
			--targetHit = nil
			
			for i = 1, stage:getNumChildren() do
				stage:removeChildAt(1)
			end
			
			endTune:stop()
			stage:addChild(LoadGame.new(1));
		end
	end
	
	local playBtn = Bitmap.new(Texture.new("images/Play.png"));
	playBtn:setAnchorPoint(0.5,0.5)
	playBtn:setPosition(math.floor((application:getContentWidth() - playBtn:getWidth())/2), 200)
	stage:addChild(playBtn)
	playBtn:addEventListener(Event.TOUCHES_BEGIN, playTouch, playBtn)
	
end

--removing event on exiting scene
--just in case you're using SceneManager
function LoadGame:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
  pumpkinStick:removeEventListener(Event.MOUSE_DOWN, onMouseDown)
  pumpkinStick:removeEventListener(Event.MOUSE_MOVE, onMouseMove)
  pumpkinStick:removeEventListener(Event.MOUSE_UP, onMouseUp)
end

local mainScene = LoadGame.new()
stage:addChild(mainScene)