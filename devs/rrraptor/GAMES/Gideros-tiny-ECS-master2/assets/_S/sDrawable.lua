SDrawable = Core.class()

function SDrawable:init()
--	self.system = tiny.system(self)
--	self.system.filter = tiny.requireAll("drawable")
	local system = tiny.system(self)
	system.filter = tiny.requireAll("drawable")
end

function SDrawable:onAdd(ent)
--	print("added")
	local comp = ent.drawable
	camera:add(comp.layerName, comp)
end

function SDrawable:onRemove(ent)
	local comp = ent.drawable
	camera:remove(comp.layerName, comp)
end

--[[
function SDrawable:preWrap(dt)
	print("preWrap", dt)
end

function SDrawable:postWrap(dt)
	print("postWrap", dt)
end

function SDrawable:onAddToWorld(w)
	print("onAddToWorld", w)
end

function SDrawable:onModify(dt)
	print("onModify", dt)
end
]]
