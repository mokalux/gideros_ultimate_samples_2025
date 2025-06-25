level1 = Core.class(Sprite)

function level1:init()
	local Atlas2 = TexturePack.new("gfx/atlases/Atlas 2.txt", "gfx/atlases/Atlas 2.png")
	self.atlas2 = Atlas2
	local spritesOnScreen = {}
	self.spritesOnScreen = spritesOnScreen
	--------------------------------------------------------------
	-- Layers
	--------------------------------------------------------------
	-- Tiles 1
	tiles1 = Sprite.new()
	self:addChild(tiles1)
	self.tiles1 = tiles1
	-- Tiles 2
	tiles2 = Sprite.new()
	self:addChild(tiles2)
	self.tiles2 = tiles2

	-- Physics layer (will be scrolled)
	local physicsLayer = Sprite.new() -- create new sprite instance
	self:addChild(physicsLayer) -- add sprite to this scene
	self.physicsLayer = physicsLayer -- store in our table

	heroLayer = Sprite.new()
	self:addChild(heroLayer)
	self.heroLayer = heroLayer

	--------------------------------------------------------------
	-- Physics
	--------------------------------------------------------------
	local b2World = Box2d.new(self)
	self.b2World = b2World -- Add a reference to this class to this scene's table
	self.physicsLayer:addChild(b2World) -- Add physics to screen

	--------------------------------------------------------------
	-- Tiles
	--------------------------------------------------------------
	local backgroundTiles = TileMapMultiple.new("gfx/tilesets/layer 2.lua")
	self.tiles1:addChild(backgroundTiles)
	self.backgroundTiles = backgroundTiles

	local tilemap = TileMapMultiple.new("gfx/tilesets/Tiles 1.lua")
	self.tiles2:addChild(tilemap)
	self.tilemap = tilemap

	-- Setup the objects (The ground surfaces etc created in Tiled)
	local objects = tilemap:getLayer("Objects") -- Now get the data from the tiled file

	-- Run the function that adds physics bodies to tilemaps
	local tileBodies = AddPhysicsToTiles.new(self,tilemap,objects)

	--------------------------------------------------------------
	-- Animated Tiles
	--------------------------------------------------------------
	local acidAnim = AnimateAcid.new(self)
	self:addChild(acidAnim)
	-- List of acid tiles that need animating
	self.acidAnimTiles = {
		{x=1,y=4},
		{x=2,y=4}
	}

	--------------------------------------------------------------
	-- Add hero
	--------------------------------------------------------------
	local hero = Hero.new(self, 150, 0)
	self.hero = hero
	physicsLayer:addChild(hero)
	table.insert(self.spritesOnScreen, hero)
	hero:setAlpha(.75)

	--------------------------------------------------------------
	-- Set up camera
	--------------------------------------------------------------
	local camera = Camera.new(self)
	self:addChild(camera)
	self.camera = camera

	--------------------------------------------------------------
	-- Class that controls player movement and scrolling
	--------------------------------------------------------------
	local playerMovement = PlayerMovement.new(self)
	self:addChild(playerMovement)
	self.playerMovement = playerMovement

	--------------------------------------------------------------
	-- Interface
	--------------------------------------------------------------
	local interface = Interface.new(self)
	self.interface = interface
	self:addChild(interface)
end

function level1:onTransitionInBegin()
end

function level1:onTransitionInEnd()
end

function level1:onTransitionOutBegin()
end

function level1:onTransitionOutEnd()
end
