Fonts = Core.class(Sprite)

function Fonts:init(scene)

	self.scene = scene

	-- Work out the scale

	self.scene.deviceScale = application:getLogicalScaleX();

	-- Set up all fonts here
	-- We decide which resolution we're using and load the fonts accordingly

	local font, scalex, scaley
	
	if (self.scene.deviceScale) > 1.5 then

		--------------------------------------------------------------
		-- Load high res fonts here
		--------------------------------------------------------------


		--self.scene.collectedLootFont = BMFont.new("Fonts/collected loot@2x.fnt", "Fonts/collected loot@2x.png")
		self.scene.signTextFont = BMFont.new("Fonts/sign text@2x.fnt", "Fonts/sign text@2x.png",true)
		self.scene.timerFont = BMFont.new("Fonts/timer@2x.fnt", "Fonts/timer@2x.png",true)
		self.scene.timerRedFont = BMFont.new("Fonts/timer red@2x.fnt", "Fonts/timer red@2x.png",true)
		self.scene.levelTitleFont = BMFont.new("Fonts/Level Title@2x.fnt", "Fonts/Level Title@2x.png",true)
		self.scene.loadingFont = BMFont.new("Fonts/loading@2x.fnt", "Fonts/loading@2x.png",true)

		-- scale is inverse of logical scale
		self.scene.scalex = 1 / application:getLogicalScaleX()
		self.scene.scaley = 1 / application:getLogicalScaleY()

	else

		--------------------------------------------------------------
		-- Load standard definition fonts here
		--------------------------------------------------------------

		--self.scene.collectedLootFont = BMFont.new("Fonts/collected loot.fnt", "Fonts/collected loot.png")
		self.scene.signTextFont = BMFont.new("Fonts/sign text.fnt", "Fonts/sign text.png",true)
		self.scene.timerFont = BMFont.new("Fonts/timer.fnt", "Fonts/timer.png",true)
		self.scene.timerRedFont = BMFont.new("Fonts/timer red.fnt", "Fonts/timer red.png",true)
		self.scene.levelTitleFont = BMFont.new("Fonts/Level Title.fnt", "Fonts/Level Title.png",true)
		self.scene.loadingFont = BMFont.new("Fonts/loading.fnt", "Fonts/loading.png",true)

		-- scale is 1
		
		self.scene.scalex = 1
		self.scene.scaley = 1

	end




end

--[[
local text = BMTextField.new(font, "Hello Gideros!")
text:setScale(scalex, scaley)
stage:addChild(text)
--]]