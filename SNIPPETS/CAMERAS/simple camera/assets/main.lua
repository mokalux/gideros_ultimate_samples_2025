
application:setFps(60)
application:setBackgroundColor(0x001008)

MAXX = 1024 -- World width and height
MAXY = 1024

WIDTH = application:getContentWidth() -- device/player width, height
HEIGHT = application:getContentHeight()
MIDX = WIDTH * 0.5 -- half these for centering purposes
MIDY = HEIGHT * 0.5

local background = Background.new() -- Add a wee background so it looks better
stage:addChild(background)

local camera = Sprite.new() -- create camera and add to stage
stage:addChild(camera)

local boxes = {} -- create boxes at random positions in the world
local texture = Texture.new("images/box.png", true)
for i = 1, 64 do
  local box = Box.new(texture)
  camera:addChild(box)
  boxes[#boxes + 1] = box
end

local function bringToFront(box) -- This box appears in front of all other boxes
  box:removeFromParent()
  camera:addChild(box)
end

local focusedBox = 1 -- The camera will track this box
bringToFront(boxes[1])

local function onTouched(e) -- Change the cameras focus to the next box
  local focused = focusedBox + 1
  if focused > #boxes then focused = 1 end
  focusedBox = focused

  local box = boxes[focused]
  bringToFront(box)
end


local function update(ev) -- Update everything every frame
  local dt = ev.deltaTime
  
  for i = #boxes, 1, -1 do -- Updatre boxes
    local box = boxes[i]
    box:update(dt)
  end

  local p = boxes[focusedBox].position -- Fetch position of box the camera is tracking
  local x, y = p.x, p.y
  
  camera:setPosition(-x + MIDX, -y + MIDY) -- Set cameras position
  
  background:update(x, y) -- Make background scroll
end

stage:addEventListener(Event.TOUCHES_END, onTouched) -- Add listeners
stage:addEventListener(Event.ENTER_FRAME, update)
