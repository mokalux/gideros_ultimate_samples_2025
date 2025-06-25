AddPhysicsToTiles = Core.class(Sprite)

function AddPhysicsToTiles:init(scene,tilemap,layer)

-- debug flag for box2d drawing and objects printout
local debug = false

-- Create the objects from the tilemap objects layer
for i = 1, #layer.objects do

	if debug then  -- Print out objects in layer
	print("-------------------------------------------------------------------------------------------------------------")
	print("Name: ", layer.objects[i].name, "Type: ", layer.objects[i].type, 
			"X: ", layer.objects[i].x, "Y: ", layer.objects[i].y, 
			"Width: ", layer.objects[i].width, "Height: ", layer.objects[i].height,
			"Score: ", tilemap:getProperty(layer.objects[i], "score"))
	print("-------------------------------------------------------------------------------------------------------------")

	end


-- if this is not a polygon
if layer.objects[i].polygon == nil then

	-- Create each world object from layer - x, y, width, height, name, type, score
	scene.b2World:object(layer.objects[i].x + layer.objects[i].width/ 2, layer.objects[i].y + layer.objects[i].height/2, 
						layer.objects[i].width, layer.objects[i].height, layer.objects[i].name, layer.objects[i].type,
							tilemap:getProperty(layer.objects[i], "score"))


else


-- This shape is a polygon

local coords = {}

        local myShape = Shape.new()
		local coords = {}

		for j=1, #layer.objects[i].polygon do
	
table.insert(coords,layer.objects[i].polygon[j].x)
table.insert(coords,layer.objects[i].polygon[j].y)			
			
		end
		
	--create box2d physical object
	local body = scene.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(layer.objects[i].x, layer.objects[i].y)
	body:setAngle(self:getRotation() * math.pi/180)

local poly = b2.PolygonShape.new()

poly:set(unpack(coords))

	local fixture = body:createFixture{shape = poly, density = 1.0, 
	friction = 0.1, restitution = 0.8}
	
	myShape.body = body
	myShape.body.name = name
	myShape.body.type = type
	myShape.body.score = score
	
	
	
	
	--[[
	
local body = physicsLayer.world:createBody{type = b2.DYNAMIC_BODY}
body:setPosition(self:getX(), self:getY());
body:setAngle(self:getRotation() * math.pi/180);

local poly = b2.PolygonShape.new()
poly:setAsBox((self:getWidth()/2)-10,10,0,4,0)
local fixture = body:createFixture{shape = poly, density = 1.0, friction = 0.1, restitution = 0.2}

local filterData = {categoryBits = 2, maskBits = 1};
fixture:setFilterData(filterData);
self.body = body

self.spritesOnScreen = spritesOnScreen;
self.background = background;
self.scene = scene;
self.score = score;
self.scoreText = scoreText
self.atlas = atlas;

self.physicsLayer = physicsLayer;

self.body.name = "caveman";

self.body:setPosition(spawnX, -10);

self.body.parent = self;
	
	--]]
	
	
	
	
	
	
	
	
	
	
	
	
	
	

end

end




end