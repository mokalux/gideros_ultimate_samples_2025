-- the app settings
local configfilepath = "gideros_transitions_easings.txt"
if application:getDeviceInfo() == "Windows" and not application:isPlayerMode() then
	application:set("windowTitle", "Gideros Transitions & Easings")
	local winposx = 1920 - 1.75 * myappwidth 
	local winposy = 64
	application:set("windowPosition", winposx, winposy)
end
-- load prefs
local function myLoadPrefs()
	local mydata = getData(configfilepath) -- try to read information from file
	if not mydata then -- if no prefs file, create it
		mydata = {}
		mydata.mytransition = mytransition
		mydata.myeasing = myeasing
		mydata.mytimer = mytimer
		saveData(configfilepath, mydata) -- create file and save datas
	else
		mytransition = mydata.mytransition
		myeasing = mydata.myeasing
		mytimer = mydata.mytimer
	end
end
-- save prefs
function mySavePrefs()
	local mydata = {} -- clear the table
	mydata.mytransition = mytransition
	mydata.myeasing = myeasing
	mydata.mytimer = mytimer
	saveData(configfilepath, mydata) -- save new datas
end
-- let's go
myLoadPrefs()
scenemanager = SceneManager.new(
	{
		["scene1"] = Scene1,
		["scene2"] = Scene2,
	}
)
stage:addChild(scenemanager)

--function SceneManager:changeScene(scene, duration, transition, ease)
scenemanager:changeScene("scene1")
