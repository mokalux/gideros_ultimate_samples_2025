
--[[

SAT Rectangle Collision Example for Gideros
by Cliff Earl
Antix Software
March 2016

Example  project that  creates and  displays 2  rotating boxes  that can  be 
dragged  about the  screen by  their center  points, and  detects collisions 
between them. 

Collision  detection  is a  2 part  process. First  the bounding  boxes  are 
checked to see  if they overlap  (it is pointless  to waste CPU  time on SAT 
calculations  unless that is the case). Once the  boxes overlap they will be 
tinted yellow and  SAT collision detection will then  be applied to test for 
intersection  (one rectangle partially  inside the other  rectengle). If the 
rectangles do intersect then they will be tinted red.

There is one class (Draggable) and 1 library (GSAT) included in the example. 

Draggable
An  extension  of  Bitmap  that can  be dragged  about by  its  center.  See 
Draggable.lua for more information.

GSAT
A  simple library for  performing collision  detection (and projection-based 
collision response) of rectangular shapes in  2 dimensions. See GSAT.lua for 
more information.

--]]

--require("mobdebug").start() -- ONLY REQUIRED FOR ZEROBRANE

local GSAT = require("gsat") -- THE COLLISION LIBRARY

local function newBox(actor) -- CREATE A NEW COLLISION BOX
  local x, y, w, h = actor:getBounds(stage)
  local box = GSAT.Box(x + (w * 0.5), y + (h * 0.5), w, h)
  box:setRotation(actor:getRotation())
  return box
end

local function actorInActor(actor1, actor2) -- TEST 2 BOUNDING BOX FOR OVERLAP
	local x, y, w, h = actor1:getBounds(stage)
	local x2, y2, w2, h2 = actor2:getBounds(stage)
	return not ((y+h < y2) or (y > y2+h2) or (x > x2+w2) or (x+w < x2))
end

local info = TextField.new(nil, "Drag the boxes by their centers to move them")
info:setPosition(20, 20)

local player = Draggable.new(Texture.new("images/box.png", true), {x = 64*1, y = 64*2}) -- CREATE PLAYER
player.box = newBox(player)
player.onDragged = function() player.box:setPosition(player:getPosition()) end

local enemy = Draggable.new(Texture.new("images/box.png", true), {x = 64*3, y = 64*2}) -- CREATE ENEMY
enemy.box = newBox(enemy)
enemy.onDragged = function() enemy.box:setPosition(enemy:getPosition()) end

local function onEnterFrame(event) -- MAIN LOOP
  
  local angle = enemy:getRotation() - 2.6 -- 0.284, ROTATE ENEMY CCW
  enemy:setRotation(angle)
  enemy.box:setRotation(angle)

  angle = player:getRotation() + 2.5 -- 0.284, ROTATE PLAYER CW
  player:setRotation(angle)
  player.box:setRotation(angle)
  
  if actorInActor(player.box, enemy.box) then
    stage:setColorTransform(1, 1, 0, 1) -- BOXES OVERLAP, TINT YELLOW
    
    local response = GSAT.Response() -- CHECK FOR COLLISION BETWEEN BOXES
    local collided = GSAT.checkCollision(player.box, enemy.box, response)
    if collided then
      stage:setColorTransform(1, 0, 0, 1) -- BOXES COLLIDED,  TINT BOXES RED

      --
      -- PERFORM COLLISION RESOLUTIONS HERE
      --
      
    end
  else
    stage:setColorTransform(1, 1, 1, 1) -- NO COLLISION, TINT BOXES BACK TO NORMAL
  end

end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)

stage:addChild(enemy)
stage:addChild(player)

stage:addChild(info)
