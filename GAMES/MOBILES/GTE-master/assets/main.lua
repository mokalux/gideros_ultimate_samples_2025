--we'll probably need box2d
require "box2d"

world = b2.World.new(0, 10, true)

--NICK
player = Nick.new()

--TIPE PENGENDALI
controllerType = 1

--lock orientation that you need
stage:setOrientation(Stage.PORTRAIT)

transition = SceneManager.flipWithFade

--loading application settings
sets = dataSaver.loadValue("sets")
--if sets not define (first launch)
--define defaults
if(not sets) then
	sets = {}
	sets.sounds = true
	sets.music = true
	sets.curLevel = 1
	sets.curPack = 1
	dataSaver.saveValue("sets", sets)
end

--background music
music = {}

--load main theme
music.theme = Sound.new("audio/main.mp3")

--turn music on
music.on = function()
	if not music.channel then
		music.channel = music.theme:play(0,1000000)
		sets.music = true
		dataSaver.saveValue("sets", sets)
	end
end

--turn music off
music.off = function()
	if music.channel then
		music.channel:stop()
		music.channel = nil
		sets.music = false
		dataSaver.saveValue("sets", sets)
	end
end

--play music if enabled
if sets.music then
	music.channel = music.theme:play(0,1000000)
end

--sounds
sounds = {}

--load all your sounds here
--after that you can simply play them as sounds.play("hit")
sounds.complete = Sound.new("audio/complete.mp3")
sounds.hit = Sound.new("audio/hit.wav")
sounds.grunt = Sound.new("audio/grunt.wav")
sounds.gunshot = Sound.new("audio/gunshot.wav")
sounds.throw = Sound.new("audio/throw.wav")

--turn sounds on
sounds.on = function()
	sets.sounds = true
	dataSaver.saveValue("sets", sets)
end

--turn sounds off
sounds.off = function()
	sets.sounds = false
	dataSaver.saveValue("sets", sets)
end

--play sounds
sounds.play = function(sound)
	--check if sounds enabled
	if sets.sounds and sounds[sound] then
		sounds[sound]:play()
	end
end

--function for creating menu buttons
menuButton = function(image1, image2, container, current, all)
	local newButton = Button.new(Bitmap.new(Texture.new(image1)), Bitmap.new(Texture.new(image2)))
	local startHeight = (current-1)*(container:getHeight())/all + (((container:getHeight())/all)-newButton:getHeight())/2 + application:getContentHeight()/16
	newButton:setPosition((application:getContentWidth()-newButton:getWidth())/2, startHeight)
	return newButton;
end 
	
--load packs and level amounts from packs.json
packs = dataSaver.load("packs")

--define scenes
sceneManager = SceneManager.new({
	--start scene
	["start"] = start,
	--options scene
	["options"] = options,
	--pack select scene
	["pack_select"] = pack_select,
	--level select scene
	["level_select"] = level_select,
	--help scene
	["help"] = help,
	--level itself
	["level"] = level
})
--add manager to stage
stage:addChild(sceneManager)

--start start scene
sceneManager:changeScene("start", 1, transition, easing.outBack)