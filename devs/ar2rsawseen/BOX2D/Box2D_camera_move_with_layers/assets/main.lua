--let's create separate scene and hold everything there
--then it will be easier to reuse it if you want to use SceneManager class

scene = Core.class(Sprite)

--get screen dimensions
local screenW = application:getContentWidth()
local screenH = application:getContentHeight()

--on scene initialization
function scene:init()
	self.layerDistance = 0
	--create a layer
	self.layer = Sprite.new()
	self:addChild(self.layer)
	
	--storing layer stuff for removal
	self.layers = {}
	self.layerCrates = {}
	
	--create world instance
	self.world = b2.World.new(0, 0, true)
	
	--create and store refrence to ball
	self.ball = Bitmap.new(Texture.new("./ball.png"))
	self.ball:setPosition(100, 400)
	self:addChild(self.ball)
	self.world:createCircle(self.ball, {type = "dynamic"})
	
	--set speed of ball
	local x, y = self.ball:getPosition()
	self.ball:setLinearVelocity(50, 0)
	
	--set up debug drawing
	self:addChild(self.world:getDebug())
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function scene:crate(x, y)
	local crate = Bitmap.new(Texture.new("./crate.png"))
	
	--apply layer offset to coordinates
	crate:setPosition(self.layerDistance + x, y)
	self:addChild(crate)
	self.world:createRectangle(crate, {type = "static"})
	return crate
end

function scene:createLayer()
	
	local crates = {}
	
	--create box2d objects on new layer
	crates[#crates+1] = self:crate(100, 320)
	crates[#crates+1] = self:crate(200, 300)
	crates[#crates+1] = self:crate(400, 500)
	crates[#crates+1] = self:crate(1600, 500)
	
	
	--add new layer
	local bitmap = Bitmap.new(Texture.new("Background.jpg", true))
	bitmap:setPosition(self.layerDistance, 0)
	self.layerDistance = self.layerDistance + bitmap:getWidth()
	self.layer:addChild(bitmap)
	
	--store layer info
	table.insert(self.layers, {layer = bitmap, crates = crates})
	--check if we have stored more that two layers (current and previous)
	--we can remove it from memory
	if #self.layers > 2 then
		--remove bitmap from layer
		self.layer:removeChild(self.layers[1].layer)
		
		--and destroy box2d objects
		for i = 1, #self.layers[1].crates do
			self.world:removeBody(self.layers[1].crates[i], true)
		end
		
		table.remove(self.layers, 1)
	end
end

--running the world
function scene:onEnterFrame() 
	self.world:update()
	
	--get ball coordinates
	local x, y = self.ball:getPosition()
	
	--center the ball on the screen
	self:setX(screenW/2 - x)
	self:setY(screenH/2 - y)
	
	--check if layer comes to an end
	if x + screenW/2 >= self.layerDistance then
		--create layer
		self:createLayer()
	end
end

--add created scene to stage or sceneManager
local mainScene = scene.new()
stage:addChild(mainScene)