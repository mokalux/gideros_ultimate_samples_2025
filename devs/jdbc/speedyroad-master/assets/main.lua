application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

local width = application:getContentWidth()
local height = application:getContentHeight()

local function draw_loading()
	loading = Sprite.new()
	
	local logo = Bitmap.new(Texture.new("gfx/jdbc_games.png", true))
	logo:setScale(0.67)
	logo:setY(150)
	loading:addChild(logo)	
	
	--[[
	local gideros = Bitmap.new(Texture.new("gfx/gideros_studio_160x160.png", true))
	gideros:setScale(0.5)
	gideros:setPosition(200, 300)
	loading:addChild(gideros)
	]]--
	
	stage:addChild(loading)
end

local function preloader()
 	
	stage:removeEventListener(Event.ENTER_FRAME, preloader)
	
	-- Load all your assets here
	GameScene.setup()
	Block.setup()
	Player.setup()
	Vehicle.setup()
	Hud.setup()
	SoundManager.setup()
	Score.setup()
	--ChooseScene.setup()
	Advertise.setup()
	
	-- Game starting
	--scenes = {"menu", "choose", "game", "score"}
	scenes = {"game", "choose"}

	sceneManager = SceneManager.new({
		["game"] = GameScene,
		["choose"] = ChooseScene
	})

	stage:addChild(sceneManager)
	
	local currentScene = scenes[1]
	
	local timer = Timer.new(1000, 1)
	timer:addEventListener(Event.TIMER, function()
		-- Remove loading scene
		stage:removeChild(loading)
		loading = nil
		sceneManager:changeScene(currentScene)
	end)
	timer:start()
end

gamestate = GameState.new()
draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)
