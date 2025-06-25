--- Global
cGlobal = Core.class()

-- init
function cGlobal:init()
	-- Fonts
	self.FONT_TITLE = TTFont.new(CONST.FONT_NAME, 65, ' :ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
	self.FONT = TTFont.new(CONST.FONT_NAME, 42, ' :ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
	self.FONT_UI = TTFont.new(CONST.FONT_NAME, 32, ' :ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')

	-- Resource
	self.TEXTURE_PACK = TexturePack.new("images/res.txt", "images/res.png")
	
	-- Setup
	self.Score = 0
	-- Load
--	local _hs = dataSaver.loadValue(CONST.SAVE_TAG_HS)
	local _hs
	if _hs == nil then
		_hs = 0
	end
	self.HighScore = _hs
	self.GameState = CONST.GAME_STATE.START
	self.Game = nil
	self.GameUI = nil
	self.GameField = nil
	
	--- Functions
	-- Get labels
	self.getLabel = function (text, font, x, y)
		local _label = TextField.new(font, text)
		_label:setTextColor(CONST.TEXT_COLOR)
		_label:setAnchorPoint(0.5, 0.5)
		_label:setPosition(x, y)
		return _label
	end
	--
	self.getLabelTitle = function(text, x, y)
		return self.getLabel(text, self.FONT_TITLE, x, y)
	end
	--
	self.getLabelText = function(text, x, y)
		return self.getLabel(text, self.FONT, x, y)
	end
	--
	self.getLabelUI = function(text, x, y)
		return self.getLabel(text, self.FONT_UI, x, y)
	end
	
	-- Resource
	self.getBmpFromPack = function(name) 
		return Bitmap.new(GL.TEXTURE_PACK:getTextureRegion(name))
	end
end
