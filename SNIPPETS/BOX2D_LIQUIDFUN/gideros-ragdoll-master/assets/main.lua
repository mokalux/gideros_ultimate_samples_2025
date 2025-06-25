
require "box2d"

application:setScaleMode("letterbox")

local world = b2.World.new(0, 2)

local debugDraw = b2.DebugDraw.new()
world:setDebugDraw(debugDraw)
stage:addChild(debugDraw)


local function createWall(world, x, y, width, height)
	local body = world:createBody{type = b2.STATIC_BODY}
	body:setPosition(x, y)
	local poly = b2.PolygonShape.new()
	poly:setAsBox(width/2, height/2)
	local fixture = body:createFixture{shape = poly, density = 1.0, 
									   friction = 0.1, restitution = 0.8}
end

local screenW = application:getContentWidth()
local screenH = application:getContentHeight()
createWall(world, 0,screenH/2,10,screenH)
createWall(world, screenW/2,0,screenW,10)
createWall(world, screenW,screenH/2,10,screenH)
createWall(world, screenW/2,screenH,screenW,10)

local dude = Ragdoll.new(world, {position={x=150, y=200}})
stage:addChild(dude)


local function onEnterFrame()
	world:step(1/60, 8, 3)	
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

local ground = world:createBody({})
     
local mouseJoint = nil

local function onMouseDown(event)
	local jointDef = b2.createMouseJointDef(ground, dude.shoulders, event.x, event.y, 1000)
    mouseJoint = world:createJoint(jointDef)
end

local function onMouseUp(event)
	if mouseJoint ~= nil then
        world:destroyJoint(mouseJoint)
        mouseJoint = nil
    end
end

local function onMouseMove(event)
	if mouseJoint ~= nil then
        mouseJoint:setTarget(event.x, event.y)
    end
end

stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
stage:addEventListener(Event.MOUSE_UP, onMouseUp)
