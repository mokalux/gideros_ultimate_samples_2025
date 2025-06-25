Damage = Core.class(Sprite)

function Damage:init()

	local packDamage = TexturePack.new("objects/ship/ship_damage.txt", "objects/ship/ship_damage.png")
	
	self.ndamage = 1

	self.damage = {
		Bitmap.new(packDamage:getTextureRegion("damage_00.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_01.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_02.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_03.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_04.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_05.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_06.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_07.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_08.png")),
		Bitmap.new(packDamage:getTextureRegion("damage_09.png")),
	}
	
	self.mc = MovieClip.new{
	{1, 1, self.damage[1]},
	{2, 2, self.damage[2]},
	{3, 3, self.damage[3]},
	{4, 4, self.damage[4]},
	{5, 5, self.damage[5]},
	{6, 6, self.damage[6]},
	{7, 7, self.damage[7]},
	{8, 8, self.damage[8]},
	{9, 9, self.damage[9]},
	{10, 10, self.damage[10]},
	}
	self:setPosition(20,420)
	self.mc:gotoAndPlay(1)
	self:addChild(self.mc)
	
	self:addEventListener(Event.ENTER_FRAME, self.onDamage, self)
end

function Damage.onDamage(self)

	self.mc:gotoAndPlay(self.ndamage)

end