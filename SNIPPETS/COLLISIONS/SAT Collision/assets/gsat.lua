
--[[

  GSAT - (Gideros Seperating Axis Theorem)
  
  A simple  library for  performing collision  detection (and projection-based 
  collision response)  of rectangular  shapes in  2 dimensions. GSAT  utilizes 
  Separating  Axis Theorem  to  accomplish  these  tasks.  GSAT is  a modified 
  version  of SAT.lua (https://bitbucket.org/RudenkoPaint/sat-lua) which is in
  turn Andrey Rudenkos' port of (https://github.com/jriecken/sat-js). 

  SAT's  ability to operate on circles  and polygons that are  not rectangular 
  have been  removed. Some methods  have been added and  some modified to make 
  them more Gideros friendly. The vector library has been minified also.

  The way to create new collision rectangle is to call GSAT.Box()...

  name: GSAT.Box(x, y, w, h)
  desc: Returns a new collision rectangle with the specified dimensions, centered at the specified x, y position.
  xmpl: thing.box = GSAT.Box(thing:getX(), thing:getY(), thing:getWidth(), thing.getHeight)

  The following Methods apply to a collision rectangle created with GSAT.Box()...

  name: getPosition()
  desc: Returns current x, y position
  xmpl: Same as the Gideros function getPosition()

  name: setPosition(x, y)
  desc: Same as the Gideros function setPosition()
  
  name: getRotation()
  desc: Same as the Gideros function getrotation()
  
  name: setRotation(angle)
  desc: Same as the Gideros function setRotation()

  name: getBounds()
  desc: Same as the same named Gideros function (though the syntax os slightly different)
  xmpl: local x, y, w, h = thing.box:getBounds()

  To check for collisions between collision rectangles call GSAT.checkCollision()...

  name: GSAT.checkCollision(a, b, response)
  desc: Returns true if the 2 specified collision rectangles collide.
  xmpl: local collided = GSAT.checkCollision(thing1.box, thing2.box, response)
  note: If response was specified it will contain variables that can be used for collision resolution

  Responses are created by calling GSAT.Response()..

  name: GSAT.Response()
  desc: Returns a response structure that will be populated when calling GSAT.checkCollision()
  note: If you are going to reuse a response then call clear() on it first

--]]

--[[

  Andrey Rudenkos' GSAT.lua (https://bitbucket.org/RudenkoPaint/sat-lua)

  Version 0.4.1 - Copyright 2014 - Jim Riecken <jimr@jimr.ca>

  Released under the MIT License - https://github.com/jriecken/sat-js

  A simple library for determining intersections of circles and
  polygons using the Separating Axis Theorem.

--]]

local table_remove = table.remove
local table_insert = table.insert

local GSAT = {}

local Vector = {} Vector = {} Vector.metatable = {__index = Vector}
function Vector:new(x, y) local v = {} setmetatable(v, Vector.metatable) v.x = x or 0 v.y = y or 0 return v end
function Vector:copy(other) self.x = other.x self.y = other.y return self end
function Vector:clone() return Vector:new(self.x, self.y) end
function Vector:perp() local x = self.x self.x = self.y self.y = -x return self end
function Vector:rotate(angle) local sin, cos = math.sin, math.cos local x = self.x local y = self.y self.x = x * cos(angle) - y * sin(angle) self.y = x * sin(angle) + y * cos(angle) return self end
function Vector:reverse() self.x = -self.x self.y = -self.y return self end
function Vector:normalize() local d = self:len() if d > 0 then self.x = self.x / d self.y = self.y / d end return self end
function Vector:add(other) self.x = self.x + other.x self.y = self.y + other.y return self end
function Vector:sub(other) self.x = self.x - other.x self.y = self.y - other.y return self end
function Vector:scale(x, y) self.x = self.x * x self.y = self.y * y or x return self end
function Vector:project(other) local amt = self:dot(other) / self:len2(other) self.x = amt * other.x self.y = amt * other.y return self end
function Vector:projectN(other) local amt = self:dot(other) self.x = amt * other.x self.y = amt * other.y return self end
function Vector:reflect(axis) local x = self.x local y = self.y self:project(axis):scale(2,2) self.x = self.x - x self.y = self.y - y return self end
function Vector:reflectN(axis) local x = self.x local y = self.y self:projectN(axis):scale(2,2) self.x = self.x - x self.y = self.y - y return self end
function Vector:dot(other) return self.x * other.x + self.y * other.y end
function Vector:len2() return self:dot(self) end
function Vector:len() local sqrt = math.sqrt return sqrt(self:len2()) end
 
 --[[
  ## Polygon

  Represents a *convex* polygon with any number of points (specified in counter-clockwise order)

  Note: If you manually change the `points`, `angle`, or `offset` properties, you **must** call `recalc`
  afterwards so that the changes get applied correctly.

  Create a new polygon, passing in a position vector, and an array of points (represented
  by vectors relative to the position vector). If no position is passed in, the position
  of the polygon will be `(0,0)`.
 --]]

 local Polygon = {}
 Polygon = {}
 Polygon.metatable = {__index = Polygon}

 function Polygon:new(pos, points)
  local p = {}
  setmetatable(p, Polygon.metatable)
  p.pos = pos or Vector:new()
  p.points = points or {}
  p.angle = 0
  p.rotation = 0 -- ADDED BY ANTIX
  p.offset = Vector:new()
  p:recalc()
  return p
 end

 function Polygon:recalc() -- RECALCULATES EVERYTHING
  
  self.calcPoints = {} -- Calculated points - this is what is used for underlying collisions and takes into account the angle/offset set on the polygon.
  local calcPoints = self.calcPoints
 
  self.edges = {} -- The edges here are the direction of the `n`th edge of the polygon, relative to the `n`th point. If you want to draw a given edge from the edge value, you must first translate to the position of the starting point.
  local edges = self.edges
 
  self.normals = {} -- The normals here are the direction of the normal for the `n`th edge of the polygon, relative to the position of the `n`th point. If you want to draw an edge normal, you must first translate to the position of the starting point.
  local normals = self.normals
 
  local points = self.points -- Copy the original points array and apply the offset/angle
  local angle = self.angle
  local len = #points
  local offset = self.offset
  local ox, oy = offset.x, offset.y
  for i=1,len do
   local calcPoint = points[i]:clone()
   calcPoints[i] = calcPoint
   calcPoint.x = calcPoint.x + ox
   calcPoint.y = calcPoint.y + oy
   if angle ~= 0 then
     calcPoint:rotate(angle)
   end
  end

  for i=1, len do --Calculate the edges/normals
   local p1 = calcPoints[i]
   local p2 = i < len and calcPoints[i + 1] or calcPoints[1]
   local e = Vector:new():copy(p2):sub(p1)
   local n = Vector:new():copy(e):perp():normalize()
   edges[i] = e
   normals[i] = n
  end
  return self
 end

 function Polygon:getPosition() -- GET BOX X, Y POSITION
  return self.pos.x, self.pos.y
 end

 function Polygon:setPosition(x, y) -- SET BOX X, Y POSITION
  local p = self.pos
  p.x = x
  p.y = y
  self:recalc()
  return self
 end
 
 function Polygon:getRotation() -- GET BOX ANGLE (IN DEGREES)
  return self.rotation
 end
 
 function Polygon:setRotation(angle) -- SET BOX ANGLE (IN DEGREES)
  local d2r = math.pi / 180
  self.rotation = angle
  angle = angle * d2r
  
  self.angle = angle
  self:recalc()
  return self
 end
 
 function Polygon:getBounds() -- RETURN BOUNDS OF THIS BOX (X, Y, W, H)
  local points = self.calcPoints
  local pos = self.pos
  local x, y = pos.x, pos.y
  local ulx, uly = points[1].x + x, points[1].y + y
  local lrx, lry = ulx, uly
  for i = 2, #points do
   local p = points[i]
   local xx = p.x + x 
   local yy = p.y + y
   if ulx > xx then ulx = xx end
   if uly > yy then uly = yy end
   if lrx < xx then lrx = xx end
   if lry < yy then lry = yy end
  end
  return ulx, uly, lrx - ulx, lry - uly
 end

 function Polygon:rotate(angle) -- OBSOLETE
  local d2r = math.pi / 180
  self.rotation = angle
  angle = angle * d2r
  
  local points = self.points
  local len = #points
  for i=1,len do
   points[i]:rotate(angle)
  end
  self:recalc()
  return self
 end

 function Polygon:translate(x, y) -- OBSOLETE
  local points = self.points
  local len = #points
  for i=1,len do
   points[i].x = points[i].x + x
   points[i].y = points[i].y + y
  end
  self:recalc()
  return self
 end

 function Polygon:setPoints(points) -- OBSOLETE
  self.points = points
  self:recalc()
  return self
 end

 function Polygon:setOffset(offset) -- OBSOLETE
  self.offset = offset
  self:recalc()
  return self
 end

 -- ## Response
 -- An object representing the result of an intersection. Contains:
 -- - The two objects participating in the intersection
 -- - The vector representing the minimum change necessary to extract the first object
 --  from the second one (as well as a unit vector in that direction and the magnitude
 --  of the overlap)
 -- - Whether the first object is entirely inside the second, and vice versa.

 -- @constructor

 --local Response = {}

 local Response = {}
 Response = {}
 Response.metatable = {__index = Response} 

 function Response:new()
  local r = {}
  setmetatable(r, Response.metatable)
  r.a = nil
  r.b = nil
  r.overlapN = Vector:new()
  r.overlapV = Vector:new()
  r.ppos = {}
  r:clear()
  return r
 end
  -- Set some values of the response back to their defaults. Call this between tests if
  -- you are going to reuse a single Response object for multiple intersection tests (recommented
  -- as it will avoid allcating extra memory)

  -- @return {Response} This for chaining

  function Response:clear()
   self.aInB = true
   self.bInA = true
   self.overlap = math.huge
   return self
  end


 -- ## Object Pools

 -- A pool of `Vector` objects that are used in calculations to avoid
 -- allocating memory.

 -- @type {Array.<Vector>}

 local T_VECTORS = {}
 --for i=1,10 do table.insert( T_VECTORS, Vector:new()) end
 for i=1,10 do T_VECTORS[i] = Vector:new() end


 -- A pool of arrays of numbers used in calculations to avoid allocating
 -- memory.

 -- @type {Array.<Array.<number>>}

 local T_ARRAYS = {}
 --for i=1,5 do table.insert(T_ARRAYS, {}) end
 for i=1,5 do T_ARRAYS[i] = {} end


 -- Temporary response used for polygon hit detection.

 -- @type {Response}

 local T_RESPONSE = Response:new()

 -- Unit square polygon used for polygon hit detection.

 local UNIT_SQUARE = Polygon:new(Vector:new(0,0), { Vector:new(-0.5,-0.5), Vector:new(0.5,-0.5), Vector:new(0.5,0.5), Vector:new(-0.5,0.5) })





 -- @type {Polygon}

 -- ## Helper Functions

 -- Flattens the specified array of points onto a unit vector axis,
 -- resulting in a one dimensional range of the minimum and
 -- maximum value on that axis.

 -- @param {Array.<Vector>} points The points to flatten.
 -- @param {Vector} normal The unit vector axis to flatten on.
 -- @param {Array.<number>} result An array. After calling this function,
 --  result[0] will be the minimum value,
 --  result[1] will be the maximum value.

 function flattenPointsOn(points, normal, result)
  local min = math.huge
  local max = -math.huge
  local len = #points
  for i=1,len do
   -- The magnitude of the projection of the point onto the normal
   local dot = points[i]:dot(normal)
   if dot < min then 
    min = dot 
   end
   if dot > max then 
    max = dot 
   end
  end
  result[1] = min; result[2] = max

 end



 -- Check whether two convex polygons are separated by the specified
 -- axis (must be a unit vector).
 --[[
  @param {Vector} aPos The position of the first polygon.
  @param {Vector} bPos The position of the second polygon.
  @param {Array.<Vector>} aPoints The points in the first polygon.
  @param {Array.<Vector>} bPoints The points in the second polygon.
  @param {Vector} axis The axis (unit sized) to test against. The points of both pol
   will be projected onto this axis.
  @param {Response=} response A Response object (optional) which will be populated
   if the axis is not a separating axis.
  @return {boolean} true if it is a separating axis, false otherwise. If false,
   and a response is passed in, information about how much overlap and
   the direction of the overlap will be populated.
 --]]

 function isSeparatingAxis(aPos, bPos, aPoints, bPoints, axis, response)
  local rangeA = table_remove(T_ARRAYS)
  local rangeB = table_remove(T_ARRAYS)
  -- The magnitude of the offset between the two polygons
  local offsetV = table_remove(T_VECTORS):copy(bPos):sub(aPos)
  local projectedOffset = offsetV:dot(axis)
  -- Project the polygons onto the axis.
  flattenPointsOn(aPoints, axis, rangeA)
  flattenPointsOn(bPoints, axis, rangeB)
  -- Move B's range to its position relative to A.
  rangeB[1] = rangeB[1] + projectedOffset
  rangeB[2] = rangeB[2] + projectedOffset
  -- Check if there is a gap. If there is, this is a separating axis and we can stop
  if rangeA[1] > rangeB[2] or rangeB[1] > rangeA[2] then
   T_VECTORS[#T_VECTORS+1] = offsetV
   T_ARRAYS[#T_ARRAYS+1] = rangeA
   T_ARRAYS[#T_ARRAYS+1] = rangeB
   return true
  end
  --This is not a separating axis. If we're calculating a response, calculate the overlap.
  if response then
   local overlap = 0
   -- A starts further left than B
   if rangeA[1] < rangeB[1] then
    response.aInB = false
    -- A ends before B does. We have to pull A out of B
    if rangeA[2] < rangeB[2] then
     overlap = rangeA[2] - rangeB[1]
     response.bInA = false
     -- B is fully inside A. Pick the shortest way out.
    else
     local option1 = rangeA[2] - rangeB[1]
     local option2 = rangeB[2] - rangeA[1]
     overlap = option1 < option2 and option1 or -option2
    end
   -- B starts further left than A
   else
    response.bInA = false
    -- B ends before A ends. We have to push A out of B
    if rangeA[2] > rangeB[2] then
     overlap = rangeA[1] - rangeB[2]
     response.aInB = false
     -- A is fully inside B. Pick the shortest way out.
    else
     local option1 = rangeA[2] - rangeB[1]
     local option2 = rangeB[2] - rangeA[1]
     overlap = option1 < option2 and option1 or -option2
    end
   end
   local absOverlap = math.abs(overlap)
   if absOverlap < response.overlap then
    response.overlap = absOverlap
    response.overlapN:copy(axis)
    if overlap < 0 then
     response.overlapN:reverse()
    end
   end
  end
   T_VECTORS[#T_VECTORS+1] = offsetV
   T_ARRAYS[#T_ARRAYS+1] = rangeA
   T_ARRAYS[#T_ARRAYS+1] = rangeB
-----------------------------for jp -----------------------

------------------------------------------------------------
  return false
 end

 -- ## Collision Tests

 -- Check if a point is inside a convex polygon.

 -- @param {Vector} p The point to test.
 -- @param {Polygon} poly The polygon to test.
 -- @return {boolean} true if the point is inside the polygon, false if it is not.

 function pointInPolygon(p, poly)
  UNIT_SQUARE.pos:copy(p)
  T_RESPONSE:clear()
  local result = testPolygonPolygon(UNIT_SQUARE, poly, T_RESPONSE)
  if result then
   result = T_RESPONSE.aInB
  end
  return result
 end
 



 -- Checks whether polygons collide.

 -- @param {Polygon} a The first polygon.
 -- @param {Polygon} b The second polygon.
 -- @param {Response=} response Response object (optional) that will be populated if
 --  they interset.
 -- @return {boolean} true if they intersect, false if they don't.

function testPolygonPolygon(a, b, response)
 local aPoints = a.calcPoints
 local aLen = #aPoints
 local bPoints = b.calcPoints
 local bLen = #bPoints
 
 -- If any of the edge normals of A is a separating axis, no intersection.
 for i=1, aLen do
  if isSeparatingAxis(a.pos, b.pos, aPoints, bPoints, a.normals[i], response) then
   return false
  end
 end
 -- If any of the edge normals of B is a separating axis, no intersection.
 for i=1, bLen do
  if isSeparatingAxis(a.pos, b.pos, aPoints, bPoints, b.normals[i], response) then
   return false
  end
 end
 -- Since none of the edge normals of A or B are a separating axis, there is an intersection
 -- and we've already calculated the smallest overlap (in isSeparatingAxis). Calculate the
 -- final overlap vector.
 if response then
  response.a = a
  response.b = b
  response.overlapV:copy(response.overlapN):scale(response.overlap, response.overlap)
 end
 return true
end

GSAT.checkCollision = function(a, b, response)
 return testPolygonPolygon(a, b, response)
end
 
GSAT.Response = function()
 return Response:new()
end

GSAT.Vector = function(x,y)
 return Vector:new(x,y)
end

GSAT.Box = function(x, y, w, h)
 w = w * 0.5
 h = h * 0.5
 return Polygon:new(Vector:new(x,y), { Vector:new(-w,-h), Vector:new(w,-h), Vector:new(w,h), Vector:new(-w,h) })
end

GSAT.pointInPolygon = function(p, poly)
 return pointInPolygon(p, poly)
end

return GSAT
