Player = Core.class(Sprite)

function Player:init(xname, xspritesheet, xcols, xrows, xposx, xposy, xoffsetx, xoffsety)
	-- retrieve all anims in texture
	local myanimstex = Texture.new(xspritesheet)
	local cellw = myanimstex:getWidth() / xcols
	local cellh = myanimstex:getHeight() / xrows
	local myanims_list = {}
	for r = 1, xrows do
		for c = 1, xcols do
			local myanimstexregion = TextureRegion.new(
					myanimstex, (c - 1) * cellw, (r - 1) * cellh, cellw, cellh)
			myanims_list[#myanims_list + 1] = myanimstexregion
		end
	end

	-- player animation settings
	self.currentanim = ""
	self.frame = 0
	self.animspeed = 1 / 8
	self.animtimer = self.animspeed
	-- create player anims
	self.anims = {}
	self:createAnim("idle", 1, 8, myanims_list)
	self:createAnim("walk", 39, 46, myanims_list)

	-- player settings
	self.x = xposx
	self.y = xposy
	self.vx = 0
	self.vy = 0
	self.flip = 1
	self.accel = 1.0
	self.maxspeed = 1.5

	-- the player bitmap
	self.bmp = Bitmap.new(myanims_list[1]) -- starting bmp texture
	self.bmp:setAnchorPoint(0.5, 0.5)
	self.w = self.bmp:getWidth() / 2 - xoffsetx
	self.h = self.bmp:getHeight() - xoffsety
	-- set position inside sprite
	self.bmp:setPosition(self.w / 2 - xoffsetx / 2, self.h / 2 - xoffsety / 2)

	-- collisions debugging
	local mypixel = Pixel.new(0xff0000, 0.25, self.w, self.h)

	-- our sprite is ready
	local mysprite = Sprite.new()
	mysprite:addChild(self.bmp)
	mysprite:addChild(mypixel) -- debug
	self:addChild(mysprite)

	-- player controls
	self.iskeyleft = false
	self.iskeyright = false
	self.iskeyup = false
	self.iskeydown = false
	self.iskeyspace = false

	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.KEY_UP, self.onKeyUp, self)
end

-- FUNCTIONS
function Player:createAnim(xanimname, xstart, xfinish, xanimslist)
	self.anims[xanimname] = {}
	for i = xstart, xfinish do
		self.anims[xanimname][#self.anims[xanimname] + 1] = xanimslist[i]
	end
end

-- KEYS HANDLER
function Player:onKeyDown(e) -- keys pressed
	if e.keyCode == KeyCode.LEFT then self.iskeyleft = true end
	if e.keyCode == KeyCode.RIGHT then self.iskeyright = true end
	if e.keyCode == KeyCode.UP then self.iskeyup = true end
	if e.keyCode == KeyCode.DOWN then self.iskeydown = true end
	if e.keyCode == KeyCode.SPACE then self.iskeyspace = true end
end

function Player:onKeyUp(e) -- keys released
	if e.keyCode == KeyCode.LEFT then self.iskeyleft = false end
	if e.keyCode == KeyCode.RIGHT then self.iskeyright = false end
	if e.keyCode == KeyCode.UP then self.iskeyup = false end
	if e.keyCode == KeyCode.DOWN then self.iskeydown = false end
	if e.keyCode == KeyCode.SPACE then self.iskeyspace = false end
end
