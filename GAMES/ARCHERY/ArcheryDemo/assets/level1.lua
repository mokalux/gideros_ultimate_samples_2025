require "box2d"

level1 = Core.class(Sprite)

local playBtn
local reloadBtn

local playClicked
local myScene
local arrow_dir
local soccerball

function level1:init()
	application:setBackgroundColor(0xcccccc)
	myScene =self
	playClicked=false

	--create world instance
	self.world = b2.World.new(0, 9.8, true)

	--set up debug drawing
    local debugDraw = b2.DebugDraw.new()
    self.world:setDebugDraw(debugDraw)
--    self:addChild(debugDraw)

	--Play Button
	playBtn = Bitmap.new(Texture.new("Images/GamePlay/btn_play.png",true))
	playBtn:setAnchorPoint(0.5,0.5)
	playBtn:setScale(0.75,0.75)
	playBtn:setPosition(screenW-playBtn:getWidth()*1.05,screenH+dy-playBtn:getHeight()*0.75)
	self:addChild(playBtn)

	--Reload Button
	reloadBtn = Bitmap.new(Texture.new("Images/GamePlay/btn_relod.png",true))
	reloadBtn:setAnchorPoint(0.5,0.5)
	reloadBtn:setScale(0.75,0.75)
	reloadBtn:setPosition(screenW *0.8,screenH*0.1)
	self:addChild(reloadBtn)

	-- Arrow which will contineously rotate within 0 to 90 degrees.
	arrow_dir =  Bitmap.new(Texture.new("Images/GamePlay/Arrow.png",true))
	arrow_dir:setAnchorPoint(0.5,0.5)
	arrow_dir.speed=1
	arrow_dir.xdirection=1
	arrow_dir:setPosition(32,320)
	arrow_dir:setRotation(90)
	self:addChild(arrow_dir)

	-- create a ball bitmap object (Bitmap class inherits from Sprite class)
	soccerball = Bitmap.new(Texture.new("Images/GamePlay/black-arrow-73117.png",true))
	self:addChild(soccerball)
	-- Set the reference points of the ball to its center
	soccerball:setAnchorPoint(0.5, 0.5)
	-- Position the ball finally on the screen
	soccerball:setPosition(32,320)
	soccerball.lastY=soccerball:getY()
	soccerball.lastX=soccerball:getX()
	soccerball:setRotation(0)

	-- register  On Enter Frame events with the world object
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("exitBegin", self.onExitBegin, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)

	--PowerBar
	local myPower = Bitmap.new(Texture.new("Images/GamePlay/power.png"))
	myPower:setAlpha(0.4)
	myPower:setPosition(480 - myPower:getWidth()*1.2,600 - myPower:getHeight())
	myPower.child = drawRect(390,myPower:getY()+200,40,590-myPower:getY()-200)
	myPower.child:setAlpha(0.4)
	self:addChild(myPower.child)
	self:addChild(myPower)

	myScene.strength = myPower.child:getHeight() * 0.0008 + 0.01

	local function onPowerDown(self,event)
		if self:hitTestPoint(event.x,event.y) then
			self.isFocus = true
			self:setAlpha(1)
			if self.child == nil then
				if self:hitTestPoint(self:getX()+10,event.y) then
					self.child = drawRect(390,event.y,40,590-event.y)
				end
			else
				if self:hitTestPoint(self:getX()+10,event.y) then
					self.child:clear()
					self.child = drawRect(390,event.y,40, 590-event.y)
				end
				self.child:setAlpha(1)
			end
			myScene:addChild(self.child)
			self:getParent():addChild(self)
			myScene.strength = self.child:getHeight() * 0.0008 + 0.01
		end
	end
	
	local function onPowerMove(self,event)
		if self.isFocus then
			if self.child == nil then
				if self:hitTestPoint(self:getX()+10,event.y-5) and self:hitTestPoint(self:getX()+10,event.y+5)then
					self.child = drawRect(390,event.y,40,590-event.y)
				end
			else
				if self:hitTestPoint(self:getX()+10,event.y-5) and self:hitTestPoint(self:getX()+10,event.y+5) then
					self.child:clear()
					self.child = drawRect(390,event.y,40, 590-event.y)
				end
			end
			myScene.strength = self.child:getHeight() * 0.0008 + 0.01
			myScene:addChild(self.child)
			self:getParent():addChild(self)
		end
	end
	
	local function onPowerUp(self,event)
		if self.isFocus then
			self.isFocus = false
			self:setAlpha(0.4)
			self:getParent():addChild(self)
			if self.child == nil then
			
			else
				self.child:setAlpha(0.4)
			end
		end
	end
	
	myPower:addEventListener(Event.MOUSE_DOWN,onPowerDown,myPower)
	myPower:addEventListener(Event.MOUSE_MOVE,onPowerMove,myPower)
	myPower:addEventListener(Event.MOUSE_UP,onPowerUp,myPower)
end

function level1:onEnterFrame(event)
	if  (playClicked == false) then
		arrow_dir.speed=math.random(0.5,2.5)
		local x, y = arrow_dir:getRotation()
		if (x >=90) then
			arrow_dir.xdirection=-1
		elseif (x<=0) then	
			arrow_dir.xdirection=1
		end
		x = x + (arrow_dir.speed * arrow_dir.xdirection)
		arrow_dir:setRotation(x)
		--soccerball:setRotation(x)
		--print("X's Direction:"..x)
	end

	if  (playClicked == true) then
		-- edit the step values if required. These are good defaults!
		self.world:step(1/60, 8, 3)
		--iterate through all child sprites
		for i = 1, self:getNumChildren() do
			--get specific sprite
			local sprite = self:getChildAt(i)
			-- check if sprite HAS a body (ie, physical object reference we added)
			if sprite.body then
				--update position to match box2d world object's position
				local body = sprite.body
				local bodyX, bodyY = body:getPosition()
				sprite:setPosition(bodyX, bodyY)
				
				local velX, velY = body:getLinearVelocity()
				local bodyAngle = math.atan2(velY, velX)
				body:setAngle(bodyAngle)
				sprite:setRotation(body:getAngle()* 180/math.pi)
			end
		end
	end
end

function level1:onMouseDown(event)
	if  playBtn:hitTestPoint(event.x, event.y) then
		print("playBtn clicked.")
		playClicked=true

		--get radius
		local radius = soccerball:getWidth()/2

		--create box2d physical object
		local body1 = self.world:createBody{type = b2.DYNAMIC_BODY}
		 --body1:setFixedRotation(true)
		body1:setPosition(soccerball:getX(), soccerball:getY())

		local poly = b2.PolygonShape.new()
		poly:setAsBox(soccerball:getWidth(), soccerball:getHeight())
		local fixture = body1:createFixture{shape = poly, density = 1.0, friction = 0.1, restitution = 0.2}

		soccerball.body = body1
		soccerball.body.type = "ball"

		local myRot = arrow_dir:getRotation()
		myAngle = myRot * math.pi/180
		myScene.strength = myScene.strength * 1000
		local xVect = -math.sin(myAngle-math.pi)*myScene.strength
		local yVect = math.cos(myAngle-math.pi)*myScene.strength
		soccerball.body:applyLinearImpulse(xVect, yVect, soccerball:getX(),soccerball:getY())

	elseif reloadBtn:hitTestPoint(event.x, event.y) then
		sceneManager:changeScene("level1", 1, SceneManager.fade, easing.linear)
	end
end

function level1:onExitBegin()
	self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
end
