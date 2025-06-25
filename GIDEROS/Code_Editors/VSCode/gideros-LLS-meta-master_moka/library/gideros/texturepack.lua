---@meta

---@class TexturePack : TextureBase
TexturePack = {}

---@param ... any
---@return TexturePack
function TexturePack.new(...) end

---@param filename string
---@return table regions_names
function TexturePack:getRegionsNames(filename) end

---
---Return the texture region for the given texture name.
---
---@param texture_name string
---@return TextureRegion
function TexturePack:getTextureRegion(texture_name) end
