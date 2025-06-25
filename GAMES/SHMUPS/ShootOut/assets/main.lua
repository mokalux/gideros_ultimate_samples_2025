print("Running")

lives = 3
points = 0                                                                                                                                                                                                                                                                                                                                                            
hiscore = 0
--song_1 = Sound.new("sound/soundtrack/song1.mp3")
quit = false

Game = SceneManager.new({
	["intro"] = Intro,
	["game_over"] = GameOver,
	["level_1"] = Level_1,
	["level_2"] = Level_2,
})

stage:addChild(Game)
Game:changeScene("intro", 1, SceneManager.fade)


--stage:addChild(GameOver.new())