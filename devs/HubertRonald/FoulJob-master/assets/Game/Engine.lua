
--[[

	---------------------------------------------
	Fool Job
	a game by hubert ronald
	---------------------------------------------
	a game of liquid puzzle
	Gideros SDK Power and Lua coding.

	Artwork: Kenney Game Assets
			Platform Pack Industrial
			http://kenney.nl/assets/platformer-pack-industrial
	
	Design & Coded
	by Hubert Ronald
	contact: hubert.ronald@gmail.com
	Development Studio: [-] Liasoft
	Date: Aug 26th, 2017
	
	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator

	The MIT License (MIT)
	
	Copyright (C) 2017 Hubert Ronald

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	
	---------------------------------------------
	FILE: MAIN
	---------------------------------------------
	
--]]


----------------------------------------
--	MATH HELPER FUNCTION
----------------------------------------
local max = math.max


----------------------------------------
--	PHYSICS
----------------------------------------
local box2d = require "box2d"



----------------------------------------
--	 HELPER LIBRARY
----------------------------------------
local gtween = require "Library/gtween"
local Button = require "Library/button"
local Camera = require "Library/Camera"


----------------------------------------
--	HELPER CLASS
----------------------------------------
local TileMapMultiple = require "Library/tilemap"
local Gear = require "Game/Gear"
local Box = require "Game/Box"



---------------------------------

local Engine = Core.class(Sprite)

function Engine:init()
	
	self.play=false
	--------------------------------------------------------------
	-- world setup
	-- level info tile map
	-- In Project Properties\Graphisc: No Scale - Top Left
	--------------------------------------------------------------
	
	self.tilemap = TileMapMultiple.new( 
						table.concat({"Canvas/Worlds/Level00",sets.idWorld,"_00",sets.level,".lua"}),
						"Canvas/Worlds/"
						)
						
	self.xW, self.yH = self.tilemap:getWH()
	self.dx, self.dy = -Wdx, -Hdy
	self.camera = Camera.new({x=self.xW+self.dx,y=self.yH+self.dy})
	self:addChild(self.camera)
	
	self.mapProp = {}
	for k,v in pairs(self.tilemap:getInfo().properties) do self.mapProp[k] = v;print("properties map:",k,v) end
	
	
	------------------------
	--	physics
	------------------------
    self.camera.world = b2.World.new(0, 100, true) --g=150
	--self:physicDebug()
	
	self:deployInfoMap()
	self.camera:addChild(self.tilemap)

	
	------------------------
	--run world
	------------------------
	self.isFocus = true
	--self:start()
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end


