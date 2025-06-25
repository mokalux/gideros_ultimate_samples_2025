--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
* And modified by Ali Lopez zero.exu@gmail.com
]]--

--Add monitorMemory
local monitorM = monitorMemoryUtility:new()
stage:addChild(monitorM)

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

--setup language
if(not dataSaver.loadValue("language")) then			
	dataSaver.saveValue("language","es")
end

_LANGUAGE=dataSaver.loadValue("language")
print("language",_LANGUAGE)

--load packs and level amounts from packs.json
packs = dataSaver.load("packs")

--load buttons Games because is used in anywhere of the game
_SHEETBUTTONS		= TexturePack.new("images/".._LANGUAGE.."_buttons.txt", "images/".._LANGUAGE.."_buttons.png")

--SETUP ADUDIO AND SOUNDS

--background music
music = {}

--load main theme
music.theme = Sound.new("sounds/music/main.mp3")

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
sounds.complete = Sound.new("sounds/sfx/complete.mp3")
sounds.hit = Sound.new("sounds/sfx/hit.wav")

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


--Add Game scenes
transition = SceneManager.fade
_SCENETIMETRANSITION=1
sceneManager = SceneManager.new({
	--start scene
	["sceneHome"] = sceneHome,
	--pack select scene
	["scenePackSelect"] = scenePackSelect,
	--level select scene
	["sceneLevelSelect"] = sceneLevelSelect,
	--level loader scene
	["sceneLevelLoader"] = sceneLevelLoader,
	--options scene
	["sceneOptions"] = sceneOptions,
	--credits scene
	["sceneCredits"] = sceneCredits,
	--social scene
	["sceneSocial"] = sceneSocial,
	--store scene
	["sceneStore"] = sceneStore,
	--score scene
	["sceneScore"] = sceneScore,	
})
--agregando sceneManager al stage
stage:addChild(sceneManager)

--configurando escena Inicial
sceneManager:changeScene("sceneHome", _SCENETIMETRANSITION, transition, easing.outBack)