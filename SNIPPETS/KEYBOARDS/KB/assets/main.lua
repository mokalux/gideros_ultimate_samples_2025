--[[

Keyboard example usage

evs 2012

]]

application:setOrientation(Application.LANDSCAPE_LEFT)
application:setBackgroundColor(0x000000)

backgroundTexture = Texture.new("images/backgrounds/KBBG.png")

background = Sprite.new()

background:addChild(Bitmap.new(backgroundTexture))

local kb = Keyboard.new()
local showing = false
local input = ""

local function callback(returnedText)

	print("Typed:", returnedText)	
	kb:clear() -- clear text
	showing = false

end

function backgroundClick(event) 

	if background:hitTestPoint(event.touches[1].x, event.touches[1].y) then 

		if not showing then 
			
			kb:clear() -- clear text
			kb:show(callback) -- callback function
			showing = true
			
		end
		
	end
	
end

background:addEventListener(Event.TOUCHES_BEGIN, backgroundClick)

stage:addChild(background)
stage:addChild(kb)

