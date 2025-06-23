-- License - http://creativecommons.org/publicdomain/zero/1.0/

require "json"

stage:setBackgroundColor(0,0,0)
local sprite = Shape.new()
sprite:setMatrix(Matrix.new(2, 0,0,-2,application:getLogicalWidth()/2,application:getLogicalHeight()/2))
stage:addChild(sprite)
scene = createBox2dWorld("bridge.json", sprite)
b2.setScale(8)

sprite:addEventListener(Event.ENTER_FRAME, function() scene.world:step(1/60, 8, 3) end)

