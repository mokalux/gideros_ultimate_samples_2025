---@meta
---@diagnostic disable: codestyle-check

---The TextureRegion class specifies a texture and a rectangular region in it. It is used to define independent texture regions within a texture atlas (a large image which contains many smaller sub-images). 
---@class TextureRegion : Object
TextureRegion = {}

---
---Creates a new TextureRegion object. 
---
---If TextureRegion object is created with 1 parameter (texture), it specifies the whole texture.
---
---If TextureRegion object is created with 5 parameters (texture, x, y, width, height), it specifies a rectangular region within texture.
---
---@param texture TextureBase
---@param x? number # left co-ord of the region
---@param y? number # top co-ord of the region
---@param width? number
---@param height? number
function TextureRegion.new(texture, x, y, width, height) end

---
---Returns the coordinates of the region.
---If transparent areas were trimmed during texture pack export, also reports the amount trimmed. 
---
---@param base_coordinates? boolean # return values in base (@1) size
---@return number x # co-ord from texture
---@return number y # co-ord from texture
---@return number width # width of region
---@return number height # height of region
---@return number left_trim
---@return number top_trim
---@return number right_trim
---@return number bottom_trim
function TextureRegion:getRegion(base_coordinates) end

---
---Returns the scale factor of the underlying atlas 
---
---@return number scale
function TextureRegion:getScale() end

---
---Sets the coordinates of the region
---
---@param x number # left coordinate of region
---@param y number # top coordinate of region
---@param width number # width of region
---@param height number # height of region
function TextureRegion:setRegion(x, y, width, height) end
