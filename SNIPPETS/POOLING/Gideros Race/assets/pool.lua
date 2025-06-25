Pool = Core.class(Sprite)

function Pool:init()
	self.pool = {
		enemies = {},
		powerups = {},
	}
end

function Pool:createObject(what)
	local b
	--if there is anything in pool take it
	if #self.pool[what] > 0 then
		b = table.remove(self.pool[what])
		--reset you object properties here, before you return the
		--object or in your class destroy() function (init won't be executed again)
	else
		--you need to create a new instance of "what"
		if what == "enemies" then
			b = Enemie.new()
		elseif what == "powerups" then
			b = Powerup.new()
		end
	end
	b.destroy = nil
	--I would get b out of createObject() and add it in my code
	--instead of adding it directly to stage, so if I need to place the object
	--in another sprite I won't have to change it here..
	-- stage:addChild(b)

	return b
end

function Pool:destroyObject(b, what)
	b:removeFromParent()
	--actually there is a faster way than table.insert to write the same thing in the next line
	--table.insert(#self.pool[what], b)
	self.pool[what][#self.pool[what]+1] = b
	--b:destroy()
end
