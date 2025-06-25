require "scenemanager"
require "easing"
require "FastNoise"

-- screen size as global variables
myappleft, myapptop, myappright, myappbot = application:getLogicalBounds()
myappwidth, myappheight = myappright - myappleft, myappbot - myapptop
print(myappleft, myapptop, myappright, myappbot)
print(myappwidth, myappheight)
