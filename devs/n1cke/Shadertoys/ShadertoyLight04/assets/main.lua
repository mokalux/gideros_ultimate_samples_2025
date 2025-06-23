local textheight = 28

local json = require "json"

local texs = {}
for i = 0, 20 do
	if i ~= 13 and i ~= 19 then
		local filename = "_presets/tex"..string.format("%02d", i)..((10 <= i and i <= 16) and ".png" or ".jpg")
--		texs["/"..filename] = Texture.new(filename, true, {wrap = Texture.REPEAT})
		texs[filename] = Texture.new(filename, true, {wrap = Texture.REPEAT})
	end
end

local font = TTFont.new("Istok Italic.ttf", textheight)

local note = "[Left]/[Right]: navigation,\n[Space]: open page,\n[Mouse]: interaction"
local textfield = TextField.new(font, note, "Pq|")
local rectangle = Pixel.new(0xFFFFFF, 0.5, 0, 0)
rectangle:addChild(textfield)
rectangle:addEventListener(Event.ENTER_FRAME, function()
	local alpha = rectangle:getAlpha()
	if alpha > 0.5 then rectangle:setAlpha(alpha ^ 1.05) end
end)
stage:addChild(rectangle)

local n = #keys

local function testShader(n)
	for i, child in pairs(stage.__children or {}) do
		if child.setTextureSlot then child:removeFromParent() end
	end
	collectgarbage()
	
	local file = io.open("shaders/"..keys[n])
	local data = file:read"*a"
	file:close()

	local info = json.decode(data)["Shader"]
	
	if #info.renderpass > 1 then return false end
	
	local code = info.renderpass[1].code
	
	local t = {}
	for i,input in pairs(info.renderpass[1].inputs) do
		if input.ctype == "texture" then t[i] = texs[input.src] end
	end

	local w, h = application:getDeviceWidth(), application:getDeviceHeight()
	local ok, image = pcall(Shadertoy.new, {code}, w, h, t[1], t[2], t[3], t[4])
	if ok then stage:addChild(image) else return false end
	
	textfield:setText("["..keys[n].."]\n"..info.info.name.."\nby "..info.info.username)
	rectangle:setAlpha(0.999)
	rectangle:setDimensions(w, textheight*3.5)
	stage:addChild(rectangle)
	
	return image
end

local url = "https://www.shadertoy.com/view/"

stage:addEventListener(Event.KEY_DOWN, function(e)
	if e.keyCode == 32 then return application:openUrl(url..keys[n]) end
	while true do
		if e.keyCode == 37 then n = n - 1
		elseif e.keyCode == 39 then n = n + 1 end
		if n < 1 then n = #keys elseif n > #keys then n = 1 end
		if testShader(n) then break end
	end
end)
