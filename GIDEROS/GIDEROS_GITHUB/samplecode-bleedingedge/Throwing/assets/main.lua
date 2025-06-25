--[[

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

]]

require "box2d"

b2.setScale(30)

local world = b2.World.new(0, 9.8, true)

-- this is the list of physical entities
local actors = {}

world.ground = world:createBody({})

local shape = b2.EdgeShape.new()

shape:set(0, 0, 330, 0)
world.ground:createFixture({shape = shape, density = 0})

shape:set(330, 0, 320, 480)
world.ground:createFixture({shape = shape, density = 0})

shape:set(330, 480, 0, 480)
world.ground:createFixture({shape = shape, density = 0})

shape:set(0, 480, 0, 0)
world.ground:createFixture({shape = shape, density = 0})

for i=1,8 do
	local box = MouseJointBox.new(world, math.random(50, 320-50), math.random(60, 480-50))
	stage:addChild(box)
	actors[#actors + 1] = box
end

local function onEnterFrame()
	world:step(1/60, 8, 3)
	
	for i=1, #actors do
		local sprite = actors[i]
		local body = sprite.body
		
		sprite:setPosition(body:getPosition())
		sprite:setRotation(body:getAngle() * 180 / math.pi)
	end
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

