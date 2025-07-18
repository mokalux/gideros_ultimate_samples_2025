local counter = 0
local function countdown() counter = counter - 1 end
local function countup() counter = counter + 1 end

local elements = {}
for name in ("\n"..splashscreenDesc):gmatch"\n(.-%.png)" do
	local texture = splashscreenPack:getTextureRegion(name)
	elements[#elements+1] = Layout.new{
		Bitmap.new(texture),
		anAdd = {
			frames = math.random(20, 40),
			anchorX = math.sqrt,
			rotation = math.log,
		},
		anRemove = {
			frames = math.random(20, 40),
			scaleX = math.sin,
			rotation = math.tan,
			alpha = -1,
		},
		onAdd = countup,
		onRemove = countdown
	}
end

local l = #elements
local removing = false

local examples = Layout.newResources{
	path = "|R|examples",
	namemod = function(name, path, base, ext, i) return base end
}

local function onPress(self)
	if counter == 0 then
		for i,element in ipairs(elements) do
			self:addChild(element)
		end
		removing = false
	elseif counter == l and not removing then
		for i,element in ipairs(elements) do
			element:removeFromParent()
		end
		removing = true
		
		for _,child in pairs(stage.__children) do
			child:removeFromParent()
		end
		
		examples["mainmenu"]()
	end
end

local layout = Layout.new{
	anAdd = Layout.newAnimation(),
	anRemove = Layout.newAnimation(),
	onPress = onPress,
}

onPress(layout)

stage:addChild(layout)
