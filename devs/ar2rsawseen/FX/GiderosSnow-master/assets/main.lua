stage:setOrientation(Stage.PORTRAIT)
stage:setBackgroundColor(0, 0, 0)
 
local start = Bitmap.new(Texture.new("images/start.png"))
local start_push = Bitmap.new(Texture.new("images/start_push.png"))
local startButton = Button.new(start, start_push)
startButton:setPosition((application:getDeviceWidth()-start:getWidth())/2, 50)
stage:addChild(startButton)
startButton:addEventListener("click", 
    function()  
        Snow.start()
    end
)

local stop = Bitmap.new(Texture.new("images/stop.png"))
local stop_push = Bitmap.new(Texture.new("images/stop_push.png"))
local stopButton = Button.new(stop, stop_push)
stopButton:setPosition((application:getDeviceWidth()-start:getWidth())/2, 160)
stage:addChild(stopButton)
stopButton:addEventListener("click", 
    function()  
        Snow.stop()
    end
)

local add = Bitmap.new(Texture.new("images/add.png"))
local add_push = Bitmap.new(Texture.new("images/add_push.png"))
local addButton = Button.new(add, add_push)
addButton:setPosition((application:getDeviceWidth()-start:getWidth())/2, 280)
stage:addChild(addButton)
addButton:addEventListener("click", 
    function()  
        Snow.addFlake()
    end
)

Snow.init({
	image = "images/snowflake.png",
	fallingTime = 20000,
	flakeInterval = 600,
	flakeSize = 20,
	sizeDelta = 5,
	easing = easing.outSine,
	fadeOut = true,
	shrink = true,
	rotate = true,
	autoStart = true,
	parent = stage
})
