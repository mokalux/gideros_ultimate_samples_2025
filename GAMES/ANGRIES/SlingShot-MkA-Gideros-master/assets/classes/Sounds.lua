Sounds = Core.class(EventDispatcher)

function Sounds:init()
	
	self.sounds = {}

end

function Sounds:add(name, sound)
	if self.sounds[name] == nil then
		self.sounds[name] = {}
	end
	self.sounds[name][#self.sounds[name]+1] = Sound.new(sound)
end



function Sounds:play(name)
	if  self.sounds[name] then
		self.sounds[name][math.random(1, #self.sounds[name])]:play()
	end
end
