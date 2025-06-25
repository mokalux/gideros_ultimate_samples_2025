-- set the background to black (the number is a hexadecimal RRGGBB colour value)
application:setBackgroundColor(0x000000)

-- setup so lots of common functions are local and easy to use
local sub,len,upper,lower,format,gsub,find,rep,ascii=string.sub,string.len,string.upper,string.lower,string.format,string.gsub,string.find,string.rep,string.byte
local random,floor,sin,cos,tan,abs,atan2,sqrt=math.random,math.floor,math.sin,math.cos,math.tan,math.abs,math.atan2,math.sqrt
local remove,insert=table.remove,table.insert

-- include support for easing functions, the scene manager and joypad controllers
require "easing"
require "scenemanager"
pcall(function() require "controller" end)

local frameRate=application:getFps()
local frameCounter,skip,oldFps,oldTextureUsage=0,0,0,0
local fudlr,oldFudlr,debouncedFudlr=0,0,0 -- fire, up, down, left, right
local paused=false

local backgroundCount,oldBackgroundCount=0,0

local attractMode=1
local music,soundfx=true,true
--local level=1
level=1

local sprites={}
sprites[1]={x=0,y=0,sprite=Pixel.new(0xff4090,0.95,10,10)} -- create a pink 95% transparent 10x10 pixel sprite

-- add my sprite to the screen
stage:addChild(sprites[1].sprite)

