Trap1 = Core.class(Sprite)

function Trap1:init(scene,id)

	self.id = id
	self.scene = scene

end



function Trap1:doTrap()

	for i,v in pairs(self.scene.thinSpikes) do
		v:close()
	end
	
	Timer.delayedCall(3000, self.openDropDoors, self)

end



function Trap1:openDropDoors()

	for i,v in pairs(self.scene.dropDoors) do
		v:open()
	end

end





