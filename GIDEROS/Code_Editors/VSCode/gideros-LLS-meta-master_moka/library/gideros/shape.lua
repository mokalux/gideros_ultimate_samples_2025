---@meta
---@diagnostic disable: codestyle-check

--@param winding? string # specifies the winding rule. (default)Shape.EVEN_ODD | Shape.NON_ZERO

---@class Shape : Sprite
---@field NONE string # fill style
---@field SOLID string # fil style
---@field TEXTURE string # fill style
---@field EVEN_ODD string # winding
---@field NON_ZERO string # winding
Shape = {}

---@return Shape
function Shape.new() end

---
---Resets the current path
---
---@param winding? string # specifies winding rule
---|`Shape.EVEN_ODD`
---|`Shape.NON_ZERO`
function Shape:beginPath(winding) end

---
---Clears the graphics that were drawn to this Shape object, and resets fill and line style settings.
---
function Shape:clear() end

---
---Marks the current subpath as closed, and starts a new subpath with a point the same as the start and end of the newly closed subpath.
---
function Shape:closePath() end

---
---Ends the current beginPath
---
function Shape:endPath() end

---
--- adds the given point to the current subpath, connected to the previous one by a straight line
---
---@param x number
---@param y number
function Shape:lineTo(x, y) end

---
---Creates a new subpath with the given point.
---
---@param x number
---@param y number
function Shape:moveTo(x, y) end

---
---Sets the line style the Shape object uses for subsequent drawings. The line style remains in effect until you call setLineStyle() function with different parameters. 
---
---@param line_width number # If this parameter is 0, line is not drawn
---@param color integer
---@param alpha number
function Shape:setLineStyle(line_width, color, alpha) end

---@param fill_style string @Shape.NONE | Shape.SOLID | Shape.TEXTURE
---|`Shape.NONE` # clears the fill style
---|`Shape.SOLID` # solid color: extra params are color and an optional alpha value
---|`Shape.TEXTURE` # textured: extra params are texture and an optional transform matrix
---@param ... any # as per fill_style 
function Shape:setFillStyle(fill_style, ...) end
