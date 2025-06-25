local texture = TexturePack.new("cards.txt", "cards.png", true)

local region = texture:getTextureRegion("card3.png")
local x, y, w, h = region:getRegion()

local mesh = Mesh.new()
mesh:setVertexArray(0, 0, 90, 0, 90, 128, 0, 128)
mesh:setIndexArray(1, 2, 3, 1, 3, 4)
mesh:setTextureCoordinateArray(x, y, x + w, y, x + w, y + h, x, y + h)
mesh:setTexture(texture)
stage:addChild(mesh)
