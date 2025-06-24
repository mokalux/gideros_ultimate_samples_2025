--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Ace Snow object creates a falling snowflake effect for your application window.
 * It is possible to set quantity and speed of flakes, and also provide image of custom snowflake. 
 * This object also provides methods to start or stop snowing and add flakes.
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Snow-for-Gideros-Mobile
**************************************************************
]]--
--module("Snow", package.seeall)
Snow = {}

--configuration options
local conf = {
	image = nil,
	fallingTime = 12,
	flakeInterval = 800,
	flakeSize = 20,
	sizeDelta = 5,
	easing = nil,
	fadeOut = true,
	shrink = true,
	rotate = true,
	autoStart = true,
	parent = stage
}

local timer
local parent
local function flake()
	local orientation = stage:getOrientation()
	local screenH, screenW, x, y
	local sprite = Bitmap.new(Texture.new(conf.image))
	local size = math.random(conf.flakeSize - conf.sizeDelta, conf.flakeSize + conf.sizeDelta)
	local ratio = size/sprite:getWidth()
	sprite:setScaleX(ratio)
	sprite:setScaleY(ratio)
	local width = sprite:getWidth()
	local height = sprite:getHeight()

	if orientation == stage.PORTRAIT then
		screenH = application:getDeviceHeight()
		screenW = application:getDeviceWidth()
		x = math.random(0, screenW-width)
		y = -height
	elseif orientation == stage.LANDSCAPE_LEFT then
		screenW = application:getDeviceHeight()
		screenH = application:getDeviceWidth()
		x = -height
		y = math.random(0, screenW-width)
	elseif orientation == stage.LANDSCAPE_RIGHT then
		screenW = application:getDeviceHeight()
		screenH = application:getDeviceWidth()
		x = -height
		y = math.random(0, screenW-width)
	elseif orientation == stage.PORTRAIT_UPSIDE_DOWN then
		screenH = application:getDeviceHeight()
		screenW = application:getDeviceWidth()
		x = math.random(0, screenW-width)
		y = -height
	end
	
	local x = math.random(0, screenW-width)
	local y = -height
	
	sprite:setPosition(x, y)
	conf.parent:addChild(sprite)
	local animate = {}
	animate.y = screenH + height
	animate.x = math.random(0, screenW-width)
	if conf.fadeOut then
		animate.alpha = 0.5
	end
	if conf.shrink then
		animate.scaleX = 0.5
		animate.scaleY = 0.5
	end
	if conf.rotate then
		animate.rotation = math.random(0, 360)
	end
	local tween = GTween.new(sprite, conf.fallingTime/1000, animate, {delay = 0, ease = conf.easing})
	tween:addEventListener("complete", function()
		conf.parent:removeChild(sprite)
		sprite = nil
	end)
	tween.dispatchEvents = true
end

function Snow.init(config)
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			conf[key]= value
		end
	end
	
	timer = Timer.new(conf.flakeInterval)
	
	timer:addEventListener(Event.TIMER, function() 
		flake()
    end)	
	
	if conf.autoStart then
		timer:start()
	end
	
end

function Snow.start()
	timer:start()
end

function Snow.stop()
	timer:stop()
end

function Snow.addFlake()
	flake()
end
