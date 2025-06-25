--[[
 * Ported to Gideros/Lua and refactored by Josh Handley.
 * Based on Yannick Loriots (http://yannickloriot.com) port to 
 * Box2D/Cocos2D of Box2DAS3 Ragdoll example, originally written 
 * by Matthew Bush (skatehead [at] gmail.com).
 *
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
]]--
 
Ragdoll = Core.class(Sprite)

local function createRectangularBodyPart(world, x, y, width, height)
    local bodyPart = world:createBody{type = b2.DYNAMIC_BODY, position = {x = x, y = y}}
	local boxShape = b2.PolygonShape.new()
	boxShape:setAsBox(width, height)
	bodyPart:createFixture{shape = boxShape, density = 1, friction = 0.4, restitution = 0.1}
	return bodyPart
end

local degreesToRadians = math.pi/180

local function makeJoint(world, bodyA, bodyB, x, y, lowerAngleDegrees, upperAngleDegrees)
	local jointDef = b2.createRevoluteJointDef(bodyA, bodyB, x, y)
	jointDef.enableLimit = true
	jointDef.lowerAngle = lowerAngleDegrees * degreesToRadians
	jointDef.upperAngle = upperAngleDegrees * degreesToRadians
	world:createJoint(jointDef)
end

function Ragdoll:init(world, options)

	local position = options.position or {x = 0, y = 0}

	-- Body parts
	self.head = world:createBody{type = b2.DYNAMIC_BODY, position = position}
	local headShape = b2.CircleShape.new(0, 0, 12.5)
	self.head:createFixture{shape = headShape, density = 1, friction = 0.4, restitution = 0.3}

    self.shoulders = createRectangularBodyPart(world, position.x, position.y + 25, 15, 10)
    self.midsection = createRectangularBodyPart(world, position.x, position.y + 43, 15, 10)
    self.hips = createRectangularBodyPart(world, position.x, position.y + 58, 15, 10)

    self.leftUpperArm = createRectangularBodyPart(world, position.x - 30, position.y + 20, 18, 6.5)
    self.rightUpperArm = createRectangularBodyPart(world, position.x + 30, position.y + 20, 18, 6.5)
    self.leftLowerArm = createRectangularBodyPart(world, position.x - 57, position.y + 20, 17, 6.0)
    self.rightLowerArm = createRectangularBodyPart(world, position.x + 57, position.y + 20, 17, 6.0)

    self.leftUpperLeg = createRectangularBodyPart(world, position.x - 8, position.y + 85, 7.5, 22)
    self.upperLegRight = createRectangularBodyPart(world, position.x + 8, position.y + 85, 7.5, 22)
    
    self.leftLowerLeg = createRectangularBodyPart(world, position.x - 8, position.y + 120, 6, 20)
    self.rightLowerLeg = createRectangularBodyPart(world, position.x + 8, position.y + 120, 6, 20)

	-- Joints
	makeJoint(world, self.shoulders, self.head, position.x, position.y + 15, -40, 40)
	makeJoint(world, self.shoulders, self.leftUpperArm, position.x - 18, position.y + 20, -85, 130)
	makeJoint(world, self.shoulders, self.rightUpperArm, position.x + 18, position.y + 20, -130, 85)
	makeJoint(world, self.leftUpperArm, self.leftLowerArm, position.x - 45, position.y + 20, -130, 10)
	makeJoint(world, self.rightUpperArm, self.rightLowerArm, position.x + 45, position.y + 20, -10, 130)
	makeJoint(world, self.shoulders, self.midsection, position.x, position.y + 35, -15, 15)
	makeJoint(world, self.midsection, self.hips, position.x, position.y + 50, -15, 15)
	makeJoint(world, self.hips, self.leftUpperLeg, position.x - 8, position.y + 72, -25, 45)
	makeJoint(world, self.hips, self.upperLegRight, position.x + 8, position.y + 72, -45, 25)
	makeJoint(world, self.leftUpperLeg, self.leftLowerLeg, position.x - 8, position.y + 105, -25, 115)
	makeJoint(world, self.upperLegRight, self.rightLowerLeg, position.x + 8, position.y + 105, -115, 25)
	
end

