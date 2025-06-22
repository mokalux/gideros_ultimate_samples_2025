require "scenemanager"
require "easing"

application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)
application:setBackgroundColor(0xffffff)

local iOS = application:getDeviceInfo() == "iOS"
local android = application:getDeviceInfo() == "Android"

-- Loading function
local function draw_loading()
	loading = Sprite.new()
	local font = TTFont.new("fonts/firstfun.ttf", 50)
	local text = TextField.new(font, "Loading")
	local posX = (application:getLogicalWidth() - text:getWidth()) * 0.5
	text:setPosition(posX, 280)
	text:setTextColor(0x0000ff)
	loading.text = text
	loading:addChild(text)
	stage:addChild(loading)
end

local function preloader() 	
	stage:removeEventListener(Event.ENTER_FRAME, preloader)
	-- Load all your assets here
	MenuScene.setup()
	GameScene.setup()
	-- List of scenes
	local scenes = {"menu", "game"}
	local sceneManager = SceneManager.new({
		["menu"] = MenuScene,
		["game"] = GameScene
	})
	stage:addChild(sceneManager)
	
	-- MenuScene is the first scene to show
	local currentScene = scenes[1]

	local timer = Timer.new(2000, 1)
	timer:addEventListener(Event.TIMER, function()
		-- Remove loading scene
		stage:removeChild(loading)
		loading = nil
		sceneManager:changeScene(currentScene)
	end)
	timer:start()
end

draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)
