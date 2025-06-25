# GidSwipe
Simple tap and swipe detection library (supports 4 and 8 directions)

Simply create an instance of GidSwipe in your project and make the stage listen to the Event.TAP and/or Event.SWIPE events.

```lua
local swiper = GidSwipe.new()
-- listen to taps
stage:addEventListener(Event.TAP, function(ev) 
  print("tapped the screen at "..ev.x,ev.y)
end)
-- listen to swipes
stage:addEventListener(Event.SWIPE, function(ev)
  print("swiped "..ev.direction.." from "..ev.startX,ev.startY)
end
```

Thats it! There are currently 3 options to be set with GidSwipe.setOption() - check out the description in the GidSwipe.lua file.
