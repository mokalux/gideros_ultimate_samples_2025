level10 = Core.class(Sprite)

function level10:init()

	if(not(levelTitles[levelNum])) then
		print("WARNING: NO LEVEL TITLE - ADD IN main.lua")
	
	end
	
	if(enableTitleScreen) then
	
		local loadingScreen = Sprite.new() -- make layer to move medals behind stone
		stage:addChild(loadingScreen)
		self.loadingScreen = loadingScreen
		
		local img = Bitmap.new(Texture.new("gfx/level title bg.png", true))
		loadingScreen:addChild(img)
		
		fadeFromBlack()
		
		local fonts = Fonts.new(self)
		self:addChild(fonts)
		
		local signText = BMTextField.new(self.levelTitleFont, levelTitles[levelNum], 0, "center")
		signText:setScale(self.scalex, self.scaley)
		loadingScreen:addChild(signText)
		self.signText = signText
		
		self.signText:setPosition(application:getContentWidth()/2,application:getContentHeight()/2-15)
		
		local loading = BMTextField.new(self.loadingFont, "Loading...", 0, "center")
		loading:setScale(self.scalex, self.scaley)
		loading:setPosition(application:getContentWidth()/2,signText:getY()+50)
		loadingScreen:addChild(loading)

		loadingScreen:setScale(aspectRatioX, aspectRatioY)
		loadingScreen:setPosition(xOffset,yOffset)
		Timer.delayedCall(500, self.setup, self)
		
	else
	
		--self:setup()
		
	end
	
	self:addEventListener("onPause", self.onPause, self)
	self:addEventListener("onResume", self.onResume, self)
	self:addEventListener("onExit", self.onExit, self)

end


function level10:fadeTheme()

	channel:setVolume(channel:getVolume()-.01)
	if(channel:getVolume()<0) then
		channel:setPaused(true)
		self:removeEventListener(Event.ENTER_FRAME, self.fadeTheme, self)
		self:playLevelMusic()
	end
	
end

