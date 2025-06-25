Box = Core.class(Bitmap)

function Box:init()
  local random = math.random
  self:setAnchorPoint(0.5, 0.5)
  self.position = {x = random() * MAXX, y = random() * MAXY}

  local vx, vy = 75 + random() * 100, 75 + random() * 100 -- make some velocities

  if random() < 0.5 then vx = -vx end -- reverse them at random
  if random() < 0.5 then vy = -vy end
  
  self.velocity = {x = vx, y = vy}

  self:setColorTransform(0.5 + random() * 0.5, 0.5 + random() * 0.5, 0.5 + random() * 0.5) -- make the box a random color
end

function Box:update(dt)
  local p, v = self.position, self.velocity
  
  local x, y = p.x + v.x * dt, p.y + v.y * dt

  if (x > MAXX) then
    v.x = -v.x
    x = MAXX
  elseif (x < 0) then
    x = 0
    v.x = -v.x
  end

  if (y > MAXY) then
    v.y = -v.y 
    y = MAXY
  elseif (y < 0) then
    y = 0
    v.y = -v.y
  end

  p.x, p.y = x, y -- save updated positions

  self:setPosition(x, y)
end

