-- plugins
require "scenemanager"
require "easing"
tiny = require "classes/tiny"

-- globals
local dx, dy, w, h = application:getDeviceSafeArea(true)
screenW = w + dx
screenH = h + dy
timeScale = 1
