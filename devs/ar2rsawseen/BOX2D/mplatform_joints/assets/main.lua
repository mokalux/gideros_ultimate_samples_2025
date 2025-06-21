require "liquidfun"
require "scenemanager"
scenemanager = SceneManager.new(
	{
		["prismaticJoint"] = prismaticJoint,
	}
)
stage:addChild(scenemanager)
scenemanager:changeScene("prismaticJoint")
