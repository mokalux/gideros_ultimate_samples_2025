--require "ads"
require "box2d"
--pub = Ads.new("admob")
--pub:setKey("ca-app-pub-2621555016326746/5206773511")
--pub:showAd("auto")
--pub:setAlignment("center", "top")
--admob = Ads.new("admob")
--admob:setKey("ca-app-pub-2621555016326746/8303816315")
--admob:loadAd("interstitial")
sounds = Sounds.new()
if(conf.highscore == 0 or conf.highscore == nil) then
	dataSaver.saveValue("prehighscore", 0)
	conf.highscore = dataSaver.loadValue("prehighscore")
end
sounds:add("lost", "BS2.wav")
sounds:add("click", "menu.wav")
sounds:add("ghost", "ghst.wav")
sounds:add("highscore", "highscore.wav")
sounds:add("hit", "1.wav")

sceneManager = SceneManager.new({
	--level scene
	["start"] = StartScene,
	["tut"] = TutorialScene,
	["level"] = LevelScene,
	["end"] = EndScene,
	["splash"] = SplashartScene,
})
--add manager to stage
stage:addChild(sceneManager)

--go to start scene
sceneManager:changeScene("splash", conf.transitionTime, conf.transition, conf.easing)
