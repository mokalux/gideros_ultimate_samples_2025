--Banana shape, SVG path format
local banana="M8.64,223.948c0,0,143.468,3.431,185.777-181.808c2.673-11.702-1.23-20.154,1.316-33.146h16.287c0,0-3.14,17.248,1.095,30.848c21.392,68.692-4.179,242.343-204.227,196.59L8.64,223.948z"
p=Path2D.new()
p:setSvgPath(banana) --Set the path from a SVG path description
p:setLineThickness(5) -- Outline width
p:setFillColor(0xFFFF80,0.7) --Fill color
p:setLineColor(0x404000) --Line color
p:setAnchorPosition(100,100)
p:setPosition(100,100)
stage:addChild(p)
 
local texture = Texture.new("test.png", true, {wrap = Texture.REPEAT})
local scl=Matrix.new()
scl:setScale(1/5) --Scale down by 5, so that the five textures unit fits in width and height
p:setTexture( texture, scl )
