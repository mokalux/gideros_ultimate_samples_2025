function Sprite:collidesWith(sprite2)
local x,y,w,h = self:getBounds(stage)
local x2,y2,w2,h2 = sprite2:getBounds(stage)
return not ((y+h < y2) or (y > y2+h2) or (x > x2+w2) or (x+w < x2))
end