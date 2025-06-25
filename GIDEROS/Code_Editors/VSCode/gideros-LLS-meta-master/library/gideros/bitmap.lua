---@meta
---@diagnostic disable: codestyle-check

---@class Bitmap : Sprite
Bitmap = {}

---
---Create new bitmap object using a Texture
---
---@param texture TextureBase|TextureRegion
---@return Bitmap
function Bitmap.new(texture) end

---
---Returns the x and y coordinates of the anchor point.
---
---@return number x_coord, number y_coord
function Bitmap:getAnchorPoint() end

---
---Sets the anchor point of a Bitmap object.
---
---Each Bitmap object has an anchor point that affects the positioning of the texture displayed. By modifying the anchor point, you change the origin of the texture. For example, setting the anchor point to (0.5, 0.5) moves the center of the texture to the origin. If you set the anchor point to (1, 1) instead, the bottom-right corner of the texture will be the origin. The default value of anchor point is (0, 0) which means top-left of the texture is the origin by default.
---
---@param x number # x coordinate of anchor point, usually between [0, 1]
---@param y number # y coordinate of anchor point, usually between [0, 1]
function Bitmap:setAnchorPoint(x, y) end

---
---Sets the texture of the bitmap
---
---@param texture TextureBase
function Bitmap:setTexture(texture) end

---
---@param texture_region TextureRegion
function Bitmap:setTextureRegion(texture_region) end
