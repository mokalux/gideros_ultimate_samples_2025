--app:setBackgroundColor(0x323232)
local font = TTFont.new("HelveticaNeue.ttf", 12)

function tf(text)
	local t = TextField.new(font, text, "|")
	return t
end

local gr2 = Group.new("test2")
for i = 1, 3 do gr2:addItem(tf("lol"..i)) end

local gr4 = Group.new("test4")
for i = 1, 2 do gr4:addItem(tf("lmao"..i)) end

local btm = Bitmap.new(Texture.new("images.png", true))
btm:setScale(.5)
gr4:addItem(btm)
gr4:addItem(tf("lmao3"))
gr4:addItem(tf("lmao4"))

gr2:addSubGroup(gr4)
gr2:addItem(tf("lol4"))

local gr1 = Group.new("test1")
gr1:addItem(Pixel.new(0xfff000, 1, 100, 20))
gr1:addItem(tf("whatever2"))
gr1:addSubGroup(gr2)
gr1:addItem(tf("whatever3"))

local gr3 = Group.new("test3")
for i = 1, 4 do gr3:addItem(tf("lol"..i)) end

gh = Group.new("Master")
gh:addSubGroup(gr1)
gh:addSubGroup(gr3)	

gh:setPosition(10, 10)
stage:addChild(gh)

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
	local item = gh:queryXY(e.touch.x, e.touch.y)

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