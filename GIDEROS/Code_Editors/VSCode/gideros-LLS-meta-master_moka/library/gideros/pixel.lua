---@meta

---@class Pixel : Sprite
Pixel = {}

---
---Returns new Pixel object
---
---@param colour integer
---@param alpha number
---@param width number
---@param height number
---@return Pixel
---@overload fun(texture: Texture, width: number, height: number, tex_scale_x?: number, tex_scale_y?: number, tex_x?: number, tex_y?: number) : Pixel
---@nodiscard
function Pixel.new(colour, alpha, width, height) end

---
---returns the color(s) of the Pixel
---
---@param ... any
---@return any?
function Pixel:getColor(...) end

---
---returns the current size of the Pixel
---
---@param ... any
---@return any?
function Pixel:getDimensions(...) end

---
---returns the texture position
---
---@param ... any
---@return any?
function Pixel:getTexturePosition(...) end

---
---returns the texture scale
---
---@param ... any
---@return any?
function Pixel:getTextureScale(...) end

---
---sets the color of the Pixel
---
---@param ... any
---@return any?
function Pixel:setColor(...) end

---
---sets a gradient
---
---@param ... any
---@return any?
function Pixel:setColor(...) end

---
---sets a 4-colour gradient
---
---@param ... any
---@return any?
function Pixel:setColor(...) end

---
---sets both width and height of the Pixel
---
---@param ... any
---@return any?
function Pixel:setDimensions(...) end

---
---sets the height of the Pixel sprite
---
---@param ... any
---@return any?
function Pixel:setHeight(...) end

---
---sets a 9-patch style texture rendering
---
---@param ... any
---@return any?
function Pixel:setNinePatch(...) end

---
---attaches a texture to the Pixel
---
---@param ... any
---@return any?
function Pixel:setTexture(...) end

---
---specifies a transform matrix for the texture
---
---@param ... any
---@return any?
function Pixel:setTextureMatrix(...) end

---
---sets a texture position
---
---@param ... any
---@return any?
function Pixel:setTexturePosition(...) end

---
---sets a texture scale
---
---@param ... any
---@return any?
function Pixel:setTextureScale(...) end

---
---sets the width of the Pixel sprite
---
---@param ... any
---@return any?
function Pixel:setWidth(...) end
