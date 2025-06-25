require "box2d"

stage:setOrientation(Stage.LANDSCAPE_LEFT)
world = b2.World.new(0, 9.8)

local sceneManager = SceneManager.new({
	["scene1"] = Game
})
local scenes = { "scene1",}

stage:addChild( sceneManager )
sceneManager:changeScene("scene1")

local debugDraw = b2.DebugDraw.new()
debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT)
world:setDebugDraw(debugDraw)
--stage:addChild(debugDraw)
