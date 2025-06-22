----require "BhEventShield"
----!NEEDS:BhEventShield.lua

local shield = BhEventShield.new(true, 0xff0000)
stage:addChild(shield)

GesturePadDemo.new()
