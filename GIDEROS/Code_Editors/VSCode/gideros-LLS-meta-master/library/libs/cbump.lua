---@neta

---
--- O.G. Bump API: https://github.com/kikito/bump.lua
---
---@class BumpWorld
BumpWorld = {}

---
---@param cell_size? integer 
---@return BumpWorld
function BumpWorld.new(cell_size) end

function BumpWorld:add(sprite, x, y, width, height) end

---@param object table # table with `.name` field, add this field to a Sprite if using that table/object 
---@param new_x number 
---@param new_y number
---@param filter_callback function 
---@return number actual_x, number actual_y, BumpCollision[] collisions, integer num_collisions
function BumpWorld:move(object, new_x, new_y, filter_callback) end

function BumpWorld:remove(sprite) end

---@class BumpCollision
---@field item table # the item being moved / checked
---@field other table # an item colliding with the item being moved
---@field type string # the result of `filter(other)`. It's usually "touch", "cross", "slide" or "bounce"
---@field overlaps boolean # True if item "was overlapping" other when the collision started. 
---False if it didn't but "tunneled" through other
---@field ti number # Number between 0 and 1. How far along the movement to the goal did the collision occur?
---@field move table # Vector({x=number,y=number}). The difference between the original coordinates and the actual ones.
---@field normal table # Vector({x=number,y=number}). The collision normal; usually -1,0 or 1 in `x` and `y`
---@field touch table # Vector({x=number,y=number}). The coordinates where item started touching other
---@field itemRect table # The rectangle item occupied when the touch happened({x = N, y = N, w = N, h = N})
---@field otherRect table # The rectangle other occupied when the touch happened({x = N, y = N, w = N, h = N})