---------------------------------------------
-- get information about map
---------------------------------------------
function Engine:deployInfoMap()
	
	--	some constant
	local pack = TexturePack.new("Canvas/Worlds/platformIndustrial_sheet.txt", "Canvas/Worlds/platformIndustrial_sheet.png", true)
	local colorName={"blue","yellow","green","orange"}
	local colorHex={["blue"]="0xA5D6F4",["yellow"]="0xFFCB00",["green"]="0x2DC771",["orange"]="0xF36E18"}
	
	--create empty box2d body for joint
	--since mouse cursor is not a body
	--we need dummy body to create joint
	self.camera.ground = self.camera.world:createBody({})

	
	--storage Object Names for use it after
	self.objNames = self.tilemap:getObjectNames()
	local r
	--[[
		======>	1	Terrain
		======>	2	Gear
		======>	3	Sensor
		======>	4	Doors
		======>	5	Box
		======>	6	Liquid
		======>	7	Silo
		======>	8	Buttons
	]]
	local objects={"Gear","Terrain","Cylinder","Sensor","Doors","Box","Silo","Buttons"}
	
	for i=1, #self.objNames do
		print("======>",i,self.objNames[i])
		-----------------------------------------------------------
		--	TERRAIN
		-----------------------------------------------------------
		if self.objNames[i]=="Terrain"	then
			local t = {};	self.Terrains={}
			r = self.tilemap:getObject(self.objNames[i])
			for k,v in pairs(r) do
				v.x, v.y = v.x + self.dx, v.y+self.dy
				v.type = "static"	-- always phyics
				self.Terrains[#self.Terrains+1]=v
				
				if v.shape=="polyline" then
					v.kind = "terrain"
					t = {}
					for _,val in pairs(v.polyline) do table.insert(t, val.x+v.x);  table.insert(t, val.y+v.y) end
					self.Terrains[#self.Terrains].polyline=t
					self:createPhysicTerrains(self.Terrains[#self.Terrains],t)
				elseif v.shape=="rectangle" then
					v.kind = "base"
					self.Terrains[#self.Terrains] = Sprite.new()
					self.Terrains[#self.Terrains].conf=v
					self:setupPhysicsBox(self.Terrains[#self.Terrains], v)
					
				end
				
				self.Terrains[#self.Terrains].body.kind="terrain"
				
			end
			
		-----------------------------------------------------------
		--	GEAR
		-----------------------------------------------------------
		elseif self.objNames[i]=="Gear" then
			self.Gears={}
			
			r = self.tilemap:getObject(self.objNames[i])
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				v.sw = 1 --velocity angular
				self.Gears[k] = Gear.new(v)
				self.camera:addChild(self.Gears[k])
				
			end
		
		-----------------------------------------------------------
		--	SENSOR
		-----------------------------------------------------------
		elseif self.objNames[i]=="Sensor"	then
			local t = {};	self.Sensors={}
			r = self.tilemap:getObject(self.objNames[i])
		
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				self.Sensors[#self.Sensors+1]=v
				v.door=v.type
				v.type = "dynamic"	-- always phyics
				v.kind = "sensor"
				v.density = 100
				v.friction =  2
				v.restitution = 0
				v.isSensor = false
				t = {}
				
				if v.shape=="rectangle" then
					self.Sensors[#self.Sensors] = Sprite.new()
					self.Sensors[#self.Sensors].conf=v
					self:setupPhysicsBox(self.Sensors[#self.Sensors], v)
					
					self.Sensors[#self.Sensors].body.isTouchingSensor = false
					self.Sensors[#self.Sensors].body.door=v.door
					self.Sensors[#self.Sensors].body.kind="sensor"
					self.Sensors[#self.Sensors].body.id=#self.Sensors
					--dynamic sensor
					self:changeBodyState(self.Sensors[#self.Sensors].body, {type=v.type})
					self.Sensors[#self.Sensors].body:setActive(false)
				end
				
				
			end
			
		
		-----------------------------------------------------------
		--	DOORS
		-----------------------------------------------------------
		elseif self.objNames[i]=="Doors" then	
			self.Doors={}
			r = self.tilemap:getObject(self.objNames[i])
			
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				v.door=v.name
				v.type = "static"
				v.kind = "door"
				self.Doors[k] = Sprite.new()
				self.Doors[k].conf = v
				self:setupPhysicsBox(self.Doors[k], v)
				self.Doors[k].body.door=v.door
				self.Doors[k].body.kind="door"
				self.camera:addChild(self.Doors[k])
			end
		
		-----------------------------------------------------------
		--	BOX
		-----------------------------------------------------------	
		elseif self.objNames[i]=="Box" then
			
			self.Boxs={}
			r = self.tilemap:getObject(self.objNames[i])
			
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				v.type = "dynamic"
				v.kind = "box"
				self.Boxs[k] = Box.new(v)
				self:setupPhysicsBox(self.Boxs[k], v)
				self.camera:addChild(self.Boxs[k])
				self.Boxs[k].body.kind="box"
				--joint with dummy body
				self.Boxs[k].body.mouseJoint = nil
				
				self.Boxs[k]:addEventListener("jointDown", 
					function(event)
						local xc, yc = self.camera:getPosition()
						self.camera:pause()
						self.Boxs[k].body.jointDef = b2.createMouseJointDef(self.camera.ground, self.Boxs[k].body, self.Boxs[k].x0-xc, self.Boxs[k].y0-yc, 100000)
						self.Boxs[k].body.mouseJoint = self.camera.world:createJoint(self.Boxs[k].body.jointDef)
						
					end)
				
				self.Boxs[k]:addEventListener("jointMove", 
					function(e)
						if self.Boxs[k].body.mouseJoint ~= nil then
							local xc, yc = self.camera:getPosition()
							local x,y = self.Boxs[k].body:getPosition()
							self.Boxs[k].body:setPosition(x+self.Boxs[k].dx ,y+self.Boxs[k].dy)
							self.Boxs[k].body:setAngularVelocity(0)
							self.Boxs[k].body.mouseJoint:setTarget(self.Boxs[k].x0-xc, self.Boxs[k].y0-yc)
							
						end
					end)
					
				self.Boxs[k]:addEventListener("jointUp", 
					function(e)
						if self.Boxs[k].body.mouseJoint ~= nil then
							self.camera:start()
							self.camera.world:destroyJoint(self.Boxs[k].body.mouseJoint)
							self.Boxs[k].body.mouseJoint = nil
							
						end
					end)
				
			end
		
		-----------------------------------------------------------
		--	LIQUID
		-----------------------------------------------------------
		elseif self.objNames[i]=="Liquid"	then
			self.Liquids={}
			r = self.tilemap:getObject(self.objNames[i])
			
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				self.Liquids[k] = Sprite.new()
				v.kind="liquid"
				self.Liquids[k].conf = v

				for _,val in pairs(colorName) do
				  if string.find(self.Liquids[k].conf.name,val) then
					self.Liquids[k].conf.color = colorHex[val]; break
				  end
				end
				self:createParticles(self.Liquids[k])

			end
		
		-----------------------------------------------------------
		--	SILO
		-----------------------------------------------------------
		elseif self.objNames[i]=="Silo"	then
			local t={};	self.Water = {}
			r = self.tilemap:getObject(self.objNames[i])
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				--v.type = "dynamic"	--v.kind in this case defiened name water or sensor so change after
				v.kind = "sensor"
				v.density = 100
				v.friction =  2
				v.restitution = 0
				v.isSensor = false
				self.Sensors[#self.Sensors+1]=v
				t = {}
				if v.type == "sensor" then	-- always phyics
					v.kind = "sensor"; v.type = "dynamic"
					if v.shape=="rectangle" then
						v.door=v.name
						v.kind = "sensor"
						self.Sensors[#self.Sensors] = Sprite.new()
						self.Sensors[#self.Sensors].conf=v
						self:setupPhysicsBox(self.Sensors[#self.Sensors], v)
						
						self.Sensors[#self.Sensors].body.isTouchingSensor = false
						self.Sensors[#self.Sensors].body.door=v.door
						self.Sensors[#self.Sensors].body.kind="sensor"
						self.Sensors[#self.Sensors].body.id=#self.Sensors
						
						--dynamic sensor
						self:changeBodyState(self.Sensors[#self.Sensors].body, {type=v.type})
						self.Sensors[#self.Sensors].body:setActive(false)

					end
					
				elseif v.type == "water" then
					self.Water[#self.Water+1]=Sprite.new()
					local n=#self.Water
					v.kind="water"; v.type = "dynamic"
					self.Water[n].conf = v
					self.Water[n].conf.color = colorHex["blue"]
					self.Water[n].conf.flag=128
					self:createParticles(self.Water[n])
					
				end
				
				
			end	
			
		-----------------------------------------------------------
		--	BUTTONS
		-----------------------------------------------------------
		elseif self.objNames[i]=="Buttons"	then
			self.Buttons={}
			r = self.tilemap:getObject(self.objNames[i])
			for k,v in pairs(r) do
				v.x, v.y = v.x+self.dx, v.y+self.dy
				v.upState =  Bitmap.new(pack:getTextureRegion("platformIndustrial_046.png"),true)
				v.downState =  Bitmap.new(pack:getTextureRegion("platformIndustrial_046.png"),true)
				v.posbB = {x=v.x+v.width/2, y=v.y+v.height/2}
				v.pos = {x=0, y=v.height/4}
				self.Buttons[k] = Button.new(v)
				self.camera:addChild(self.Buttons[k])
				
				--switch for open doors
				self.Buttons[k]:addEventListener("click", 
					function()
						self.Buttons[k]:removeFromParent()
						self.camera:addChild(self.Buttons[k])
						self:dispatchEvent(Event.new("putPaticlesOnScene"))
						print(v.name)
						for j=1, #self.Boxs do self:changeBodyState(self.Boxs[j].body); self.Boxs[j]:stop()  end
						for j=1, #self.Doors do
							
							self.play=true
							----------------------------------
							-- it open color silo
							----------------------------------
							if string.find(self.Doors[j].conf.name, v.name) then
								self.Doors[j].body:setActive(false)
							end
							
							self.camera:setPosition(0, 0)	--it does grow the size of particles if you don't restart the position camera
							self.camera:pause() 			--not stop because you get an error
															--./Library/Camera.lua:316: attempt to perform arithmetic on field 'time' (a nil value)
							
						end
						
						----------------------------------
						-- activate all sensors
						for j=1, #self.Sensors do if self.Sensors[j].body then self.Sensors[j].body:setActive(true) end end
						self.Buttons[k]:pauseTouch()	--prevent restart counter
					end)
				
			end
			
		end
		
	end
	
	-----------------------------------------------------------
	--	add collision event listener
	-----------------------------------------------------------
	self.camera.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self.camera.world:addEventListener(Event.END_CONTACT, self.onEndContact, self)

	--particle individual
	--self.camera.world:addEventListener(Event.BEGIN_CONTACT_PARTICLE, self.onBeginContactParticle, self)
	--self.camera.world:addEventListener(Event.BEGIN_CONTACT_PARTICLE, self.onEndContactParticle, self)

	--slowly particle group collision between their particles
	--self.camera.world:addEventListener(Event.BEGIN_CONTACT_PARTICLE2, self.onBeginContactParticle2, self)
	--self.camera.world:addEventListener(Event.BEGIN_CONTACT_PARTICLE2, self.onEndContactParticle2, self)
	
end


function Engine:setupPhysicsBox(obj, conf)
	
	local conf = conf or {}
	conf.density = conf.density or 1
	conf.friction = conf.friction or 10000
	conf.restitution = conf.restitution or 0
	conf.isSensor = conf.isSensor or false
	
	if not obj.body then
		local body
		
		--create box2d physical Land
		if conf.type == "static" then
			body = self.camera.world:createBody{type = b2.STATIC_BODY}
		elseif conf.type == "dynamic" then
			body = self.camera.world:createBody{type = b2.DYNAMIC_BODY}
		else
			body = self.camera.world:createBody{type = b2.KINEMATIC_BODY}
		end
		
		local poly = b2.PolygonShape.new()
		poly:setAsBox(obj.conf.width,obj.conf.height)
		body:setPosition(conf.x+obj.conf.width/2,conf.y+obj.conf.height/2)
		local fixture = body:createFixture{shape = poly, density = conf.density, friction = conf.friction, isSensor=conf.isSensor, restitution = conf.restitution} --restitution rebote
		obj.body = body
		obj.body.fixture = fixture
		obj.body.shape = "rectangle"
		obj.body.type = conf.type	-- type(conf.type) is string
		obj.body.name = conf.name
		obj.body.id = conf.id or 0
	else
		Timer.delayedCall(0.5, function()
			obj.body:destroyFixture(obj.body.fixture)
			
			local poly = b2.PolygonShape.new()
			poly:setAsBox(unpack(conf.poly))
			local fixture = obj.body:createFixture{shape = poly, density = conf.density, friction = conf.friction, isSensor=conf.isSensor, restitution = conf.restitution}
			obj.body.fixture = fixture
				
		end)
	
	end

end

function Engine:changeBodyState(body, conf)
	local conf = conf or {}
	local setType = b2.STATIC_BODY
	if conf.type == "dynamic" then
		setType = b2.DYNAMIC_BODY
	elseif conf.type == "kinematic" then
		setType = b2.KINEMATIC_BODY
	end	
	
	-- update body type
	body:setType(setType)
	body.type = conf.type
end

function Engine:createParticles(obj)
	obj.shape = obj.shape or "polygon"
	
	if obj.shape == "polygon" then
		obj.shape = b2.PolygonShape.new()
		obj.shape:setAsBox(obj.conf.width/2, obj.conf.height/2)
	elseif obj.shape == "chain" then
		obj.shape = b2.ChainShape.new()
		obj.shape:createLoop(unpack(obj.conf.loop))
	elseif obj.shape == "circle" then
		obj.shape = b2.CircleShape.new(0, 0, obj.conf.radius or obj.conf.width)
	end
	
	obj.ps=self.camera.world:createParticleSystem({radius=2})
	obj.ps:setTexture(Texture.new("Canvas/Bubble.png"))
	
	local FLAG = obj.conf.flag or 8
	---------------------------------
	--see more information on 
	---------------------------------
	--multiplies flags:
	--https://google.github.io/liquidfun/API-Ref/html/structb2_particle_def.html
	--types particles flags
	--https://google.github.io/liquidfun/API-Ref/html/b2_particle_8h.html#a73d3b011893cb87452253b1b67a5cf50

	--more details:
	--https://github.com/gideros/gideros/blob/595369c4c7af76982ba08cad9fe8e90b6fc82045/external/liquidfun-1.0.0/liquidfun/Box2D/Box2D/Particle/b2Particle.h
	--2^n

	--b2.ParticleSystem.FLAG_PARTICLE_CONTACT_FILTER = 2^17 
	--b2.ParticleSystem.FLAG_FIXTURE_CONTACT_FILTER = 2^16
	--b2.ParticleSystem.FLAG_PARTICLE_CONTACT_LISTENER = 2^15		--available
	--b2.ParticleSystem.FLAG_FIXTURE_CONTACT_LISTENER = 2^14
	--b2.ParticleSystem.FLAG_REPULSIVE = 2^13 = 8192				--With high repulsive force.
	--b2.ParticleSystem.FLAG_REACTIVE = 2^12 = 4096					--Makes pairs or triads with other particles.
	--b2.ParticleSystem.FLAG_STATIC_PRESSURE = 2^11	= 2048			--Less compressibility.
	--b2.ParticleSystem.FLAG_BARRIER = 2^10	= 1024					--Prevents other particles from leaking.
	--b2.ParticleSystem.FLAG_DESTRUCTION_LISTENER = 2^9 = 512		--Call b2DestructionListener on destruction.
	--b2.ParticleSystem.FLAG_COLOR_MIXING = 256						--Mix color between contacting particles.

	--b2.ParticleSystem.FLAG_TENSILE = 128	--like a ocean, scum
	--b2.ParticleSystem.FLAG_POWDER = 64	--like a boiled	// Without isotropic pressure.
	--b2.ParticleSystem.FLAG_VISCOUS = 32	--like a rice
	--b2.ParticleSystem.FLAG_ELASTIC = 16	--stable jelly (if on the world doesn't exist strength)
	--b2.ParticleSystem.FLAG_SPRING = 8		--really jelly
	--b2.ParticleSystem.FLAG_WALL = 4		--like a sponge or water drops on surface // Zero velocity
											--(it only works with two Particles group like
											--minium but another particles group must have different Flag)
	--b2.ParticleSystem.FLAG_ZOMBIE = 2		--Removed after next simulation step.
	--b2.ParticleSystem.FLAG_WATER = 0		--water


	--from line 346 to line 422
	--https://github.com/gideros/gideros/blob/11b7121792ee44fd71d16bd28b5830411dad9a7e/luabinding/box2dbinder2.cpp
	--Event.BEGIN_CONTACT_PARTICLE = "beginContactParticle"
	--Event.BEGIN_CONTACT_PARTICLE2 = "beginContactParticle2"
	--Event.END_CONTACT_PARTICLE = "endContactParticle"
	--Event.END_CONTACT_PARTICLE2 = "endContactParticle2"
	
	-----------------------------------
	--effect magma: flags= 0|128|32
	-----------------------------------
	
	obj.ps:createParticleGroup({
			shape=obj.shape, 
			position={x=obj.conf.x+obj.conf.width/2,y=obj.conf.y+obj.conf.height/2},
			color = obj.conf.color,
			--alpha=1,
			--lifetime=20,
			flags=FLAG--|b2.ParticleSystem.FLAG_PARTICLE_CONTACT_LISTENER
		})
		
	self:addEventListener("putPaticlesOnScene", function() self.camera:addChildAt(obj.ps,1) end)
	
end

-- for creating objects using shape
-- as example - bounding walls
-- chains aren't add to self as child
function Engine:createPhysicTerrains(shape,loop,conf)

    --create box2d physical object
	--print(unpack(loop))
	local conf = conf or {}
	conf.density = conf.density or 100
	conf.friction = conf.friction or 2
	conf.restitution = conf.restitution or 0.1
	conf.isSensor = conf.isSensor or false
	
    local body =  self.camera.world:createBody{type = b2.STATIC_BODY}
	local chain = b2.ChainShape.new()
    chain:createLoop(unpack(loop))
    local fixture = body:createFixture{shape = chain, density = conf.density, 
    friction = conf.friction, restitution = conf.restitution, isSensor=conf.isSensor}
    shape.body = body
    shape.body.name = shape.name
	shape.body.type = shape.type
	
end


function Engine:physicDebug()
	 --set up debug drawing
	local debugDraw = b2.DebugDraw.new()
    self.camera.world:setDebugDraw(debugDraw)
    self.camera:addChild(debugDraw)
end




--[[
function Engine:onBeginContactParticle(e)
    --getting contact bodies

    local fixture = e.fixture
    local index = e.index
    local system = e.system
	--print("Hello Particle",fixture,index,system)
end

function Engine:onEndContactParticle(e) end

function Engine:onBeginContactParticle2(e)
    --getting contact bodies

    local indexA = e.indexA
    local indexB = e.indexB
    local system = e.system
	print("Hello Particle 2",indexA,indexB,system)
end

function Engine:onEndContactParticle2(e) end
]]




--define begin collision event handler function
function Engine:onBeginContact(e)
    --getting contact bodies
    local fixtureA = e.fixtureA
    local fixtureB = e.fixtureB
    local bodyA = fixtureA:getBody()		--A: is first child in class
    local bodyB = fixtureB:getBody()		--A: is second child in class not necessary check wall and hero collision
	
	--print("Hello",bodyA.kind,bodyA.name,bodyA.type, bodyB.kind)
    --it should be first, because it was created before dragging ball object
	if string.find(bodyB.kind,"sensor") and self.play then
		
		print("Hello B")
        --creating timer to delay changing world
        --because by default you can't change world settings 
        --in event callback function
        --delay 1 milisecond for 1 time
        local timer1 = Timer.new(1, 1)
        --setting timer callback
        timer1:addEventListener(Event.TIMER_COMPLETE, function()
			print("Collision",bodyB.kind, bodyB.id, bodyB.kind)	-- all sensors begin collision with their floors
			self.count=0
			self.countV= 0
			self.Sensors[bodyB.id].body.isTouchingSensor = true	-- on begin all touching sensors; all they are false so you win
			self:addEventListener(Event.ENTER_FRAME, self.checkSensors, self)
        end)
        --start timer
        timer1:start()
		
	end
end


--NEVER STOP COLLISION WITH PARTICLE
--define collision end event handler
function Engine:onEndContact(e)
    --getting contact bodies
    local fixtureA = e.fixtureA
    local fixtureB = e.fixtureB
    local bodyA = fixtureA:getBody()
    local bodyB = fixtureB:getBody()
	if string.find(bodyB.kind,"sensor") and self.play then
		self.Sensors[bodyB.id].body.isTouchingSensor = false
		print("END CONTACT B",bodyB.id, bodyB:isActive())	--when you setActivate(false) end contact happend
   end
end



function Engine:checkSensors()
	--print("HERE checkSensors")
	for i=1,#self.Sensors do
		if self.Sensors[i].body then
			--print(i,"=======")
			if self.Sensors[i].body.isTouchingSensor then
				self.count = self.count + 1
				if self.count>60 then
					self.countV = self.countV +1
					--print(self.countV,i,"--------------------")	--counter per equal i=1 and 3
					if self.countV>8 then
						--print(self.countV,i,self.Sensors[i].body:isAwake() )
						if self.Sensors[i].body:isAwake() then	--but if sensor awake so liquid is over sensor
							
							print(i,self.Sensors[i].body.door,self.Sensors[i].body.id,self.Sensors[i].body.name,self.Sensors[i].body.type)
							
							if self.Sensors[i].body.door then
								
								for k=1, #self.Doors do
									----------------------------------
									-- it open the water silo or next door
									----------------------------------
									if self.Doors[k].body then
										if self.Doors[k].body.door==self.Sensors[i].body.door then
											self.Doors[k].body:setActive(false)
											self.Sensors[i].body:setActive(false)
											self.Sensors[i].body.isTouchingSensor = false	-- condition to win
										end
									end
								
								end
							end
								
						else 
								print("game over")
								self:removeEventListener(Event.ENTER_FRAME, self.checkSensors, self)
								self.alt = AlertDialog.new("Foul Job", "Game Over", "Again")--, "Back")
								self.alt:addEventListener(Event.COMPLETE,
									function(event)
										if event.buttonText == "Back" then
											sceneManager:changeScene("Engine", 1, transitions[17], easing.linear)
										elseif event.buttonText == "Again" then
											sceneManager:changeScene("Engine", 1, transitions[17], easing.linear)
										end
									end)
								self.alt:show()
							
						end
						self.countV=5
					end
				
				self.count=0
				end
			end
			
			--	chech if you win
			if self.play then
				local param = false
				for i=1,#self.Sensors do
					if self.Sensors[i].body then
						param = self.Sensors[i].body.isTouchingSensor
						if param then break end
					end
				end
				if not param then
					print("you win")
					self:removeEventListener(Event.ENTER_FRAME, self.checkSensors, self)
					local nleves=2
					sets.level = sets.level + 1
					sets.level=(sets.level-1)%2+1
					local bto = (sets.level==1) and "Again" or "Next"
					local alert = (sets.level==1) and " Kongratz You Win!\n\n Coming Soon More Levels and Features\n Thanks for Playing\n\n [-] Liasoft\n\n\n Powered by\n Gideros " or " Kongratz You Win!\n\n Go to the next Level"
					self.alt = AlertDialog.new("Foul Job",alert,bto)--, "Back")
					self.alt:addEventListener(Event.COMPLETE,
						function(event)
							if event.buttonText == "Back" then
								sceneManager:changeScene("Engine", 1, transitions[17], easing.linear)
							elseif event.buttonText == bto then
								sceneManager:changeScene("Engine", 1, transitions[17], easing.linear)
							end
						end)
					
					self.alt:show()
				end
			end
	  end
	end
end




function Engine:start()
	
	self:addEventListener(Event.ENTER_FRAME, self.onframe, self)

end
function Engine:stop()
	
	
	self:removeEventListener(Event.ENTER_FRAME, self.onframe, self)
end


--running the world
function Engine:onEnterFrame() 

    -- edit the step values if required. These are good defaults!
    self.camera.world:step(1/120, 8, 3)
    --iterate through all child sprites
    for i = 1, self.camera:getNumChildren() do	--it's not self is self.camera
        --get specific sprite
        local sprite = self.camera:getChildAt(i)	--it's not self is self.camera
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
	
end

return Engine