SoundEffects = Core.class(Sound)

function SoundEffects:init()

self.impact = Sound.new("sound/sound_efx/impact.wav")
self.explosion = Sound.new("sound/sound_efx/explosion1.wav")

end

function SoundEffects.playImpact(self)
	self.impact:play()
end

function SoundEffects.playExplosion(self)
	self.explosion:play()
end