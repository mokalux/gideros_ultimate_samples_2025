-- set the tilemap texture
local texture = Texture.new("gfx/image.png")

-- test 1
-- create the tileset
local tm = TileMap.new(
	10, 10, -- map size in tiles
	texture,
	16, 16, -- tile size in pixel
	0, 0, -- spacing
	0, 0, -- margin
	16, 16 -- display width and height
)
-- make the tilemap
for i = 1, 4 do
	for j = 1, 4 do
		tm:setTile(i, j, i, j)
	end
end
-- some other tiles in the tilemap
tm:setTile(6,3,5,1) -- col, row, tile col index in tilemap, tile row index in tilemap
tm:setTile(7,3,5,1) -- col, row, tile col index in tilemap, tile row index in tilemap
tm:setTile(7,4,5,3) -- col, row, tile col index in tilemap, tile row index in tilemap
-- position the tilemap and add to stage
tm:setPosition(0, 0)
stage:addChild(tm)

-- test 2
local shape = Shape.new()
shape:setFillStyle(Shape.TEXTURE, texture)
shape:beginPath()
shape:moveTo(0, 0)
shape:lineTo(100, 0)
shape:lineTo(100, 80)
shape:lineTo(0, 80)
shape:closePath()
shape:endPath()
shape:setPosition(0, 96)
stage:addChild(shape)

-- test 3
local mesh = Mesh.new()
mesh:setVertexArray(0, 0, 100, 0, 100, 80, 0, 80)
mesh:setIndexArray(1, 2, 3, 1, 3, 4) 
mesh:setTextureCoordinateArray(0, 0, 100, 0, 100, 80, 0, 80) 
mesh:setTexture(texture)
mesh:setPosition(0, 196)
stage:addChild(mesh)
