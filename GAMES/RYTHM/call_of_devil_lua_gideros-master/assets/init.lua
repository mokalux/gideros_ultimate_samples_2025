local W, H = application:getContentWidth(), application:getContentHeight()

conf = {

	HEIGHT              = H,
    WIDTH               = W,
	MID_WIDTH 			= W/2,
	MID_HEIGHT			= H/2,
    TRANSITION_TIME     = 1,
	DEBUG 				= false,
	FONT_SIZE 			= H / 8,
	SCORE_FONT_COLOR_HEX = 0xff0000,  -- red
	
	SOUND_ON_OFF_SCALE  = 0.15 * W,
	ROUND_TIME 			= 2 * 60, -- 2 minutes
	
	MOON_SCALE 			= 1,
	DEVIL_SPEED_FRAME 	= 20,
	
	DEVIL_SPEED 		= 1,
	
	BUTTON_GITHUB_SCALE = W/5,
	MENU_BUTTON_BOTTOM_OFFSET = H / 6,
	
	PLAY_BUTTON_SCALE 	= H / 4,
	
	ITEM_SCALE 			= 2,
	
	SPEED_ITEM_FRAME 	= 20,
	
	RAIN_SCALE 			= 1.2,
	SPEED_RAIN_FRAME 	= 10,
	
	ANDROID_PACKAGE_NAME = "org.arone.call_of_devil",
	GITHUB_REPOSITORY 	 = "call_of_devil_lua_gideros"

}