---@meta

---@class Texture : TextureBase
Texture = {}

---
---Create new Texture object
---
---@param imagefile string
---@param filtering? boolean
---@param options? TextureOptions
---@return Texture
function Texture.new(imagefile, filtering, options) end

---@class TextureOptions
---@field transparentColor number specifies which color stands for transparent for formats that don't supply an alpha channel such as JPEG
---@field wrap string how to treat texels outside the texture. Possible values are Texture.CLAMP and Texture.REPEAT
---@field format integer the GPU pixel format for the texture
---@field extend boolean whether the texture should be extended to a power of two size. Defaults to true
---@field scale number the scale at which this texture was made, if it cannot be determined by a suffix. Defaults to 1
---@field rawalpha boolean disable alpha premultiplication. This can be helpful if one wants to store specific data in the alpha channel of a texture along with a dedicated shader (new 2022.3)
