local defaultParams = {
	name = "", text = "",
	txtColor = 0, bgColor = 0,
	offsetX = 0, offsetY = 0,
	scaleX = 1, scaleY = 1,
}

Button = Core.class(Sprite)

-- params (table):
--		w (number): width of the button
--		h (number): height of the button
--		font (Font): font to use [optional]
--		name (string): name of the button [optional]
--		text (string): text to display [optional]
--		texture (Texture): ninepatch texture to use [optional]
--		txtColor (number): text color [default: black]
--		bgColor (number): background color [default: black]
--		offsetX (number): offset position by X [default: 0]
--		offsetY (number): offset position by Y [default: 0]
--		scaleX (number): text scale by Y [default: 1]
--		scaleY (number): text scale by Y [default: 1]
function Button:init(params)
	params = params or {}
	append(params, defaultParams)
	
	self.g = Pixel.new(params.bgColor, 1, params.w, params.h)
	if (params.texture) then 
		self.g:setTexture(params.texture)
		self.g:setNinePatch(16)
	end
	self:addChild(self.g)
	
	self.tf = Label.new(
		params.font, params.text, params.txtColor,
		params.w / 2 + params.offsetX, params.h / 2 + params.offsetY,
		params.scaleX, params.scaleY
	)
	self:addChild(self.tf)
	
	self.name = params.name
end

function Button:getText()
	return self.tf.text:getText()
end