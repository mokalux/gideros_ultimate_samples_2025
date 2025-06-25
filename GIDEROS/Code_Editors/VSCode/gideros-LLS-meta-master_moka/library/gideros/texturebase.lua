---@meta

---
---TextureBase is the base class for Texture, TexturePack and RenderTarget classes. It provides 
---a common functionality to texture related classes. 
---
---@class TextureBase : Object
---@field CLAMP string
---@field REPEAT string
---@field RGB565 string
---@field RGB888 string
---@field RGBA4444 string
---@field RGBA5551 string
---@field RGBA8888 string
---@field Y8 string
---@field A8 string
---@field YA8 string
TextureBase = {}

---
---Returns the height of the texture in pixels. 
---
---@return number # the height of the texture in pixels. 
function TextureBase:getHeight() end

---
---Returns the width of the texture in pixels. 
---
---@return number # the width of the texture in pixels. 
function TextureBase:getWidth() end

---
---Returns the size of a texture. 
---
---@return number w, number h # width/height of texture
function TextureBase:getSize() end

---
---Returns the size of a texel that is 1/(gpu texture width), 1/(gpu texture height). 
---
---@return number w, number h # width/height of texel
function TextureBase:getTexelSize() end
