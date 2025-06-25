X_OFFSET = 10
Y_OFFSET = 5

Group = Core.class(Sprite)

function Group:init(name)
	self.name = name
	if (name) then 
		self.tf = tf(name)
		self:addChild(self.tf)
	end
	
	self.items = {}
	self.names = {}
	self.folded = false
	self.isItem = false
	self.isGroup = true
	
	self._fold = Sprite.new()
	self:addChild(self._fold)
end
--
function Group:load(t)
	local i = 1
	local n = #t
	while (i <= n) do 
		local v = t[i]
		if (type(v) == "string") then -- this is a subgroup
			local gr = Group.new(v)
			self:addSubGroup(gr)
			gr:load(t[i+1])
			i += 1
		else
			self:addItem(v)
		end
		i += 1
	end
end
--
function Group:addItem(sprite)
	local n = #self.items
	if (n == 0) then 
		if (self.name) then
			sprite:setPosition(X_OFFSET, self.tf:getHeight()*2)
		end
	else
		local last = self.items[n]
		local x,y = last:getPosition()
		local w,h = last:getSize()
		sprite:setPosition(x, y + h + Y_OFFSET)
	end
	sprite.isItem = true
	self.items[n+1] = sprite
	self._fold:addChild(sprite)
	self.ind = n+1
	return n+1
end
--
function Group:addSubGroup(group)
	local n = self:addItem(group)
	group.owner = self
	self.names[group.name] = n
end
--
function Group:reposFrom(start)
	for i = start+1, #self.items do 
		local prev = self.items[i-1]
		local cur = self.items[i]
		
		local x,y = prev:getPosition()
		local w,h = prev:getSize()
		cur:setPosition(x, y + h + Y_OFFSET)
	end	
	if (self.owner) then 
		self.owner:reposFrom(1)
	end
end
--
function Group:foldByName(name)
	local gr = self:getByName(name)
	gr:fold()
end
--
function Group:fold()	
	self.folded = true
	self._fold:removeFromParent()
	self:reposFrom(self.ind)
end
--
function Group:unfoldByName(name)
	local gr = self:getByName(name)
	gr:unfold()	
end
--
function Group:unfold()	
	self.folded = false
	self:addChild(self._fold)
	self:reposFrom(self.ind)
end
--
function Group:getByName(name)
	local gr_ind = self.names[name]
	assert(gr_ind, "No group with name \"" .. name .. "\".")
	return self.items[gr_ind]
end
--
function Group:switchByName(name)
	local gr = self:getByName(name)
	gr:switch()
end
--
function Group:switch()
	if (self.folded) then 
		self:unfold()
	else
		self:fold()
	end
end
--
function Group:queryXY(x, y)
	if (self.tf:hitTestPoint(x, y)) then 
		return self 
	end
	
	for i,g in ipairs(self.items) do 	
		if (g.isGroup) then 
			if (g.tf:hitTestPoint(x, y)) then 
				return g
			else	
				if (g:hitTestPoint(x, y) and #g.items > 0) then 
					return g:queryXY(x, y)
				end
			end
		elseif (g.isItem) then 
			if (g:hitTestPoint(x, y)) then 
				return g
			end
		end
	end
end
--
function Group:queryName(name)
	if (self.name == name) then 
		return self 
	end
	
	for i,g in ipairs(self.items) do 	
		if (g.isGroup) then 
			if (g.name == name) then 
				return g
			else	
				if (#g.items > 0) then 
					return g:queryName(name)
				end
			end
		end
	end
end
