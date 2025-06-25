---@meta

---
---RenderTarget is a texture on which the provided Sprite hierarchy can be rendered.
---
---It can be used in any case in which Texture can be used. 
---
---@class RenderTarget : TextureBase
RenderTarget = {}

---
---Creates a new RenderTarget object.
---
---@param width number # width of rendered texture
---@param height number # height of rendered texture
---@param filtering? boolean # sets texture filtering (default = false)
---@param repeating? boolean # sets texture repeating (default = false)
---@param autoscale? boolean # if the actual texture size should be scaled to match display resolution (default = false)
---@param depth? boolean # indicates this rendertarget will hold depth component. Setting this to true creates a render target suitable for shadow mapping (default = false)
---@param format? string|nil # specify the wanted pixel format for this render target. Use ones of the TextureBase format constants, or leave nil for default (default = TextureBase.RGBA8888)
---@param extend? boolean # extends the texture to a power of two size internally since Gideros 2022.5.1 (default = true)
function RenderTarget.new(width, height, filtering, repeating, autoscale, depth, format, extend) end

---
---Clears entire rendered texture or a rect of it with provided color and opacity. 
---
---@param color integer
---@param alpha number
---@param x? number # relative coord
---@param y? number # relative coord
---@param width? number
---@param height? number
function RenderTarget:clear(color, alpha, x, y, width, height) end

---
---Renders provided object or object hierarchy as a texture.
---
---@param sprite Sprite # any sprite inherited object or object hierarchy to render (this object doesn't need to be added to the stage hierarchy)
---@param x? number # x start position of the texture (default = 0)
---@param y? number # y start position of the texture (default = 0)
function RenderTarget:draw(sprite, x, y) end

---
---returns single pixels color and alpha channel
---
---@param x number
---@param y number
---@return integer color, number alpha
function RenderTarget:getPixel(x, y) end

---
---returns buffer containing color and alpha data from provided rectangle
---
---@param x number
---@param y number
---@param w number
---@param h number
---@return Buffer # buffer of data
function RenderTarget:getPixels(x, y, w, h) end

---
---saves content of RenderTarget as image
---
---can optionally provide dimensions of an inner rect to save
---
---@param filename string # filename and path to store file, like `|D|image.png`
---@param x? number
---@param y? number
---@param width? number
---@param height? number
function RenderTarget:save(filename, x, y, width, height) end
