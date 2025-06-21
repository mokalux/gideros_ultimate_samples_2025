--include box2d library
require "box2d"

local joints = {
	revoluteJoint,
	prismaticJoint,
	distanceJoint,
	pulleyJoint,
	mouseJoint,
	gearJoint,
	wheelJoint,
	weldJoint,
	frictionJoint
}

--define scenes
sceneManager = SceneManager.new(joints)
--add manager to stage
stage:addChild(sceneManager)

--first scene
currentJoint = 1 -- 1

local function switchScene()
	sceneManager:changeScene(currentJoint, 1, SceneManager.fade)
	if currentJoint == #joints then
		nextBtn:setScale(0)
	else
		nextBtn:setScale(1)
	end
	
	if currentJoint == 1 then
		prevBtn:setScale(0)
	else
		prevBtn:setScale(1)
	end
end

--pseudo button to switch to next scene
nextBtn = TextField.new(TTFont.new("tahoma.ttf", 20), "Next")
nextBtn:setPosition(application:getContentWidth()-nextBtn:getWidth()-20, 30)
stage:addChild(nextBtn)
nextBtn:addEventListener(Event.MOUSE_DOWN, function(e)
	if nextBtn:hitTestPoint(e.x, e.y) then
		currentJoint = currentJoint + 1
		switchScene()
		e:stopPropagation()
	end
end)

--pseudo button to switch to previous scene
prevBtn = TextField.new(TTFont.new("tahoma.ttf", 20), "Prev")
prevBtn:setPosition(20, 30)
prevBtn:setScale(0)
stage:addChild(prevBtn)
prevBtn:addEventListener(Event.MOUSE_DOWN, function(e)
	if prevBtn:hitTestPoint(e.x, e.y) then
		currentJoint = currentJoint - 1
		switchScene()
		e:stopPropagation()
	end
end)

--start first scene
sceneManager:changeScene(currentJoint, 1)