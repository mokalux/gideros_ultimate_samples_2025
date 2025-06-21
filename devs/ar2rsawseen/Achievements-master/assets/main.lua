--lock orientation that you need
stage:setOrientation(Stage.LANDSCAPE_LEFT)
application:setKeepAwake(true)

--create achievements object for specific player
ach = Achievements.new("player1")
-- and set notification for achievement
ach:addEventListener("complete", function(e)
	Notifications.new("Achievement earned", e.name, 3000)
end)

--save achievements on exit
stage:addEventListener(Event.APPLICATION_SUSPEND, function()
	ach:save()
end)
stage:addEventListener(Event.APPLICATION_EXIT, function()
	ach:save()
end)

--check time for time achievement
local temp = os.date("*t")
if temp["hour"] >= 1 and temp["hour"] <= 7 then
	ach:complete("nosleep")
end
temp = nil

--define scenes
sceneManager = SceneManager.new({
	["startScene"] = startScene,
	["achievementsScene"] = achievementsScene
})

--add manager to stage
stage:addChild(sceneManager)

--start startScene
sceneManager:changeScene("startScene", 1, SceneManager.fade, nil)
