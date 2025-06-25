Background = Core.class(Sprite)

function Background:init()
  local texture = Texture.new("images/background.png", false, {wrap = Texture.REPEAT})
  local region = TextureRegion.new(texture, 0, 0, WIDTH, HEIGHT)
  local bitmap = Bitmap.new(region)
  bitmap.region = region
  self:addChild(bitmap)
  
  self.textureSize = texture:getWidth()
end

function Background:update(x, y)
  local bitmap = self:getChildAt(1)
  local region = bitmap.region
  region:setRegion(x % self.textureSize, y % self.textureSize, WIDTH, HEIGHT)
  bitmap:setTextureRegion(region)
end

