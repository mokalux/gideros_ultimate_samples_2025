
-- NOTE: exclude level files from execution and load them using loadfile() as required

local level = loadfile('testlevel.lua')() -- load and and execute file to get the table containing the level data

-- now it is a simple matter of parsing the table...

-- process layers of map
local layers = level.layers

for i = 1, #layers do -- process all layers in level
	local layer = layers[i] -- next layer
	local layerType = layer.type -- type of layer

	if layerType == "objectgroup" then -- layer of objects
		local objects = layer.objects -- objects contained in layer
		for i = 1, #objects do -- process all objects in layer
			local object = objects[i] -- next object in layer
			local objectType = object.type -- type of object
			if objectType == "player_start" then
			-- process player start location
			elseif objectType == "level_exit" then
			-- process level exit location
			elseif objectType == "coin" then
			-- process coin collectable
			elseif objectType == "platform" then
			-- create chainshape or other physics object here that represents platform
			else
			print("unknown object type")
			end
		end
	elseif layerType == "imagelayer" then
		-- process image layer here
	elseif layerType == "tilelayer" then
		-- process tile layer here
	else
		print("unknown layer type")
	end
end
