-- VFX
function EffectExplode(_parent, _scale, _x, _y, _r, _speed, _count, _color)
	local p = Particles.new()
	p:setPosition(_x, _y)
	p:setScale(_scale)
	_parent:addChild(p)
	local parts = {}
	for i = 1, _count do
		local a = math.random() * 6.3
		local dx, dy = math.sin(a), math.cos(a)
		local sr = math.random() * _r
		local px, py = dx * sr, dy * sr
		local ss = (_speed or 1) * (1 + math.random())
		table.insert(parts,
			{
				x = px, y = py,
				speedX = dx * ss,
				speedY = dy * ss,
				color = _color,
				speedAngular = math.random() * 4 - 2,
				decayAlpha = 0.95 + math.random() * 0.04,
				ttl = 1 * CONST.FPS,
				size = 10 + math.random() * 20
			}
		)
	end
	p:addParticles(parts)
	Core.yield(2)
	p:removeFromParent()
end

function EffectExplodeEx(_parent, _scale, _x, _y, _r, _speed, _count, _color)
	local p = Particles.new()
	p:setPosition(_x, _y)
	p:setScale(_scale)
	_parent:addChild(p)
	local parts = {}
	for i = 1, _count do
		local a = math.random() * 6.3
		local dx, dy = math.sin(a), math.cos(a)
		local sr = math.random() * _r
		local px, py = dx * sr, dy * sr
		local ss = (_speed or 1) * (1 + math.random())
		table.insert(parts,
			{
				x = px, y = py,
				speedX = dx * ss,
				speedY = dy * ss,
				color = _color,
				speedAngular = math.random() * 4 - 2,
				decayAlpha = 0.95 + math.random() * 0.04,
				ttl = 1 * CONST.FPS,
				size = 10 + math.random() * 20
			}
		)
	end
	p:addParticles(parts)
	--Core.yield(2)
	--p:removeFromParent()
end