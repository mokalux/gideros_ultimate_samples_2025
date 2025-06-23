-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!! WARNINGS ONLY USE WITH application SCALE = LetterBox !!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- otherwise Gideros Player crashes!

-- !!!!!! WARNINGS ONLY USE WITH application SCALE = LetterBox !!!!!!


imagepath = "images" -- set this path to your image folder
backbuttonTexture = Texture.new("resources/backbutton.png")
leftbuttonTexture = Texture.new("resources/leftbutton.png")
rightbuttonTexture = Texture.new("resources/rightbutton.png")
skyworldTexture = Texture.new("resources/skyworld.png")
splashscreenPack = TexturePack.new("resources/splashscreen.txt","resources/splashscreen.png")
splashscreenDesc = io.open("resources/splashscreen.txt", "rb"):read"*a"
fruitsPack = TexturePack.new("resources/fruits.txt", "resources/fruits.png")
fruitsDesc = io.open("resources/fruits.txt", "rb"):read"*a"
ringtile = Texture.new("resources/ringtile.png", true, {wrap = Texture.REPEAT})

application:configureFrustum(90)

local function getFontCache(charsets)
	local t = {}
	local n = 0
	for k,v in ipairs(charsets) do
		for i = v[1], v[2] do
			n = n + 1
			t[n] = utf8.char(i)
--			print(t[n])
		end
	end
	return table.concat(t)
end

local charsets = {
	{0x0020,0x007F},
	{0x0080,0x009F},
	{0x00A0,0x00FF},
	{0x0100,0x017F},
	{0x0180,0x024F},
	{0x0250,0x02AF},
	{0x02B0,0x02FF},
	{0x0300,0x036F},
	{0x0370,0x03FF},
	{0x0400,0x0458},
	{0x0500,0x052F},
	{0x0530,0x058F},
}

local fontcache = getFontCache(charsets)

font = TTFont.new("resources/BlissPro-Bold.otf", 150, fontcache)
temfont1 = TTFont.new("resources/BlissPro-Bold.otf", 18, fontcache)
temfont2 = TTFont.new("resources/BlissPro-Bold.otf", 16, fontcache)
temfont3 = TTFont.new("resources/BlissPro-Bold.otf", 12, fontcache)


----------------------------------------------------------
require "dataSaver"
sets = dataSaver.loadValue("sets") --loading application settings

if sets == nil then -- game first launch
	sets = {}
	
	sets.theme	= "default"
	sets.sounds 	= true
	sets.music 	= false
	sets.particle 	= false
	
	dataSaver.saveValue("sets", sets)
end

-------------------------------------------SOUNDS Settings
channel = nil
sounds = {} --sounds table

sounds.play = function(sound) -- load all your sounds here, you can play as sounds.play("hit")
	if sets.sounds and sounds[sound] then	--check if sounds enabled
		channel = sounds[sound]:play()
	end
end

--stop sounds
sounds.stop = function(sound)
	if channel:isPlaying() then 	--check if channel enabled
		channel:stop()
	end
end
