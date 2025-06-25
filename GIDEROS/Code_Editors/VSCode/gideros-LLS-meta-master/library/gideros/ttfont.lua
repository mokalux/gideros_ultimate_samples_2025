---@meta

---@class TTFont : FontBase
TTFont = {}

---
--- Creates a new TTFont object
---
---@param filename string
---@param size number
---@param text string? # if specified, TTFont caches the characters of specified text to speed up the rendering. If instead of specified symbols empty quotes "" are provided, then all font symbols are cached
---@param filter_texture? boolean # default = false
---@param outline_size? number # if set, the font will be rendered with an outline of the given size
function TTFont.new(filename, size, text, filter_texture, outline_size) end