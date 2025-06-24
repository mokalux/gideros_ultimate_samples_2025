-- Gideros landscape example - Create a landscape from a heightfield and texture, and view it in 3D
-- Author: Paul Halter (paul@pishtech.com)
-- Note: This example uses the file objloader.lua from the Graphics3D/3D-Horse example project.

SCREEN_WIDTH, SCREEN_HEIGHT = 1920, 1080

local viewport = Viewport.new()
local vpm = Matrix.new()
vpm:perspectiveProjection(45, -SCREEN_WIDTH/SCREEN_HEIGHT, 0.1, 10000)
viewport:setProjection(vpm)
--viewport:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
viewport:setPosition(SCREEN_WIDTH / 2, 1.5 * SCREEN_HEIGHT)
viewport:setScale(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 1)
local scene_3d = Sprite.new()
viewport:setContent(scene_3d)

-- Create the landscape:
local land_texture_path = "gfx/lmw2_texture.png"
local heightfield_path = "gfx/lmw2_heightfield.png"
local land = Landscape.new(heightfield_path, 128, 1000, -20, 200, land_texture_path, true)
land:setY(256)

local include_sky_box = true

if include_sky_box then
	-- Create a cube:
	local cube = loadObj("3d", "cube.obj")
	-- Tint it sky blue
	cube:setColorTransform(1.0, 1.3, 2)
	-- Make it big enough that the landscape and the camera will always remain inside the cube:
	cube:setScale(2000, 2000, 2000)
	scene_3d:addChild(cube)
end

scene_3d:addChild(land)

stage:addChild(viewport)

local frame_count = 0

land:addEventListener(Event.ENTER_FRAME,
	function()
		frame_count = frame_count + 0.1
		
		-- Rotate the landscape:
		land:setRotationY(frame_count)
		
		viewport:lookAt(
			1000 + math.sin(frame_count * 0.01) * 500, 300, 0, -- Position the camera a varying distance away on X, 300 units up, and at the center on Z
--			0, 0, 0, -- Look at the center of the landscape
			64, -64, 0, -- Look at the center of the landscape
			0, 1, 0)
	end
)
