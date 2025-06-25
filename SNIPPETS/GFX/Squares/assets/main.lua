local iterations = 1000

local sprite = Sprite.new()
sprite:setY(100)
stage:addChild( sprite )
 
texturePack = TexturePack.new("spritesheet.txt", "spritesheet.png", true )
local size = Bitmap.new(texturePack:getTextureRegion("square.png")):getWidth()
local mcs = {}
local startTime = os.timer() --in the beginning of the file
 
local test = "mesh" -- mesh, bitmap, shape, pixel, particle
 
if test == "particle" then
	-- iPad Mini Retina: 60 fps
 	-- iPhone 5: 12fps
	-- iPod touch 5th generation: 4ps
	local texture = Texture.new("square.png")	
	local particles = Particles.new()
	particles:setTexture(texture)
	local p = {}
	local colors = {0x333344, 0x331149, 0x137944, 0x33f34f, 0x3f3304, 0x3303f4, 0xf3f304}
	for i=1, iterations do
		local color = colors[math.random(#colors)]
		local speed_x = math.random(100)/100
		local speed_y = math.random(100)/100
		local p_index = particles:addParticles( 0, 0, 64, 10000 )
		particles:setParticleColor(p_index, color, 1)
		particles:setParticleSpeed(p_index, speed_x, speed_y, 0, 1)
		table.insert( p, particle )
	end
	stage:addChild( particles )
	--and this in every loop end
	local endPlacingTime =  os.timer()- startTime
	print("objects placed in",  endPlacingTime)

elseif test == "pixel" then
	-- iPad Mini Retina: 58 fps
 	-- iPad 2: 34 fps	
	-- iPod touch 5th generation: 29 fps
	-- Nexus 6: 18 fps
	for i=1, iterations do
		-- Create shape
		local pixel = Pixel.new( 0xffffff, 1, size, size )
		local r = math.random(20)/20
		local g = math.random(20)/20
		local b = math.random(20)/20
		pixel:setColorTransform( r, g, b, math.random(10)/10)
		-- Move shape
		local target_x = math.random(100)
		local target_y = math.random(100)		
		local mc = MovieClip.new{
			{1, 100, pixel, {x = {0, target_x, "inOutSine"}, y = {0, target_y, "inOutSine"}}},	
			{101, 200, pixel, {x = {target_x, 0, "inOutSine"}, y = {target_y, 0, "inOutSine"}}},	
		}
		mc:setGotoAction(200,1)
		table.insert ( mcs, mc ) -- To avoid being garbage collected		
		sprite:addChild( pixel )
	end
	--and this in every loop end
	local endPlacingTime =  os.timer()- startTime
	print("objects placed in",  endPlacingTime)

elseif test == "bitmap" then
 	-- iPad Mini Retina: 57 fps
	-- iPod touch 5th generation: 25fps
	-- iPad 2: 17 fps	
	-- Nexus 6: 16 fps
	for i=1, iterations do
		local bitmap = Bitmap.new(texturePack:getTextureRegion("square.png"))
		local r = math.random(20)/20
		local g = math.random(20)/20
		local b = math.random(20)/20
		bitmap:setColorTransform( r, g, b, math.random(10)/10)
		-- Move mesh
		local target_x = math.random(100)
		local target_y = math.random(100)
		local mc = MovieClip.new{
			{1, 100, bitmap, {x = {0, target_x, "inOutSine"}, y = {0, target_y, "inOutSine"}}},	
			{101, 200, bitmap, {x = {target_x, 0, "inOutSine"}, y = {target_y, 0, "inOutSine"}}},	
		}
		mc:setGotoAction(200,1)
		table.insert ( mcs, mc ) -- To avoid being garbage collected		
		sprite:addChild( bitmap )
	end
	 --and this in every loop end
	local endPlacingTime =  os.timer()- startTime
	print("objects placed in",  endPlacingTime)
 
elseif test == "mesh" then
 	-- iPad Mini Retina: 58 fps
	-- iPad 2: 33 fps	
	-- iPod touch 5th generation: 28 fps
	-- Nexus 6: 19 fps
	for i=1, iterations do
		-- Create mesh
		local mesh = Mesh.new()
		mesh:setVertexArray(0, 0,   size, 0,   size, size,   0, size)
		mesh:setIndexArray(1, 2, 3,     1, 3, 4)
		local r = math.random(20)/20
		local g = math.random(20)/20
		local b = math.random(20)/20
		mesh:setColorTransform( r, g, b, math.random(10)/10)
		-- Move mesh
		local target_x = math.random(100)
		local target_y = math.random(100)
		local mc = MovieClip.new{
			{1, 100, mesh, {x = {0, target_x, "inOutSine"}, y = {0, target_y, "inOutSine"}}},	
			{101, 200, mesh, {x = {target_x, 0, "inOutSine"}, y = {target_y, 0, "inOutSine"}}},	
		}
		mc:setGotoAction(200,1)
		table.insert ( mcs, mc ) -- To avoid being garbage collected	
		sprite:addChild( mesh )
	end
	 --and this in every loop end
	local endPlacingTime =  os.timer()- startTime
	print("objects placed in",  endPlacingTime)
 
elseif test == "shape" then
	-- iPad Mini Retina: 58 fps
 	-- iPad 2: 34 fps	
	-- iPod touch 5th generation: 29 fps
	-- Nexus 6: 18 fps
	for i=1, iterations do
		-- Create shape
		local shape = Shape.new()
		shape:setFillStyle(Shape.SOLID, 0xffffff, 1)
		shape:beginPath()
		shape:moveTo(0,0)
		shape:lineTo(size, 0)
		shape:lineTo(size, size)
		shape:lineTo(0, size)
		shape:lineTo(0, 0)
		shape:endPath()
		local r = math.random(20)/20
		local g = math.random(20)/20
		local b = math.random(20)/20
		shape:setColorTransform( r, g, b, math.random(10)/10)
		-- Move shape
		local target_x = math.random(100)
		local target_y = math.random(100)
		local mc = MovieClip.new{
			{1, 100, shape, {x = {0, target_x, "inOutSine"}, y = {0, target_y, "inOutSine"}}},	
			{101, 200, shape, {x = {target_x, 0, "inOutSine"}, y = {target_y, 0, "inOutSine"}}},	
		}
		mc:setGotoAction(200,1)
		table.insert ( mcs, mc ) -- To avoid being garbage collected
		sprite:addChild( shape )
	end
	--and this in every loop end
	local endPlacingTime =  os.timer()- startTime
	print("objects placed in",  endPlacingTime)
end
 
-- Mem and fps
local sceneDebug = SceneDebug.new()
sceneDebug:addEventListener( Event.ENTER_FRAME, sceneDebug.update, sceneDebug )
stage:addChild( sceneDebug )
