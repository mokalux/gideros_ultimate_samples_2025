application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)
application:setBackgroundColor(0xFFFFFF)

local function draw_loading()
	loading = Sprite.new()
	
	local logo = Bitmap.new(Texture.new("images/jdbc_games.png", true))
	logo:setY(200)
	loading:addChild(logo)
	
--	local font =  TTFont.new("fonts/crashlandinGBB.ttf", 70)
	local text = TextField.new(nil, "loading")
	local posX = (application:getContentWidth() - text:getWidth()) * 0.5
	text:setPosition(posX, 500)
	--text:setTextColor(0x00ff11)
	--text:setShadow(2, 1, 0x000000)
	--loading.text = text
	loading:addChild(text)
	
	stage:addChild(loading)
end

-- Loading textures and sounds when game is starting
local function preloader()
	stage:removeEventListener(Event.ENTER_FRAME, preloader)
	
	-- Remove loading scene
	stage:removeChild(loading)
	loading = nil
	
	scenes = {"menu", "game"}
	sceneManager = SceneManager.new({
		["menu"] = MenuScene,
		["game"] = GameScene
		})
	stage:addChild(sceneManager)
	sceneManager:changeScene(scenes[2])
end

draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)