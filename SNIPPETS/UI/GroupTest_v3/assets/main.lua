--app:setBackgroundColor(0x323232)
local font = TTFont.new("HelveticaNeue.ttf", 24)

function tf(text)
	local t = TextField.new(font, text, "|")
	return t
end

local btm = Bitmap.new(Texture.new("images.png", true))
btm:setScale(.5)
local px = Pixel.new(0xfff000, 1, 100, 20)

local master = Group.new("Master")
master:load{
	"test1", {
		px, 
		tf("whatever2"), 
		"test2", {
			tf("lol1"),
			tf("lol2"),
			tf("lol3"),
			"test4", {
				tf("lmao1"),
				tf("lmao2"),
				btm, 
				tf("lmao3"),
				tf("lmao4"),
			},
			tf("lol4"),
		},
		tf("whatever3"), 
	},
	"test3", {
		tf("lol1"),
		tf("lol2"),
		tf("lol3"),
		tf("lol4"),
	}
}
master:setPosition(10, 10)
stage:addChild(master)

local test = master:queryName("test4")
print(test.name)

local selected = nil
local dir = -1
local flashTimer = Timer.new(100, 12)
flashTimer:addEventListener(Event.TIMER, function()
	if (selected) then 
		local al = selected:getAlpha()
		selected:setAlpha(al + dir * 1)
		dir *= -1
	end
end)

stage:addEventListener(Event.TOUCHES_BEGIN, function(e)
	local item = master:queryXY(e.touch.x, e.touch.y)

	if (item) then 
		if (item.isGroup) then 
			item:switch()
		elseif (item.isItem) then
			if (selected) then selected:setAlpha(1) end
			dir = -1
			selected = item
			flashTimer:reset()
			flashTimer:start()
		end
	end
end)
