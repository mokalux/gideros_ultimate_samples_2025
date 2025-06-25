level5 = Core.class(Sprite)

function level5:init()

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


function level5:fadeTheme()

	channel:setVolume(channel:getVolume()-.01)
	if(channel:getVolume()<0) then
		channel:setPaused(true)
		self:removeEventListener(Event.ENTER_FRAME, self.fadeTheme, self)
		self:playLevelMusic()
	end
	
end

function level5:setup()

	-- Test mode (Show physics bodies) 
	-- Note - hero wont be on correct layer...

	--self.showBodies = true
	self.showImages = true

	-- Show loot as we collect it
	--self.showLootCollected = true
	
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

	--require("Classes/Masher Left Right")
	--require("Classes/Masher Up Down")
	--require("Classes/Rounder Monster")
	--require("Classes/Spinner")
	--require("Classes/Acid Fish")
	require("Classes/Ball")
	require("Classes/BallParticles")
	require("Classes/BallPressurePlate")
	require("Classes/BallSpawner")
	require("Classes/CarryBug")
	--require("Classes/DragBlock")
	--require("Classes/DragBlockDoor") 
	--require("Classes/DragBlockButton")
	--require("Classes/EyeMiniGame")
	require("Classes/FollowBug")
	require("Classes/FlyingWraith")
	--require("Classes/PluckEye")
	--require("Classes/Pot")
	--require("Classes/Pot Smash")
	--require("Classes/Saw")
	require("Classes/Spike")
	--require("Classes/Thwomper")
	--require("Classes/TongueDoor")
	--require("Classes/TreasureMite")
	require("Classes/VolumeByDistance")
	require("Classes/WalkingChest")
	require("Classes/WalkingChestParticles")
	require("Classes/WormWraith")

	-- Bring in atlases
	
	unloadAtlas(9)
	
	loadAtlas(11,"Atlas 11")


	self.atlas = {}
	self.atlas[2] = atlasHolder[2]
	self.atlas[11] = atlasHolder[11]

	self:addEventListener(Event.ENTER_FRAME, self.fadeTheme, self)
	
	-- Set the scenery shape texture

	self.shapeTexture = Texture.new("Shape Textures/brick 1.png", true, {wrap = Texture.REPEAT})

	-- Create anim loaders

	local animLoader = CTNTAnimatorLoader.new()
	animLoader:loadAnimations("Animations/Atlas 2 Animations.tan", self.atlas[2], true)
	self.atlas2AnimLoader = animLoader



	--self:removeChild(loading)
	--loading = nil;
	--self:removeEventListener(Event.ENTER_FRAME, preloader)


	--------------------------------------------------------------
	-- Setup - different for each level
	--------------------------------------------------------------

	self.showHitBoxes = true -- show non box 2d hit boxes

	self.levelNumber = 5
	self.worldNumber = 1

	-- Set up targets for this level

	self.lootBronzeTarget = 1000

	self.lootSilverTarget = 1200

	self.lootGoldTarget = 1800

	self.coinValue = 10

	self.minutesLeft = 2
	self.secondsLeft = 25


	-- World width and height (get from Rube - 1 square = 100 pixels
	self.worldWidth = 3500
	self.worldHeight = 1400

	self.levelData = "Level Data/Level 5 Data.lua"

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

	-- Rube images in front of hero
	local rube2 = Sprite.new()
	self:addChild(rube2)
	self.rube2 = rube2

	local clawLayer = Sprite.new()
	self:addChild(clawLayer)
	self.clawLayer = clawLayer;

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

	local bg = Background.new(self,"Backgrounds/bg5 background.png",self.worldWidth,self.worldHeight,"Backgrounds/bg5 foreground.png",self.worldWidth,self.worldHeight)

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

	self.clawParticles = ClawParticles.new(self)








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




function level5:playLevelMusic()

	--------------------------------------------------------------
	-- Setup music
	--------------------------------------------------------------

	if(playMusic) then
		levelMusicPlaying = true -- set global variable
		local myMusic = Sound.new("Music/fairy-tale.mp3");
		channel = myMusic:play(0, math.huge)
		channel:setVolume(.8*self.musicVol)
		currentTrack = nil
	end
	
end




function level5:onPause()

	print("************ LEVEL 5 Pause ************")

	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:pause()
	
	end

end




function level5:onResume()

	print("************ LEVEL 5  ************")

	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:resume()
	
	end

end



function level5:onExit()

	print("************ LEVEL 5 EXIT ************")
	
	for i,v in pairs(self.pauseResumeExitSprites) do
	
		v:exit()
	
	end

	-- unload anything that was required here
	
	
	unrequire("Classes/Ball")
	unrequire("Classes/BallParticles")
	unrequire("Classes/BallPressurePlate")
	unrequire("Classes/BallSpawner")
	unrequire("Classes/CarryBug")
	unrequire("Classes/FollowBug")
	unrequire("Classes/FlyingWraith")
	unrequire("Classes/Spike")
	unrequire("Classes/VolumeByDistance")
	unrequire("Classes/WalkingChest")
	unrequire("Classes/WalkingChestParticles")
	unrequire("Classes/WormWraith")
	
	
	Ball = nil
	BallParticles = nil
	BallPressurePlate = nil
	BallSpawner = nil
	CarryBug = nil
	FollowBug = nil
	FlyingWraith = nil
	Spike = nil
	VolumeByDistance = nil
	WalkingChest = nil
	WalkingChestParticles = nil
	WormWraith = nil

	self:removeEventListener("onPause", self.onPause, self)
	self:removeEventListener("onResume", self.onResume, self)
	self:removeEventListener("onExit", self.onExit, self)

	collectgarbage()
	collectgarbage()
	collectgarbage()

end