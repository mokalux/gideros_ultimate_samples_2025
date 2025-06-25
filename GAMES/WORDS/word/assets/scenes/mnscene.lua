-- place holder
MnScene = Core.class(Sprite)

function MnScene:init()
	self.goBtn = newSimpleBtn(0xff2a00, 0xa5a5a5, 1, 200, 200, 540, 1080)

	local switchScene = Event.new("switchScene")
	self.goBtn:addEventListener("onRelease", function()
		switchScene.scene = 2
		stage:dispatchEvent(switchScene)
	end)

	self:addChild(self.goBtn)
end
