--- Const
cConst = Core.class()

-- Init
function cConst:init()
	-- Project name
	self.PROJECT_NAME = "DASHING BALL"

	-- XXX
	local myappleft, myapptop, myappright, myappbot = application:getLogicalBounds()
	local myappwidth, myappheight = myappright - myappleft, myappbot - myapptop
--	print("app left", myappleft, "app top", myapptop, "app right", myappright, "app bot", myappbot)
--	print("app width", myappwidth, "app height", myappheight)

	-- Get size screen, content area
--	self.W_DEVICE = application:getDeviceWidth()
--	self.H_DEVICE = application:getDeviceHeight()
	self.W_DEVICE = myappwidth
	self.H_DEVICE = myappheight

--	self.W = application:getContentWidth()
--	self.H = application:getContentHeight()
	self.W = myappwidth
	self.H = myappheight

	-- Center
--	self.W_CENTER = application:getContentWidth() / 2
--	self.H_CENTER = application:getContentHeight() / 2
	self.W_CENTER = myappwidth / 2
	self.H_CENTER = myappheight / 2
	
	-- Absolute values
--	local _dx = application:getLogicalTranslateX() / application:getLogicalScaleX()
--	local _dy = application:getLogicalTranslateY() / application:getLogicalScaleY()
	
--	self.DEVICE_LEFT = -_dx
--	self.DEVICE_RIGHT = _dx + application:getContentWidth()
--	self.DEVICE_TOP = -_dy
--	self.DEVICE_BOTTOM = _dy + application:getContentHeight()
	self.DEVICE_LEFT = myappleft
	self.DEVICE_RIGHT = myappright
	self.DEVICE_TOP = myapptop
	self.DEVICE_BOTTOM = myappbot
	
--	self.DEVICE_W = _dx * 2 + application:getContentWidth()
--	self.DEVICE_H = _dy * 2 + application:getContentHeight()
	self.DEVICE_W = myappwidth
	self.DEVICE_H = myappheight

	self.FPS = application:getFps()
	-- BG
	self.BG_COLOR = 0x00007f -- 0xff0000

	-- Settings
	self.SETTINGS = 'SETTINGS'

	-- Text
	self.TEXT_COLOR = 0xFFFFFF
	self.TITLE_COLOR = 0xe86b17
	
	-- Colors
	self.PARTICLE_COIN_COLOR = 0xf07800
	self.PARTICLE_PLAYER_COLOR = 0x335fe6

	-- Fonts
	self.FONT_NAME = "fonts/Galada.ttf"
	
	-- Position (range)
--	self.RANGE_TOP = 	-application:getContentHeight() / 2 + 137
--	self.RANGE_BOTTOM =  application:getContentHeight() / 2 - 137
--	self.RANGE_LEFT = 	-application:getContentWidth() / 2 + 120
--	self.RANGE_RIGHT =	 application:getContentWidth() / 2 - 120
	self.RANGE_TOP = 	-myappheight / 2 + 137
	self.RANGE_BOTTOM =  myappheight / 2 - 137
	self.RANGE_LEFT = 	-myappwidth / 2 + 120
	self.RANGE_RIGHT =	 myappwidth / 2 - 120
	
	--- --- --- Resource name
	self.RESOURCE_NAME = {
		Game = {
			Wall = 			"game/wall.png",
			Coin = 			"game/coin.png",
			Player = 		"game/player.png",
			BreakTriangle = "game/break_triangle.png",
			BreakStar = 	"game/break_start.png",
			BreakSquare = 	"game/break_square.png",
			BreakPentagon = "game/break_pentagon.png",
			BreakCirle = 	"game/break_circle.png" 
		},
		UI = {
			BtnUpSmall = 	"ui/button_up_small.png",
			BtnDownSmall = 	"ui/button_down_small.png",
			BtnPauseHover = "ui/btn_pause_hover.png",
			BtnPauseOver = 	"ui/btn_pause_over.png"
		}
	}

	-- Scene name
	self.SCENES_NAME = {
		GAME = "GameScene",
		TEST = "SceneTest",
		MAINMENU = "MainMenuScene"
	}

	-- Scene name UI
	self.SCENES_UI_NAME = {
		START = "START",
		GAME = "GAME",
		GAMEOVER = "GAMEOVER",
		PAUSE = "PAUSE"
	}
	
	self.GAME_STATE = {
		START = 0,
		GAME = 1,
		PAUSE = 2,
		GAMEOVER = 3
	}
	
	self.BREAK_TYPE = {
		TRIANGLE = 	0,
		STAR	 = 	1,
		SQUARE 	 = 	2,
		PENTAGON = 	3,
		CIRCLE 	 = 	4
	}
	
	self.PHYSICS_FILTER = {
		WALL = 1,
		BREAK = 2,
		PLAYER = 3,
		COIN = 4
	}
	
	self.SAVE_TAG_HS = "high_score"
end
