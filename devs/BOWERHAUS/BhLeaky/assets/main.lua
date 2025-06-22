require "leaky"

MyBitmap=Core.class(Bitmap)

for i=1, 5 do
	local ball1=MyBitmap.new(Texture.new("ball1.png"))
	stage:addChild(ball1)
end
EventDispatcher.printAllInstances("After creating five balls")

-- Now remove 2 balls
stage:removeChildAt(1)
stage:removeChildAt(1)
collectgarbage("collect")
collectgarbage("collect")
EventDispatcher.printAllInstances("After removing two balls")

-- Now remove 3 more balls
stage:removeChildAt(1)
stage:removeChildAt(1)
stage:removeChildAt(1)
collectgarbage("collect")
collectgarbage("collect")
EventDispatcher.printAllInstances("After removing all balls")