-- this function will be called every game frame
function gameLoop(e)
	-- e is a table that holds nice event information

	-- *** first some housekeeping! ***

	-- make sure garbage is collected regularly, but not too much in one
	collectgarbage("step")
	--print(collectgarbage("count")*1024)
	
	-- if texture usage has changed then display new texture usage
	local temp=(application:getTextureMemoryUsage()/1024)
	if temp~=oldTextureUsage then
		oldTextureUsage=temp
		print("Texture usage: "..temp.."MB")
	end

	-- if old FPS is different from the current one by 10 frames then display new FPS
    local temp=(1//e.deltaTime)
	if abs(temp-oldFps)>10 then
		oldFps=temp
--		print("FPS: "..temp)
	end
	
	-- skip is a variable you can use to even things out of your game isn't running exactly on sync
	skip=e.deltaTime*frameRate
	
	-- frameCounter is added to each frame
	frameCounter+=skip
	
	-- *** here you can put code that is used for your main game ***
	
	-- check 'attractMode', if -1 then game over, if 0 then in game, if 1 then self play demo mode
	
	if backgroundCount~=oldBackgroundCount then
		oldBackgroundCount=backgroundCount
		print("background count: "..backgroundCount)
	end
	
	local s=sprites[1]  -- s now is pointing to sprites[1], my first sprite
	
	-- move the x across the screen, move the y in a sine wave pattern
	s.x+=5*skip
	if s.x>320 then s.x=0 end
	s.y=240+(sin(frameCounter/30)*200)
	
	s.sprite:setPosition(s.x,s.y) -- update the actual sprite position
	
end

-- this function runs continuously unless you exit it
function task()
	while true do
		if not paused then
			backgroundCount+=1
			-- you can optionally give up the task processing time, eg to not execute for 10 seconds use 'Core.yield(10)', etc
			Core.yield(10)
		end
	end
end

-- handy functions for controlling menus and joypads
function addMenu(s,text,offset,funct)
	if s.menu==nil then s.menu={} end
	local i={}
	i.sprite=TextField.new(nil,text)
	i.sprite:setTextColor(0xffffff)
	i.sprite:setScale(3)
	i.sprite:setAnchorPoint(0.5,0.5)
	i.sprite:setPosition(160,offset+(#s.menu*40))
	i.funct=funct
	s:addChild(i.sprite)
	s.menu[#s.menu+1]=i
end

function setMenu(s,item,text)
	local i=s.menu[item]
	i.sprite:setText(text)
	i.sprite:setAnchorPoint(0.5,0.5)
end

function onOff(f)
	if f then return "On" else return "Off" end
end

function selectMenu(s,item)
	if item~=s.item then
		s.item=item
		for loop=1,#s.menu do
			if loop==item then
				s.menu[loop].sprite:setColorTransform(1,0.7,0)
			else
				s.menu[loop].sprite:setColorTransform(0,0.2,1)
			end	
		end
	end
end

function processMenu(s)
	if debouncedFudlr~=0 then
		local item=s.item
		if debouncedFudlr&0b01000~=0 then item-=1 end
		if debouncedFudlr&0b00100~=0 then item+=1 end
		if item<1 then item+=#s.menu elseif item>#s.menu then item-=#s.menu end
		selectMenu(s,item)
		if debouncedFudlr&0b10000~=0 and s.menu[item].funct then s.menu[item].funct(s) end
	end
end

function processMouse(s,e)
	for loop=1,#s.menu do
		if s.menu[loop].sprite:hitTestPoint(e.x,e.y,true) then
			selectMenu(s,loop)
			if e.type=="mouseUp" and s.menu[loop].funct then s.menu[loop].funct(s) end
		end
	end
end

function processPads()
	debouncedFudlr=fudlr&(~oldFudlr)
	oldFudlr=fudlr
end

-- *** scenemanager ***
sceneManager = SceneManager.new({
	["frontend"]=Frontend,
	["play"]=Play,
	["options"]=Options,
	["gameover"]=GameOver,
})

transitions = {
	SceneManager.moveFromLeft,
	SceneManager.moveFromRight,
	SceneManager.moveFromBottom,
	SceneManager.moveFromTop,
	SceneManager.moveFromLeftWithFade,
	SceneManager.moveFromRightWithFade,
	SceneManager.moveFromBottomWithFade,
	SceneManager.moveFromTopWithFade,
	SceneManager.overFromLeft,
	SceneManager.overFromRight,
	SceneManager.overFromBottom,
	SceneManager.overFromTop,
	SceneManager.overFromLeftWithFade,
	SceneManager.overFromRightWithFade,
	SceneManager.overFromBottomWithFade,
	SceneManager.overFromTopWithFade,
	SceneManager.fade,
	SceneManager.crossFade,
	SceneManager.flip,
	SceneManager.flipWithFade,
	SceneManager.flipWithShade,
}
stage:addChild(sceneManager)

-- *** joypad controller support ***
if controller then
	controller:addEventListener(Event.KEY_DOWN, function(e)
		--print("Button Down ", e.keyCode)
		local k=e.keyCode
		if k==KeyCode.BUTTON_BACK then back=true 
		elseif k==KeyCode.BUTTON_B or k==KeyCode.BUTTON_A then fudlr=fudlr|0b10000
		elseif k==KeyCode.DPAD_UP then fudlr=fudlr|0b01000
		elseif k==KeyCode.DPAD_DOWN then fudlr=fudlr|0b00100
		elseif k==KeyCode.DPAD_LEFT then fudlr=fudlr|0b00010
		elseif k==KeyCode.DPAD_RIGHT then fudlr=fudlr|0b00001
		end
	end)

	controller:addEventListener(Event.KEY_UP, function(e)
		local k=e.keyCode
		if k==KeyCode.BUTTON_B or k==KeyCode.BUTTON_A then fudlr=fudlr&0b01111
		elseif k==KeyCode.DPAD_UP then fudlr=fudlr&0b10111
		elseif k==KeyCode.DPAD_DOWN then fudlr=fudlr&0b11011
		elseif k==KeyCode.DPAD_LEFT then fudlr=fudlr&0b11101
		elseif k==KeyCode.DPAD_RIGHT then fudlr=fudlr&0b11110
		end
	end)

	controller:addEventListener(Event.RIGHT_JOYSTICK, function(e)
		--print("Player: ",e.playerId)
		--print("RIGHT_JOYSTICK:", "x:"..e.x, "y:"..e.y, "angle:"..e.angle, "strength:"..e.strength)
	end)

	controller:addEventListener(Event.LEFT_JOYSTICK, function(e)
		--print("Player: ",e.playerId)
		--print("LEFT_JOYSTICK:", "x:"..e.x, "y:"..e.y, "angle:"..e.angle, "strength:"..e.strength)
	end)

	controller:addEventListener(Event.RIGHT_TRIGGER, function(e)
	--	print("Player: ",e.playerId)
	--	print("RIGHT_TRIGGER:", "strength:"..e.strength)
	end)

	controller:addEventListener(Event.LEFT_TRIGGER, function(e)
	--	print("Player: ",e.playerId)
	--	print("LEFT_TRIGGER:", "strength:"..e.strength)
	end)

	controller:addEventListener(Event.CONNECTED, function(e)
	end)

	controller:addEventListener(Event.DISCONNECTED, function(e)
	end)
end

-- *** keyboard support ***
stage:addEventListener(Event.KEY_DOWN,function(e)
	local k=e.keyCode
	if k==KeyCode.BACK or k==KeyCode.ESC then back=true
	elseif k==KeyCode.SPACE or k==KeyCode.ENTER then fudlr=fudlr|0b10000
	elseif k==KeyCode.UP then fudlr=fudlr|0b01000
	elseif k==KeyCode.DOWN then fudlr=fudlr|0b00100
	elseif k==KeyCode.LEFT then fudlr=fudlr|0b00010
	elseif k==KeyCode.RIGHT then fudlr=fudlr|0b00001
	end
end)

stage:addEventListener(Event.KEY_UP,function(e)
	local k=e.keyCode
	if k==KeyCode.SPACE or k==KeyCode.ENTER then fudlr=fudlr&0b01111
	elseif k==KeyCode.UP then fudlr=fudlr&0b10111
	elseif k==KeyCode.DOWN then fudlr=fudlr&0b11011
	elseif k==KeyCode.LEFT then fudlr=fudlr&0b11101
	elseif k==KeyCode.RIGHT then fudlr=fudlr&0b11110
	end
end)

stage:addEventListener(Event.ENTER_FRAME,gameLoop)

-- take over automatic garbage collection, do it in small steps. Increase/decrease the amount depending on your game.
collectgarbage("setstepmul",1000)
collectgarbage()

-- start the first initial 'scene'
sceneManager:changeScene("frontend")

-- a task can be used to run a non-event driven type of game
Core.asyncCall(task) -- comment this out if you don't want to write your game in task()
