local music_vol = 1 -- music volume #music #volume
local sound_vol = 1 -- sfx volume #sfx #sound #snd #volume

local musicSliderX = (-80 + (music_vol * 160))
local soundSliderX = (-80 + (sound_vol * 160))
function makeMenuOptions () -- #options #menuoptions
	musicSliderX = (-80 + (music_vol * 160))
	soundSliderX = (-80 + (sound_vol * 160))
	menu3 = Menu3.new()
	stage:addChild(menu3)
	menu3:setPosition(160, 240)
	--[[bt1 = MenuButton.new("back", "backFromOptions", true, 0.5)
	menu3:addChild(bt1)
	bt1:setPosition(0, 170)]]
	bt2 = ButtonSlider.new("music")
	menu3:addChild(bt2)
	bt2:setPosition(musicSliderX, -16)
	bt3 = ButtonSlider.new("sound")
	menu3:addChild(bt3)
	bt3:setPosition(soundSliderX, 81)
	musicMenuPlaying = false
	--trackChannel:stop()
end
-- functions for options menu #soundvolume #musicvol #volume
local track = Sound.new("track.mp3")
local snd = Sound.new("sound.mp3")
function playMusicForMenu ()
	trackChannel = track:play()
	trackChannel:setVolume(music_vol)
end
function stopMusicForMenu ()
	trackChannel:stop()
end
function setMusicVol (vvv)
	--print("setting music vol ",vvv)
	music_vol = vvv
	trackChannel:setVolume(music_vol)
end
function playSoundForMenu ()
	soundChannel = snd:play(0,true) --loops for practical purposes
	soundChannel:setVolume(sound_vol)
end
function stopSoundForMenu ()
	soundChannel:stop()
end
function setSoundVol (ggg)
	sound_vol = ggg
	soundChannel:setVolume(sound_vol)
end

makeMenuOptions()