function level10:setup()
	
	-- Test mode (Show physics bodies) 
	-- Note - hero wont be on correct layer...

	--self.showBodies = true
	self.showImages = true
	--self.wind = true -- turn on wind effect, settings further down

	-- Show loot as we collect it
	--self.showLootCollected = true	-- Show loot as we collect it

	-- Load volume setting
	
	local file = io.open("|D|saveGame.json", "r" )
	if(file) then

		self.saveGame = dataSaver.load("|D|saveGame") -- load it
		io.close( file )
		
		if(self.saveGame.soundVol) then
		
		self.soundVol = self.saveGame.soundVol
		self.musicVol = self.saveGame.musicVol
		
		else
		
			self.soundVol = defaultSoundVol
			self.musicVol = defaultMusicVol
		
		end
		
	else

		self.soundVol = defaultSoundVol
		self.musicVol = defaultMusicVol
		
	end

	-- Hide controls
	--self.hideControls = true

	-- Require things for this level

	--require("Classes/CatFlap")


	--require("Classes/Acid Fish")
	require("Classes/Ball")
	require("Classes/BallParticles")
	--require("Classes/BallPressurePlate")
	require("Classes/BallSpawner")
	--require("Classes/Bullet")
	--require("Classes/CreeperBug")
	require("Classes/CarryBug") 
	--require("Classes/DownSpike")
	--require("Classes/DragBlock")
	--require("Classes/DragBlockDoor") 
	--require("Classes/DragBlockButton")
	--require("Classes/Drop Door") -- for chamber
	--require("Classes/DropSpider")
	--require("Classes/DropSpiderThread")
	require("Classes/DropSwitch")
	--require("Classes/EyeMiniGame")
	--require("Classes/ExplodingFruit")
	require("Classes/FixedBackground")
	--require("Classes/FlyingShooter")
	--require("Classes/FlyingWraith")
	--require("Classes/FollowBug")
	require("Classes/Fruit")
	--require("Classes/Germ")
	require("Classes/JellyFish")
	require("Classes/KeyDoor")
	require("Classes/KeyParticles")
	--require("Classes/Leaves")
	--require("Classes/Masher Left Right")
	require("Classes/Masher Up Down")
	--require("Classes/MasherWithSpring")
	--require("Classes/PluckEye")
	require("Classes/Pot")
	require("Classes/Pot Smash")
	require("Classes/Rounder Monster")
	--require("Classes/Spinner")
	--require("Classes/Saw")
	--require("Classes/ShyWorm")
	--require("Classes/ShyWormBush")
	--require("Classes/Spike")
	--require("Classes/Spinner")
	--require("Classes/SwapFruit")
	--require("Classes/ThinSpike")
	--require("Classes/Thwomper")
	--require("Classes/TongueDoor")
	require("Classes/TreasureMite")
	require("Classes/TreasureHeap")
	--require("Classes/Turret")
	--require("Classes/Trap1")
	require("Classes/VolumeByDistance")
	--require("Classes/WalkingChest")
	--require("Classes/WalkingChestParticles")
	--require("Classes/Wind")
	require("Classes/WormWraith")

	-- Bring in atlases
	
	unloadAtlas(15)
	unloadAtlas("Mud Tileset")
	
	loadAtlas(16,"Atlas 16")
	loadAtlas("Sandstone Tileset", "Sandstone Tileset")

	self.atlas = {}
	self.atlas[2] = atlasHolder[2]
	self.atlas[16] = atlasHolder[16]
	self.atlas['Sandstone Tileset'] = atlasHolder['Sandstone Tileset']

	self:addEventListener(Event.ENTER_FRAME, self.fadeTheme, self)
	
	-- Create anim loaders

	local animLoader = CTNTAnimatorLoader.new()
	animLoader:loadAnimations("Animations/Atlas 2 Animations.tan", self.atlas[2], true)
	self.atlas2AnimLoader = animLoader

	--[[local animLoader = CTNTAnimatorLoader.new()
	animLoader:loadAnimations("Animations/Atlas 16 Animations.tan", self.atlas[16], true)
	self.atlas16AnimLoader = animLoader
--]]
	--self:removeChild(loading)
	--loading = nil;
	--self:removeEventListener(Event.ENTER_FRAME, preloader)
	
	--------------------------------------------------------------
	-- Setup - different for each level
	--------------------------------------------------------------

	self.showHitBoxes = true -- show non box 2d hit boxes
	
	self.levelNumber = 10
	self.worldNumber = 1

	-- Set up targets for this level

	self.lootBronzeTarget = 1000
	 
	self.lootSilverTarget = 1460

	self.lootGoldTarget = 2530

	self.coinValue = 10


	self.minutesLeft = 3
	self.secondsLeft = 20

	-- testing
	--self.minutesLeft = 300


	-- World width and height (get from Rube - 1 square = 100 pixels
	self.worldWidth = 4000
	self.worldHeight = 5000

	self.levelData = "Level Data/Level 10 Data.lua"

	--------------------------------------------------------------
	-- Setup - don't need to edit
	--------------------------------------------------------------

	self.coins = {} -- this table stores the coins

	self.pauseResumeExitSprites = {}
	local spritesOnScreen = {}
	self.spritesWithVolume = {}
	self.spritesOnScreen = spritesOnScreen

	self.loot = 0 -- loot collected this level
	self.clawObjects = {} -- this table will store all objects that the claw can pick up
	self.clawLoot = {}
	self.crystals = {}
	self.pots = {}
	self.enemies = {} -- used to pause enemy anim
	self.medal = 0 
	self.particleEmitters = {} -- stores particle emitters, used for pausing
	self.doors = {} -- Holds doors opened by keys
	self.dropDoors = {} -- stores doors that fall down
	self.thinSpikes = {}
	self.shyWorms = {}
	self.shyWormBushes = {}
	self.jumpThroughPlatforms = {}
	self.dropSpiders = {}
	self.dropSpiderYs = {}
	self.keyDoors = {}
	self.keys = {}
	self.dragBlocks = {} -- table that holds dragable blocks
	
	self.sprites = {} -- sets sprites not visible if off screen
	local class = SpritesOffScreen.new(self)
	self:addChild(class)

	-- Set up volume class (fades FX based on distance)
	
	local class = VolumeByDistance.new(self)
	self.volumeByDistance = class
	self:addChild(class)

	--------------------------------------------------------------
	-- Layers
	--------------------------------------------------------------

	-- bg layers

	local layer = Sprite.new()
	self:addChild(layer)
	self.bgLayer = layer

	local layer = Sprite.new()
	self:addChild(layer)
	self.fgLayer = layer

	local layer = Sprite.new()
	self:addChild(layer)
	self.fixedBGLayer = layer

	-- Very back layer

	local layer0 = Sprite.new()
	self:addChild(layer0)
	self.layer0 = layer0

	-- Behind rube layer

	local behindRube = Sprite.new()
	self:addChild(behindRube)
	self.behindRube = behindRube

	-- Enemies

	local enemyLayer = Sprite.new()
	self:addChild(enemyLayer)
	self.enemyLayer = enemyLayer

	-- Rube images behind hero
	local rube1 = Sprite.new()
	self:addChild(rube1)
	self.rube1 = rube1

	-- Collectibles

	local collectibles = Sprite.new()
	self:addChild(collectibles)
	self.collectibles = collectibles

	-- Physics layer
	if(not(self.showBodies))then
		self.physicsLayer = Sprite.new()
		self:addChild(self.physicsLayer)
	end
	
	local clawLayer = Sprite.new()
	self:addChild(clawLayer)
	self.clawLayer = clawLayer

	-- Rube images in front of hero
	local rube2 = Sprite.new()
	self:addChild(rube2)
	self.rube2 = rube2
	
	local rube3 = Sprite.new()
	self:addChild(rube3)
	self.rube3 = rube3

	local sprite = Sprite.new()
	self:addChild(sprite)
	self.outOfTimeBlackLayer = sprite
	
	local frontLayer = Sprite.new()
	self:addChild(frontLayer)
	self.frontLayer = frontLayer

	-- Interface layer

	local interfaceLayer = Sprite.new()
	self:addChild(interfaceLayer)
	self.interfaceLayer = interfaceLayer

	-- Text Layer

	local textLayer = Sprite.new()
	self:addChild(textLayer)
	self.textLayer = textLayer

	-- Layer for the black overlay

	local blackLayer = Sprite.new()
	self:addChild(blackLayer)
	self.blackLayer = blackLayer

	-- This layer stays on top and does not scrolling
	-- Used for interface stuff like signs and target achieved text

	local topLayer = Sprite.new()
	self:addChild(topLayer)
	self.topLayer = topLayer

	-- Physics layer
	if(self.showBodies)then
		self.physicsLayer = Sprite.new()
		self:addChild(self.physicsLayer)
	end

	--------------------------------------------------------------
	-- Set up background
	--------------------------------------------------------------

	local bg = Background.new(self,"Backgrounds/bg10 background.png",self.worldWidth,self.worldHeight,"Backgrounds/bg10 foreground.png",self.worldWidth,self.worldHeight)



	--------------------------------------------------------------
	-- Physics
	--------------------------------------------------------------


	local b2World = Box2d.new(self)
	self.b2World = b2World
	self.physicsLayer:addChild(b2World) -- Add physics to screen
		
	-- Debug mode

	--set up debug drawing
	if(self.showBodies) then
		local debugDraw = b2.DebugDraw.new()
		self.world:setDebugDraw(debugDraw)
		self.physicsLayer:addChild(debugDraw)
	end

	--------------------------------------------------------------
	-- Fonts
	--------------------------------------------------------------

	local fonts = Fonts.new(self)
	self:addChild(fonts)

	--------------------------------------------------------------
	-- Rube Level Data
	--------------------------------------------------------------

	local rube = Rube.new(self,self.levelData)

	--------------------------------------------------------------
	-- Claw Particles
	--------------------------------------------------------------

	local clawParticles = ClawParticles.new(self)
	self:addChild(clawParticles)
	self.clawParticles = clawParticles

	--------------------------------------------------------------
	-- Interface
	--------------------------------------------------------------

	local interface = Interface.new(self)
	self.interface = interface
	self.interfaceLayer:addChild(interface)

	--------------------------------------------------------------
	-- Class that controls player movement and scrolling
	--------------------------------------------------------------

	local playerMovement = PlayerMovement.new(self)
	self:addChild(playerMovement)
	self.playerMovement = playerMovement

	-- Hero animation manager

	local heroAnimation = HeroAnimation.new(self)
	self.heroAnimation = heroAnimation
	heroAnimation:updateAnimation()
	
	--------------------------------------------------------------
	-- Add Wind
	--------------------------------------------------------------
	
	if(self.wind) then
	
		-- (scene,minTimeBetween,maxTimeBetween,minDuration,maxDuration)
		local wind = Wind.new(self,4,6,6,10)
		local leaves = Leaves.new(self)
		
	end

	--------------------------------------------------------------
	-- Set up camera
	--------------------------------------------------------------

	local camera = Camera.new(self)
	self:addChild(camera)
	self.camera = camera

	fadeFromBlack()


	collectgarbage()

	if(enableTitleScreen) then
		local tween = GTween.new(self.loadingScreen, .5, {alpha=0})
		Timer.delayedCall(500, function() stage:removeChild(self.loadingScreen) end)
	end

end




function level10:playLevelMusic()

	
	--------------------------------------------------------------
	-- Setup music
	--------------------------------------------------------------

	if(playMusic) then
		levelMusicPlaying = true -- set global variable
		local myMusic = Sound.new("Music/joyful.mp3")
		channel = myMusic:play(0, math.huge)
		channel:setVolume(.3*self.musicVol)
		currentTrack = nil
	end
	
end




function level10:onPause()

	print("************ LEVEL 10 Pause ************")

	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:pause()
	
	end

end




function level10:onResume()

	print("************ LEVEL 10  ************")

	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:resume()
	
	end

end



function level10:onExit()

	print("************ LEVEL 10 EXIT ************")
	
	unrequire("Classes/Ball")
	unrequire("Classes/BallParticles")
	unrequire("Classes/BallSpawner")
	unrequire("Classes/CarryBug") 
	unrequire("Classes/DropSwitch")
	unrequire("Classes/FixedBackground")
	unrequire("Classes/Fruit")
	unrequire("Classes/JellyFish")
	unrequire("Classes/KeyDoor")
	unrequire("Classes/KeyParticles")
	unrequire("Classes/Masher Up Down")
	unrequire("Classes/Pot")
	unrequire("Classes/Pot Smash")
	unrequire("Classes/Rounder Monster")
	unrequire("Classes/TreasureMite")
	unrequire("Classes/TreasureHeap")
	unrequire("Classes/VolumeByDistance")
	unrequire("Classes/WormWraith")
		
	Ball = nil
	BallParticles = nil
	BallSpawner = nil
	CarryBug = nil 
	DropSwitch = nil
	FixedBackground = nil
	Fruit = nil
	JellyFish = nil
	KeyDoor = nil
	KeyParticles = nil
	MasherUpDown = nil
	Pot = nil
	PotSmash = nil
	RounderMonster = nil
	TreasureMite = nil
	TreasureHeap = nil
	VolumeByDistance = nil
	WormWraith = nil
		
	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:exit()
	
	end

	-- unload anything that was required here

	self:removeEventListener("onPause", self.onPause, self)
	self:removeEventListener("onResume", self.onResume, self)
	self:removeEventListener("onExit", self.onExit, self)

	collectgarbage()
	collectgarbage()
	collectgarbage()

end