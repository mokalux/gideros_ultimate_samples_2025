local screens = {}
local currentScreenName = nil

function addScreen(screen)
	screens[screen.name] = screen
	if not screens[screen.name].stage then
		screens[screen.name].stage = Sprite.new()
	end
end

function changeScreen(screenName)
	if screens[currentScreenName] then
		if screens[currentScreenName].destroy then
			screens[currentScreenName].destroy()
		end
		if screens[currentScreenName].stage then
			stage:removeChild(screens[currentScreenName].stage)
		end
	end
	if screens[screenName].init then
		screens[screenName].init()
	end
	if screens[screenName].stage then
		stage:addChild(screens[screenName].stage)
	end
	currentScreenName = screenName
end

function updateScreens(e)
	if screens[currentScreenName].update then
		screens[currentScreenName].update(e)
	end
end

function screenTouch(touch)
	if screens[currentScreenName].onTouch then
		screens[currentScreenName].onTouch(touch)
	end
end

function screenKey(event)
	if screens[currentScreenName].onKey then
		screens[currentScreenName].onKey(event)
	end
end

stage:addEventListener(Event.ENTER_FRAME, updateScreens)
stage:addEventListener(Event.TOUCHES_BEGIN, screenTouch)
stage:addEventListener(Event.KEY_DOWN, screenKey)