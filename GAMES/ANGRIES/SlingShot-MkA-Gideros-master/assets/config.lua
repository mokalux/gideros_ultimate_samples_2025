--!NEEDS:classes/dataSaver.lua
--!NEEDS:classes/easing.lua
--!NEEDS:classes/json.lua

conf = {
	transition = SceneManager.fade,
	transitionTime = 1,
	easing = easing.outBack,
	textureFilter = true,
	width = application:getContentWidth(),
	height = application:getContentHeight(),
	dx = application:getLogicalTranslateX() / application:getLogicalScaleX(),
	dy = application:getLogicalTranslateY() / application:getLogicalScaleY(),
	score = 0,
	yscore = 0,
	highscore = dataSaver.loadValue("prehighscore"),
	fonthard = TTFont.new("PixelFont.TTF",32, true),
	fonteasy = TTFont.new("Boxy-Bold.ttf",32,true),
	handpull,
	main2ball,
	adcount = 0;
}