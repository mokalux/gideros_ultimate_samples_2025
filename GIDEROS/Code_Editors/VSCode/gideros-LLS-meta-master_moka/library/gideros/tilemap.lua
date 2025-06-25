---@meta
---@diagnostic disable: codestyle-check

---@class TileMap : Sprite
---@field FLIP_DIAGONAL number
---@field FLIP_HORIZONTAL number
---@field FLIP_VERTICAL number
TileMap = {}

---
--- Creates a new TileMap instance
---
---@param width number # the width of the map in tiles
---@param height number # the height of the map in tiles
---@param texture TextureBase # The texture used in rendering tile map 
---@param tilewidth number # the width of the tile in pixels
---@param tileheight number # the height of the tile in pixels
---@param spacingx? number # The y-spacing in pixels between the tiles in this tileset (default 0)
---@param spacingy? number # The y-spacing in pixels between the tiles in this tileset (default 0)
---@param marginx? number # The x-margin from the top-left of the texture (default = 0) 
---@param marginy? number # The y-margin from the top-left of the texture (default = 0)
---@param displaywidth? number # The display width of a tile in pixels (default = tilewidth)
---@param displayheight? number # The display height of a tile in pixels (default = tileheight)
---@return TileMap
function TileMap.new(width, height, texture, tilewidth, tileheight, spacingx, spacingy, marginx, marginy, displaywidth, displayheight) end

---
---Set an empty tile at given indices. The tile indices are starting from 1.
---
---@param x number # x-position of tile
---@param y number # y-position of tile
function TileMap:clearTile(x, y) end

---Returns info on the tile at the specified co-ords, if it exists
---@param x number|nil # x-pos of tile
---@param y number|nil # y-pos of tile
---@return number|nil x # x-pos of tile
---@return number|nil y # y-pos of tile
---@return number|nil flip_flag # (TileMap.FLIP_DIAGONAL, TileMap.FLIP_HORIZONTAL, TileMap.FLIP_VERTICAL) of tile
---@return number|nil color_tint # color tint of tile
---@return number|nil alpha_tint # alpha tiny of tile
function TileMap:getTile(x, y) end

---
---Indicates if a tilemap should repeat itself
---
---@param x boolean # Tilemap should repeat along x axis 
---@param y boolean # Tilemap should repeat along y axis 
function TileMap:setRepeat(x, y) end

---
---Change the tile texture/atlas used by the tilemap.
---
---@param texture TextureBase # The texture used in rendering tile map 
---@param tilewidth number # width of the tile in pixels
---@param tileheight number # height of the tile in pixels
---@param spacingx? number # The y-spacing in pixels between the tiles in this tileset (default 0)
---@param spacingy? number # The y-spacing in pixels between the tiles in this tileset (default 0)
---@param marginx? number # The x-margin from the top-left of the texture (default = 0) 
---@param marginy? number # The y-margin from the top-left of the texture (default = 0)
function TileMap:setTexture(texture, tilewidth, tileheight, spacingx, spacingy, marginx, marginy) end

---
---Sets the index of the tile. The tile indices are starting from 1.
---
---@param x number # x-position of tile
---@param y number # y-position of tile
---@param tx number # x-index of tile
---@param ty number # y-index of tile
---@param flip number # flip flag of tile. Can be combination of TileMap.FLIP_HORIZONTAL, TileMap.FLIP_VERTICAL and TileMap.FLIP_DIAGONAL 
---@param color? number # Color tint of the tile, defaults to white (0xFFFFFF)
---@param alpha? number # Alpha tiny of the tile, defaults to opaque
function TileMap:setTile(x, y, tx, ty, flip, color, alpha) end

---
---Shifts the tile map to change tile's graphic. The arguments are in tiles, not in pixels. By shifting the tile map one by one as needed, you can create dynamic tile maps.
---
---@param dx number # the amount of x shift in tiles
---@param dy number # the amount of y shift in tiles
function TileMap:shift(dx, dy) end
