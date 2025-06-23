SDebugDraw = Core.class()

function SDebugDraw:init()
--	local ps = tiny.processingSystem(self) -- tiny constantly updates this system
--	ps.filter = tiny.requireAll("body", "pos", "active")
	tiny.processingSystem(self) -- tiny constantly updates this system
end

function SDebugDraw:filter(ent)
	-- * `function system:filter(entity)'
	-- Returns true if this System should include this Entity, otherwise should return false.
	-- If the Entity isn't specified, no Entities are included in the System.
	return ent.body and ent.pos and ent.body.active
end

function SDebugDraw:onAdd(ent)
	-- * `function system:onAdd(entity)`
	-- Called when an Entity is added to the System.
	local body, drawable, pos = ent.body, ent.drawable, ent.pos
	if (pos) then
		local w, h = body:getSize()
		local debug = Pixel.new(randomColor(), 0.5, w, h)
		-- component DRAWABLE
		local t = {
			drawable = CDrawable.new("debug"),
		}
		t.drawable:add(debug)
		if (drawable) then
			t.drawable:setAnchorPosition(drawable:getAnchorPosition())
		end
		ent.bodyDraw = t
		tworld:addEntity(t)
	end
end

function SDebugDraw:onRemove(ent)
	-- * `function system:onRemove(entity)`
	-- Called when an Entity is removed from the System.
	if (ent.bodyDraw) then
		tworld:remove(ent.bodyDraw)
	end
end

function SDebugDraw:process(ent, dt)
	local body = ent.body
	local pos = ent.pos
	ent.bodyDraw.drawable:setPosition(pos.x + body.offsetX, pos.y + body.offsetY)
end

-- optional
function SDebugDraw:preProcess(ent, dt)
end

function SDebugDraw:postProcess(ent, dt)
end
