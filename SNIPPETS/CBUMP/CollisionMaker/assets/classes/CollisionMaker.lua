
--[[

name:   Antix Collision Maker
vers:   1.0.0
desc:   Creates collision rectangles for use with bump.lua
auth:   by Cliff Earl
date:   March 2016
legal:  (c) 2016 Antix Software

--]]

CollisionMaker = Core.class()

function CollisionMaker:init(world) -- STARTUP
  self.tempWalls = {}
  self.rectangles = {}
  self.world = world -- COLLISION WORLD CREATED BY BUMP.LUA
  
  self.vCount = 0
  self.hCount = 0
  
  self.debug = false
  self.shapes = Sprite.new()
end

function CollisionMaker:dispose(world) -- SHUTDOWN / ATTEMPT CLEANUP
  self:reset()
  
  self.vCount = nil
  self.hCount = nil
  self.shapes = nil
  self.debug = nil
  self.world = nil
  self.rectangles = nil
  self.tempwalls = nil
end

function CollisionMaker:enableDebug(state) -- TOGGLE DEBUGGING
	self.shapes:removeFromParent()
	if state then
		stage:addChild(self.shapes)
	end
	self.debug = state
end

function CollisionMaker:reset() -- RESET VARS
  local function empty(table) for k in next,table do local t = type(k) if k == "table" then empty(k) end table[k] = nil end end
  
  local rectangles = self.rectangles
  local walls = self.tempWalls
  local shapes = self.shapes
  local world = self.world
  
  if #rectangles > 0 then -- REMOVE RECTANGLES FROM WORLD AND RESET TABLES
    for i = 1, #rectangles do -- REMOVE COLLISOIN RECTANGLES
      world:remove(rectangles[i])
    end
    empty(rectangles)

    local shapeCount = shapes:getNumChildren() -- DESTROY DEBUG SHAPES
    if shapeCount > 0 then
      for i = shapeCount, 1, -1 do
        local shape = shapes:getChildAt(i)
        shape:clear()
        shapes:removeChild(shape)
        shape = nil
      end
    end
    
    empty(walls) -- CLEAR TEMP WALLS
    
    -- RESET MORE HERE
  end
end

function CollisionMaker:createRectangles(map, name) -- CREATE RECTANGLE COLLISION SHAPES FOR TILED MAP LAYER
  local insert = table.insert
  
  local function drawRect(x, y, w, h, color) local rect = Shape.new() rect:setFillStyle(Shape.SOLID, color or (math.random()*255) + ((math.random()*255) * 256) + ((math.random()*255) * 65536), 0.75) rect:beginPath() rect:moveTo(0, 0) rect:lineTo(w, 0) rect:lineTo(w, h) rect:lineTo(0, h) rect:closePath() rect:endPath() rect:setPosition(x, y) self.shapes:addChild(rect) end
    
  local function getLayer(map, name) -- GET NAMED LAYER FROM MAP
    for i = 1, #map.layers do
      local layer = map.layers[i]
      if layer.name == name then return layer end
    end
    return false
  end
  
  self:reset() -- CLEANUP IF ANY STUFF WAS PREVIOUSLY CREATED
  
  --
  -- GENERATE COLLISION RECTANGLES FOR ALL SOLID BLOCKS
  --
  
  local layer = getLayer(map, name) -- WALL LAYER CONTAINS THE INFO WE NEED
  
  local rectangles = self.rectangles
  local walls = self.tempWalls
  
  local data = layer.data
  
  for i = 1, layer.width * layer.height do -- GENERATE SOLIDITY TABLE
    if data[i] > 0 then
      insert(walls, true)
    else
      insert(walls, false)
    end
  end
  
  local tw, th = map.tilewidth, map.tileheight
  
  for col = 1, layer.width do -- GENERATE VERTICAL RECTANGLES
    local y, h = 0, 0
    for row = 1, layer.height do
      if walls[((row - 1) * layer.width) + col] then -- FOUND SOLID CELL
        if y == 0 then y = row end -- SET NEW RECTANGLE POSITION
        h = h + 1
      else -- FOUND EMPTY CELL
        if h > 1 then
          insert(rectangles, {isWall = true, x = (col - 1) * tw, y = (y - 1) * th, w = 1 * tw, h = h * th})
          for i = y, y + h do -- EXCLUDE FROM HORIZONTAL RECTANGLES (CLEAR CELLS)
            walls[((i - 1) * layer.width) + col] = false
          end
        end
        y, h = 0, 0 -- RESET POSITION AND HEIGHT
      end
    end
	  if h > 1 then -- SPECIAL CASE WHEN THE RECTANGLE IS THE HEIGHT OF THE LAYER
      insert(rectangles, {isWall = true, x = (col - 1) * tw, y = (y - 1) * th, w = 1 * tw, h = h * th})
      for i = y, y + h do -- EXCLUDE FROM HORIZONTAL RECTANGLES (CLEAR CELLS)
        walls[((i - 1) * layer.width) + col] = false
      end
	  end
  end
  self.vCount = #rectangles
  
  for row = 1, layer.height do -- GENERATE HORIZONTAL RECTANGLES
    local x, w = 0, 0
    for col = 1, layer.width do
      if walls[((row - 1) * layer.width) + col] then -- FOUND SOLID CELL
        if x == 0 then x = col end
        w = w + 1
      else -- FOUND EMPTY CELL
        if w > 0 then
          insert(rectangles, {isWall = true, x = (x - 1) * tw, y =(row - 1) * th, w = w * tw, h = 1 * th})
          x, w = 0, 0
        end
      end
    end
    if w > 0 then -- SPECIAL CASE WHERE THE RECTANGLE IS THE WIDTH OF THE LAYER
      insert(rectangles, {isWall = true, x = (x - 1) * tw, y =(row - 1) * th, w = w * tw, h = 1 * th})
    end
  end
  self.hCount = #rectangles - self.vCount

  for i = 1, #rectangles do -- ADD RECTANGLES TO COLLISION WORLD
    local world = self.world
    local rect = rectangles[i]
    world:add(rect, rect.x, rect.y, rect.w, rect.h) -- ADD RECTANGLE TO COLLISION WORLD
    if self.debug then drawRect(rect.x, rect.y, rect.w, rect.h) end
  end

  -- PROCESS MORE HERE

end
