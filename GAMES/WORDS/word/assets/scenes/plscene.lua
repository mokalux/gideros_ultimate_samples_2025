-- ======================================================
-- PL SCENE
-- ======================================================
local alphabet = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 
	'H', 'I', 'J', 'K', 'L', 'M', 'N', 
	'O', 'P', 'Q', 'R', 'S', 'T', 'U', 
	'V', 'W', 'X', 'Y', 'Z'
}

local charsTxArr = newBmpArr('gfx/alphabet.png', 26)
local charsTx = {}
for i = 1, #alphabet do
	charsTx[alphabet[i]] = charsTxArr[i]
end

local statsTx = {
	Texture.new('gfx/attdamage.png'),
	Texture.new('gfx/attheal.png'),
	Texture.new('gfx/attmana.png'),
}

local btnColors = {
	0x1cffe2, 0x2affd4, 0x2affd4, 0x38ffc6,
	0x1cffe2, 0x1cffe2, 0x0efff0, 0x0efff0,
	0x0efff0, 0x00f0ff, 0x00ffff, 0x00ffff,
	0x00ffff, 0x00ffff, 0x00e2ff, 0x00d4ff,
}

local pos = {
	{210, 1000}, {430, 1000}, {650, 1000}, {870, 1000},
	{210, 1220}, {430, 1220}, {650, 1220}, {870, 1220},
	{210, 1440}, {430, 1440}, {650, 1440}, {870, 1440},
}

local hintTx  = Texture.new('gfx/hintbtn.png')
local shuffTx = Texture.new('gfx/shufflebtn.png')
local bsTx    = Texture.new('gfx/bsbtn.png')
local subTx   = Texture.new('gfx/submitbtn.png')
local backTx  = Texture.new('gfx/backbtn.png')

local wordDisplayFont = TTFont.new("fonts/JetBrainsMono.ttf", 100, true, 1)


-- ======================================================
-- #KEYBOARD CLASS
-- ======================================================
Kb = Core.class(Sprite)
function Kb:init()
	self.btn   = {} -- char button array
	self.chars = '' -- chars input by the user
	self.hint  = '' -- base word from charset
	self.stat  = '' -- button stat string

	-- #SPRITE chars display text from user input
	self.charsTf = TextField.new(wordDisplayFont, self.chars)
	self.charsTf:setLayout({w=860, h=200, lineSpacing=7, flags=FontBase.TLF_CENTER})
	self.charsTf:setPosition(110, 800)
	self:addChild(self.charsTf)

	-- #SPRITE chars btn grid
	for i = 1, 12 do
		self.btn[i] = newSimpleBtn(btnColors[i], 0xa5a5a5, 1, 200, 200, pos[i][1], pos[i][2])
		self:addChild(self.btn[i])
		self.btn[i].color = btnColors[i]
		self.btn[i].char  = charsTxArr[i]
		self.btn[i].stat  = 1

		self.btn[i].ctx = Bitmap.new(charsTxArr[i])
		self.btn[i].ctx:setScale(0.7)
		self.btn[i].ctx:setAnchorPoint(0.5, 0.5)
		self.btn[i]:addChild(self.btn[i].ctx)
		
		self.btn[i].atx = Bitmap.new(statsTx[1])
		self.btn[i].atx:setAnchorPoint(0.5, 0.5)
		self.btn[i]:addChild(self.btn[i].atx)
		
		-- chars btn callback
		self.btn[i]:addEventListener('onPress', function()
			local cl = string.len(self.chars)
			
			if cl < 12 then
				self.btn[i].enable = false
				self.chars = self.chars..self.btn[i].char 
				self.stat  = self.stat..self.btn[i].stat
				self.charsTf:setText(self.chars)
			end
		end)
	end

	-- #SPRITE hint button
	self.hintBtn  = newBmpBtn(hintTx, 210, 1660)
	self:addChild(self.hintBtn)
	
	self.hintBtn:addEventListener('onPress', function()
		print(self.hint)
	end)

	-- #SPRITE shuffle button
	self.shuffBtn = newBmpBtn(shuffTx, 430, 1660)
	self:addChild(self.shuffBtn)
	
	self.shuffBtn:addEventListener('onPress', function() 
		self:newCharSet(wordBase)
	end)

	-- #SPRITE backspace button
	self.bsBtn = newBmpBtn(bsTx, 650, 1660)
	self:addChild(self.bsBtn)
	
	self.bsBtn:addEventListener('onPress', function()
		self.chars = ''
		self.stat  = ''
		self.charsTf:setText(self.chars)
		
		for i = 1, 12 do
			self.btn[i]:setColor(btnColors[i])
			self.btn[i].enable = true
		end
	end)
	
	-- #SPRITE submit button
	self.subBtn = newBmpBtn(subTx, 870, 1660)
	self:addChild(self.subBtn)

	-- initial value
	self:newCharSet(wordBase)
end

-- Kb fnc to generate new charset
function Kb:newCharSet(wordBase)
	-- clean up
	self.chars = ''
	self.hint  = ''
	self.stat  = ''
	self.charsTf:setText(self.chars)
	
	for i = 1, 12 do
		self.btn[i]:setColor(btnColors[i])
		self.btn[i].enable = true
	end
	
	-- proceed
	math.randomseed(os.time())
	self.hint = string.upper(wordBase[math.random(1, #wordBase)])
	local charSet = {}
		
	for i = 1, string.len(self.hint) do
		if #charSet >= 12 then
			break
		else
			charSet[i] = string.sub(self.hint, i, i)
		end
	end
	
	local csLen = #charSet
	for i = csLen + 1, 12 do
		charSet[i] = alphabet[math.random(1, #alphabet)]
	end
	
	local csShuffled = {}
	for i, v in ipairs(charSet) do
		local pos = math.random(1, #csShuffled+1)
		table.insert(csShuffled, pos, v)
	end
	
	local stat = {} 
	for i = 1, 12 do
		stat[i] = math.random(1, 3)
	end
	
	-- update sprite
	for i = 1, 12 do
		self.btn[i].char = csShuffled[i]
		self.btn[i].stat = stat[i]
		self.btn[i].ctx:setTextureRegion(charsTx[csShuffled[i]])
		self.btn[i].atx:setTexture(statsTx[stat[i]])
	end
end

-- ======================================================
-- #RETURN BTN CLASS
-- ======================================================
ReturnBtn = Core.class(Sprite)

function ReturnBtn:init()
	-- #SPRITE menu return button
	self.backBtn = newBmpBtn(backTx, 150, 150)
	self:addChild(self.backBtn)
	
	local switchEvent = Event.new('switchScene')
	self.backBtn:addEventListener('onRelease', function()
		switchEvent.scene = 1
		stage:dispatchEvent(switchEvent)
	end)
end


-- ======================================================
-- #PLYR CLASS
-- ======================================================


-- ======================================================
-- #SCENE CLASS
-- ======================================================
PlScene = Core.class(Sprite)
function PlScene:init()
	self.Kb = Kb.new()
	self:addChild(self.Kb)
	
	self.ReturnBtn = ReturnBtn.new()
	self:addChild(self.ReturnBtn)
end
