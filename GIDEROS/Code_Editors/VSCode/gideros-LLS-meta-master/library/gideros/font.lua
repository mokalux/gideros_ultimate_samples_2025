---@meta

---@class FontBase

---@class Font
Font = {}

---
---Creates a new Font object
---
---@param text_file string
---@param image_file string
---@param filter_texture boolean # (default = false) whether or not the font texture is filtered
---@return Font
function Font.new(text_file, image_file, filter_texture) end

---
---Returns the Font object used as the default font in Gideros. 
---
---@return Font
function Font:getDefault() end

