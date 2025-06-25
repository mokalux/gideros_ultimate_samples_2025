--- Math Extension

-- Choose value
function choose(...)
	local _args = ...
	return _args[math.random(#_args)]
end

-- Set moving in direction (0 - 360 degrees) at speed
function getVelocityFromAngle(_direction)
  local _vx = math.cos(math.rad(_direction))
  local _vy = math.sin(math.rad(_direction))
  return _vx, _vy
end

-- Get the angle between two points 
function getAngelTwoPoints(_ax, _ay, _bx, _by)
	return math.atan2(_by - _ay, _bx - _ax) * 180 / math.pi
end
