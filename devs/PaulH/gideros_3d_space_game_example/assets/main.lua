--[[
	3D Space Game sample - A playable game demonstrating the use of 3D graphics in Gideros

	Author: Paul Halter (paul@pishtech.com)
	
	Note: This example uses the file objloader.lua from the Graphics3D/3D-Horse example project.
	
	In this game the player controls a spaceship that is moving along the Z axis, with limited
	steering, enough to let the player dodge asteroids.  The asteroids tumble in place, and become
	more abundant as the player progresses.  The spaceship can fire missiles, but each missile
	takes time to load and get ready to fire so the player can't continually fire to clear a path.
	The player earns points for distance traveled and for asteroids destroyed.
	
	This game is playable but has not been tested or refined to the degree that would be
	appropriate for a game intended for publication.
	
	The accompanying .blend files are the 3D models used in this game, created with Blender version 2.79. 
	
	Note that when textures are applied to model in Blender, then exported to a Wavefront .obj file,
	which is then loaded in Gideros with the loadObj() function, the texture appears
	misalligned.  This is resolved by flipping each texture vertically (in Photoshop,
	Image, Rotate, Flip Vertical.)  The images in the models folder have been flipped to
	create the versions in the Gideros project folder.
	
	The code demonstrates loading a 3D mesh from a Wavefront OBJ file (using code from the
	3D horse sample) and making 3D meshes childen of one another.  The missile is initially a child
	of the spaceship, as it gets positioned and rotated into position before it can be fired.  A
	flame mesh is added as a child of each missile as it is fired.
	
	This also demonstrates creating a 3D mesh containing a 2D Bitmap, with an alpha channel.
	The ship engines leave a trail of orange rings rendered this way, and when a ship or asteroid
	is destroyed, it breaks into a number of fragments rendered with that technique.
	
	This is intended as a sample project that people can build upon or modify to create an original
	game. These are provided free of charge for re-use with modification, including for use
	in commerical products, provided they are used in a product substantially different
	from this example. In less formal terms, this is provided as an example to help people
	learn 3D programming with Gideros, but the author does not grant anyone permission to
	publish this game as-is or with only minor alterations.
--]]

-- Define the screen dimensions - all positioning will be done relative to these, though the game will
-- be rendered relative to the actual device size using Letterbox mode:
SCREEN_WIDTH, SCREEN_HEIGHT = 1920, 1080

-- Create fonts for on-screen text:
local condensed_bold_font_file = "OpenSanCondBold.ttf"
local nehe = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~\°«»"
message_font = TTFont.new(condensed_bold_font_file, 150, nehe)
score_font = TTFont.new(condensed_bold_font_file, 70, nehe)

-- States for the missile launcher:
MISSILE_LOADING, MISSILE_ROTATING, MISSILE_READY, MISSILE_WAITING = 1, 2, 3, 4
missile_launcher_status = MISSILE_WAITING

-- Progress from 0 to for each state of the launcher:
missile_launcher_progress = 0

-- Black background - in space
stage:setBackgroundColor(0, 0, 0)

-- Create a viewport for a 3D scene:
local viewport = Viewport.new()
local vpm = Matrix.new()
vpm:perspectiveProjection(45, -SCREEN_WIDTH/SCREEN_HEIGHT, 0.1, 10000)
viewport:setProjection(vpm)
viewport:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
viewport:setScale(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 1)

-- Make sprites for layers of objects so we can easily add and remove things from the scene:
local scene_3d = Sprite.new()
-- One layer for asteroids makes it easy to remove all the asteroids from the scene when we reset the game:
local asteroid_layer = Sprite.new()
-- A layer for the ship, missiles, stuff other than asteroids:
local misc_3d_layer = Sprite.new()
-- We especially need a trail layer added last, since the trail of rings is drawn using bitmaps with
-- an alpha channel.  We don't want those rendered first or they'll occlude the more distant objects.
local trail_layer = Sprite.new()

-- Put the layers in the scene in the order we want them to be rendered:
scene_3d:addChild(asteroid_layer)
scene_3d:addChild(misc_3d_layer)
scene_3d:addChild(trail_layer)

-- Have the viewport render the overall scene:
viewport:setContent(scene_3d)

-- Preload some textures:
local ring_texture = Texture.new("ring.png")
local ship_texture = Texture.new("ship.png")
local asteroid_texture = Texture.new("asteroid.png")

-- Create the spaceship mesh and add it to the scene:
local ship = loadObj(".", "ship.obj")

-- The viewport is our 3D view of the world. Put it on the stage so it gets rendered:
stage:addChild(viewport)

-- Keep count of frames for animation, timing events:
local frame_count = 0

-- Preload sounds so they play quickly when we need them:
local engine_sound = Sound.new("engines.wav")
local crackle_sound = Sound.new("crackle_out.wav")
local ship_explosion_sound = Sound.new("large_explosion.wav")
local asteroid_explosion_sound = Sound.new("small_explosion.wav")
local missile_loaded = Sound.new("missile_loading.wav")
local missile_prep_sound = Sound.new("missile_prep.wav")
local missile_shot_sound = Sound.new("missile_shot.wav")

-- Limit the range of motion of the ship:
global_move_x_range = 60
global_move_y_range = 40

-- Transition the camera from a cinematic view to a following view, assert
-- cam_transition goes from 0 to 1:
cam_transition = 0

-- Keep track of the position of the ship:
local ship_loc = {}
ship_loc.x = 0
ship_loc.y = 0
ship_loc.z = 0

-- Handle touches/mouse clicks on the screen:
function onMouseDown(event)
	mouse_down_frame = frame_count
	-- Touch away from center?
	if (event.x < SCREEN_WIDTH * 0.33 or event.x > SCREEN_WIDTH * 0.66) or
		(event.y < SCREEN_HEIGHT * 0.33 or event.y > SCREEN_HEIGHT * 0.66)
	then
		-- Use edges of screen for steering
		steering_ship = true
		steering_x = event.x
		steering_y = event.y
	else
		-- Touched near the center. Launch a missile if there's one ready:
		if missile_launcher_status == MISSILE_READY then
			missile_shot_sound:play(0)
			-- Flag the missile as fired so we can animate it and check for hits:
			missile.fired = true
			
			-- Keep track of the active missile so we can determine when it is no
			-- longer active - we're tracking the position of only one missile at a time
			-- for purposes of detecting collisions with asteroids. To support multiple active
			-- missiles we could store the position of each in a table, then check every asteroid for collisions
			-- with every active missile
			
			-- Not that if another missile is still in flight, the new one will become the active one
			-- so the missile most recently fired will be the one used to detect collisions with
			-- asteroids.
			active_missile = missile
			
			-- Start the missile motionless - we'll speed it up over time:
			missile_speed = 0
			
			-- Start the missile launcher's reloading cycle:
			missile_launcher_status = MISSILE_WAITING
			missile_launcher_progress = 0
			
			-- The missile is a child of the ship, so it moves with the ship. Detatch it and make			
			-- it a child of a layer within the scene:
			ship:removeChild(missile)
			misc_3d_layer:addChild(missile)
			
			-- The missile's position used to be relative to the ship. Make it independent of the ship:
			local x,y,z = missile:getPosition()
			local sx, sy, sz = ship:getPosition()
			x = x + sx
			y = y + sy
			z = z + sz
			missile:setPosition(x, y, z)
			
			-- Is this the most recently fired missile, the one we're using for detecting collisions?
			if missile == active_missile then
				-- Yes it is.  Keep track of where the missile travels each frame so we can check for hits on asteroids:
				last_missile_x = x
				last_missile_y = y
				last_missile_z = z
				missile_x = x
				missile_y = y
				missile_z = z
			end
			
			-- Add flames as a child of the missile:
			missile_flames = loadObj(".", "flames.obj")
			missile:addChild(missile_flames)
			-- Make the flames translucent:
			missile_flames:setAlpha(0.6)
			
			-- Add an event listener to animate the missile:
			missile:addEventListener(Event.ENTER_FRAME, on_missile_enter_frame, missile)
			
		end -- of if we're firing a missile
	end -- of if the player tapped near the center of the screen
	
end -- of onMouseDown()

function onMouseUp(event)
	-- No longer touching, no longer actively steering:
	steering_ship = false
end

function onMouseMove(event)
	if collided then
		-- No steering after your ship blows up:
		steering_ship = false
		return
	end
	
	-- Update the steering based on where the player is touching the screen, if they started
	-- with a touch in the steering areas of the screen:
	if steering_ship then
		steering_x = event.x
		steering_y = event.y
	end
end

-- Add event listeners for mousing/touch events:
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
stage:addEventListener(Event.MOUSE_UP, onMouseUp)

-- Set some game play parameters:
local initial_ship_speed = 10
local ship_speed = initial_ship_speed
local score = 0
local asteroid_points = 10000

-- Define a place for the camera to start for a cinematic start to the scene:
local start_cam_x = 300
local start_cam_y = 200
local start_cam_z = -100

-- Variables for the camera position:
local cam_x = start_cam_x
local cam_y = start_cam_y
local cam_z = start_cam_z

-- Define a place for the camera to be during game play:
local flying_cam_x = 0
local flying_cam_y = 0
local flying_cam_z = 50

-- A custom function to rotate a mesh in 3 directions, since the default rotations are applied in ZYX order,
-- making some orientations unachievable:
function setRotationZXYOrder(mesh, x, y, z, relative)
	if mesh.previous_rotations and not relative then
		setRotationYXZOrder(mesh, -mesh.previous_rotations[1], -mesh.previous_rotations[2], -mesh.previous_rotations[3])
	end
	local scale_mult = 1
	if scale then
		scale_mult = scale
	end
	local m = mesh:getMatrix()
	m:rotate(z, 0, 0, 1)
	m:rotate(x, 1, 0, 0)
	m:rotate(y, 0, 1, 0)
	mesh:setMatrix(m)
	mesh.previous_rotations = {x, y, z}
end

-- A custom function to rotate a mesh in 3 directions in the opposite order, to make it possible to undo
-- rotations we've previsouly done:
function setRotationYXZOrder(mesh, x, y, z)
	local scale_mult = 1
	if scale then
		scale_mult = scale
	end
	local m = mesh:getMatrix()
	m:rotate(y, 0, 1, 0)
	m:rotate(x, 1, 0, 0)
	m:rotate(z, 0, 0, 1)
	mesh:setMatrix(m)
end

-- A function for animating fragments of the ship or an asteroid after an explosion:
function frag_enter_frame(frag)
	-- Get the current position:
	local x, y, z = frag:getPosition()
	
	-- Move each coordinate based on its velocity:
	x = x + frag.vx
	y = y + frag.vy
	-- Add an extra movement on the Z axis - basically everything is flying towards the viewer as we move through space:
	z = z + ship_speed * 0.05 + frag.vz
	
	-- Rotate the fragment based on its rotational speed on each axis:
	frag.rx = frag.rx + frag.rot_xs
	frag.ry = frag.ry + frag.rot_ys
	frag.rz = frag.rz + frag.rot_zs
	setRotationZXYOrder(frag, frag.rx, frag.ry, frag.rz)
	
	-- Update the fragment position after setting the rotation, safer due to the matrix operations in the rotation:
	frag:setPosition(x, y, z)

	-- Fragments have limited lives, so they blink out after a while.  Count down to that time:
	frag.life = frag.life - 1
	if frag.life < 0 and frag:getParent() then
		-- This fragment is done. Get rid of it.
		frag:removeFromParent()
	end

end -- of frag_enter_frame()


-- A function for animating score text in space:
function text_3d_enter_frame(mesh)
	-- Move as we move through space:
	local x, y, z = mesh:getPosition()
	z = z + ship_speed
	mesh:setPosition(x, y, z)

	-- Once the text moves behind the camera, remove it from the scene so we don't waste time
	-- with it:
	if z > cam_z then		
		mesh:removeFromParent()
	end
end -- of frag_enter_frame()

-- Function to animate rings trailing behind the ship engines:
function ring_enter_frame(ring)
	-- Get the position of the ring:
	local x, y, z = ring:getPosition()
	-- Move it on Z, since every coordinate is relative to the zone around the ship, which is moving in space on the Z axis:
	z = z + ship_speed * 0.05
	ring:setPosition(x, y, z)
	
	-- If the ring has moved behind the camera, we won't see it again, so we can remove it:
	if z > cam_z and ring:getParent() == trail_layer then
		trail_layer:removeChild(ring)
	end
	
	-- Make the ring grow and fade over time:
	ring.scale = ring.scale + 0.002
	ring.alpha = ring.alpha - 0.05
	ring:setAlpha(ring.alpha)
	ring:setScale(ring.scale, ring.scale, ring.scale)
end -- of ring_enter_frame()

-- Function to animate asteroids and check for collisions:
function asteroid_enter_frame(asteroid)
	-- Is this asteroid still relevant?
	if not asteroid.active then
		-- May have been destroyed already:
		return
	end
	
	-- Get the position of the asteroid and rotate it based on its rotational speed on each axis:
	local x, y, z = asteroid:getPosition()
	asteroid.rot_x = asteroid.rot_x + asteroid.rot_xs
	asteroid.rot_y = asteroid.rot_y + asteroid.rot_ys
	asteroid.rot_z = asteroid.rot_z + asteroid.rot_zs
	setRotationZXYOrder(asteroid, asteroid.rot_x, asteroid.rot_y, asteroid.rot_z)

	-- Move it on Z to give the impression we're flying along the Z axis:
	z = z + ship_speed
	asteroid:setPosition(x, y, z)

	-- Fade it in over time so they don't just blink into existence:
	asteroid.alpha = math.min(1, asteroid.alpha + 0.1)
	asteroid:setAlpha(asteroid.alpha)

	-- If the asteroid is in the plane where the ship moves (within a frame of movement on the Z axis):
	if z >= ship_loc.z - ship_speed and z < ship_loc.z + ship_speed then
		-- See how far it is from the ship:
		local dx = math.abs(x - ship_loc.x)
		local dy = math.abs(y - ship_loc.y)
		
		-- Did the asteroid come close enough to touch the ship?
		if dx < asteroid.radius and dy < asteroid.radius then
			-- Yes. Did we already have a collision?
			if not collided then
				-- No, this is a new collision.  The ship is toast.
				collided = true
				-- Reset the missile launcher so we don't load any missiles while we're busy exploding:
				missile_launcher_status = MISSILE_WAITING
				missile_launcher_progress = 0
				-- If we were loading a missile, stop the sound effect:
				if missile_prep_sound_player then
					missile_prep_sound_player:stop()
				end

				-- Big badda boom:
				explosion_sound_player = ship_explosion_sound:play(0, false, false)
				-- Snap, crackle and pop:
				crackle_sound_player = crackle_sound:play(0, false, false)
				-- The engines are gone:
				engine_sound_player:stop()
			end -- end of handling ship hitting an asteroid
		end
	end -- of if asteroid passing through the zone where the ship maneuvers
	
	-- Check for missile hits:
	if last_missile_z and asteroid.in_danger_zone and missile and missile.fired then
		-- Did the missile pass through the Z area where this asteroid is in the last frame?
		-- Multiplying the detection zone to give the missile a wider margin of error:
		if (z <= last_missile_z + ship_speed * 4) and (z >= missile_z - ship_speed * 4) then
			-- Yes, asteroid and missile intersected on Z this frame.
			-- Check if they collided on the X and Y axis:
			local dx = math.abs(missile_x - x)
			local dy = math.abs(missile_y - y)
			
			-- Consider it a hit if we're close to contact, not necessarily a direct hit,
			-- by using 1.5 times the radius of the asteroid:
			if dx < asteroid.radius * 1.5 and dy < asteroid.radius * 1.5 then
				-- Missile hit this asteroid
				-- Award some points:
				score = score + asteroid_points
				-- Make a 3D mesh containing text so we show the points earned where the asteroid
				-- had been:
				local points_earned_mesh = Mesh.new(true)
				local points_earned_text = TextField.new(score_font, comma_value(asteroid_points))
				points_earned_mesh:addChild(points_earned_text)
				-- Use a bright color that will be visible over the blackness of space:
				points_earned_text:setTextColor(0xFF00FF)
				-- Center the text for easy rotation:
				points_earned_text:setAnchorPoint(0.5, 0.5, 0.5)
				-- The text would be one unit of size for each pixel - way too big.
				-- Scale it down to something reasonable:
				points_earned_mesh:setScale(0.1, 0.1, 0.1)
				-- Turn the mesh to face the player:
				points_earned_mesh:setRotationY(180)
				points_earned_mesh:setRotation(180)
				-- Put the text in space where the asteroid was:
				points_earned_mesh:setPosition(x, y, z)
				-- Make it lower alpha - don't need full opacity for this:
				points_earned_mesh:setAlpha(0.5)
				-- Add it to the scene, and add an event listener so we can animate it:
				misc_3d_layer:addChild(points_earned_mesh)
				points_earned_mesh:addEventListener(Event.ENTER_FRAME, text_3d_enter_frame, points_earned_mesh)
				-- Make the next asteroid the player destroys worth double the points:
				asteroid_points = asteroid_points * 2
				-- Little badda boom:
				explosion_sound_player = asteroid_explosion_sound:play(0, false, false)
				explosion_sound_player:setVolume(0.5)
				-- Don't let one missile destroy multiple asteroids:
				missile.fired = nil
				last_missile_z = nil
				if missile:getParent() then
					missile:getParent():removeChild(missile)
				end
				-- remove the asteroid
				asteroid.active = nil
				asteroid:removeFromParent()
				-- Make some asteroid fragments:
				for i = 1, 50 do
					-- Make a 3D mesh:
					local frag = Mesh.new(true)
					-- Pick a left and top point in the asteroid texture:
					local l = math.random(0, asteroid_texture:getWidth() - 100)
					local t = math.random(0, asteroid_texture:getHeight() - 100)
					-- And right and bottom points relative to those:
					local r = l + math.random(20, 50)
					local b = t + math.random(20, 50)
					-- Make a bitmap from that area of the asteroid texture:
					local bmp = Bitmap.new(TextureRegion.new(asteroid_texture, l, t, r, b))
					-- Center it for easy 3D rotation:
					bmp:setAnchorPoint(0.5, 0.5, 0.5)
					-- Add the bitmap to the mesh:
					frag:addChild(bmp)
					-- Give the fragment random size, rotational speed, intial rotation, and velocity on each axis:
					frag:setScale(math.random(40, 100) * 0.00005)
					frag.rot_xs = math.random(-2, 2)
					frag.rot_ys = math.random(-2, 2)
					frag.rot_zs = math.random(-2, 2)
					frag.rx = math.random(0, 360)
					frag.ry = math.random(0, 360)
					frag.rz = math.random(0, 360)
					frag.vx = math.random(-200, 200) * 0.01
					frag.vy = math.random(-200, 200) * 0.01
					frag.vz = math.random(-200, 200) * 0.01
					-- Give the fragment a limited life, in frames:
					frag.life = math.random(60, 180)
					-- Start the fragment where the asteroid used to be:
					frag:setPosition(x, y, z)
					asteroid_layer:addChild(frag)
					-- Add an event listener so the fragment can get animated:
					frag:addEventListener(Event.ENTER_FRAME, frag_enter_frame, frag)
				end -- of loop to create fragments
			end -- of if a missile hit this asteroid
		end -- of the missile passed through the Z zone of this asteroid
	end -- of if we have a missile in flight

	-- If an asteroid has moved well behind the ship, we won't see it again, and we can get rid of it:
	-- Note we could use z < cam_y to get rid of them sooner, except for the cinematic opening where we
	-- look at the ship from ahead of it.
	if z > 500 and asteroid:getParent() == asteroid_layer then
		asteroid.active = nil
		asteroid_layer:removeChild(asteroid)
	end
end -- of asteroid_enter_frame()

-- Function to format a number with commas, for showing the score:
function comma_value(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
		  break
		end
	end
	return formatted
end

-- Function to create an asteroid
function add_asteroid(danger_zone, random_z)
	-- Build the mesh from the obj file:
	local asteroid = loadObj(".", "asteroid.obj")
	asteroid.active = true
	-- Give it a random position:
	local x = math.random(-global_move_x_range * 10, global_move_x_range * 10)
	local y = math.random(-global_move_y_range * 10, global_move_y_range * 10)
	-- Start it far ahead of the ship:
	local z = -5000
	-- Do we want this one to be dangerous to the ship?
	if danger_zone then
		asteroid.in_danger_zone = true
		-- Yes, so pick a location near the path of the ship:
		x = math.random(-global_move_x_range * 2, global_move_x_range * 2)
		y = math.random(-global_move_y_range * 2, global_move_y_range * 2)
	else
		-- No, make it safe. Pick new locations until we have one that can't hit the ship:
		while x > -global_move_x_range * 2 and x < global_move_x_range * 2 and
			y > -global_move_y_range * 2 and y < global_move_y_range * 2 do
			x = math.random(-global_move_x_range * 10, global_move_x_range * 10)
			y = math.random(-global_move_y_range * 10, global_move_y_range * 10)
		end
	end
	-- For the cinematic start, we want asteroids at various positions on the Z axis:
	if random_z then
		z = math.random(-5000, 0)
	end
	-- Position the asteroid:
	asteroid:setPosition(x, y, z)
	-- Add an event listener for animation and collision detection:
	asteroid:addEventListener(Event.ENTER_FRAME, asteroid_enter_frame, asteroid)
	-- Pick a size for the asteroid:
	asteroid.radius = math.random(15, 20)
	asteroid:setScale(asteroid.radius, asteroid.radius, asteroid.radius)
	-- Add it to the asteroid layer of the scene:
	asteroid_layer:addChild(asteroid)
	-- Give it a random rotation speed on each axis:
	asteroid.rot_xs = math.random(-2, 2)
	asteroid.rot_ys = math.random(-2, 2)
	asteroid.rot_zs = math.random(-2, 2)
	-- And a random starting rotation:
	asteroid.rot_x = math.random(0, 360)
	asteroid.rot_y = math.random(0, 360)
	asteroid.rot_z = math.random(0, 360)
	-- Start it invisibile and we'll fade it in over time:
	asteroid.alpha = 0
	asteroid:setAlpha(asteroid.alpha)
end -- of add_asteroid()

-- Function to set initial values for game play and reset things after ship is destroyed:
function start_game()
	-- This includes cleaning up remnants of the last game played, if any.
	-- First clean up the scene:
	-- Remove all the asteroids so we start with new ones:
	while asteroid_layer:getNumChildren() > 0 do
		asteroid_layer:removeChildAt(1)
	end
	-- Remove all leftover objects from the scene - could be ship fragments, score text, etc:
	while misc_3d_layer:getNumChildren() > 0 do
		misc_3d_layer:removeChildAt(1)
	end
	-- Get rid of the missile if there is one, in case its a child of the ship:
	if missile then
		if missile:getParent() then
			missile:getParent():removeChild(missile)
		end
	end
	-- Stop the sound of loading a new missile if we're playing it:
	if missile_prep_sound_player then
		missile_prep_sound_player:stop()
	end
	-- Reset the missile launcher:
	missile_launcher_status = MISSILE_WAITING
	missile_launcher_progress = 0

	-- Now start setting things up for a new game:
	misc_3d_layer:addChild(ship)
	-- Add new asteroids, not in a dangerous position, and scattered on the Z axis for the
	-- cinematic opening:
	for i = 1, 30 do
		add_asteroid(false, true)
	end
	-- Restart the camera transition for the cinematic opening:
	cam_transition = 0
	-- No collisions yet this game:
	collided = nil
	frames_since_collision = nil
	-- No score yet:
	score = 0
	-- Set the value of the first asteroid the player destroys:
	asteroid_points = 10000
	-- Recenter the ship:
	ship_loc.x = 0
	ship_loc.y = 0
	ship_loc.z = 0
	ship:setPosition(ship_loc.x, ship_loc.y, ship_loc.z)
	-- Start slow again:
	ship_speed = initial_ship_speed
	-- Start with relatively few asteroids:
	frames_per_asteroid = 20
	-- Restart the frame counter:
	frame_count = 0
	-- Start your engines:
	engine_sound_player = engine_sound:play(0, true, false)
	-- But the camera will be relative far from the ship, so start the at a low volume:
	engine_sound_player:setVolume(0.01)
end -- of start_game()

-- function to animate missiles:
function on_missile_enter_frame(missile)
	-- Only animate active missiles:
	if missile.fired then
		-- Get the position of the missile:
		local x, y, z = missile:getPosition()
		-- Keep track of where the missile was last frame, so we can determine the space it travels through each frame:
		last_missile_x, last_missile_y, last_missile_z = x, y, z
		-- Up the missile position based on its speed and the speed at which we're moving through space:
		z = z - missile_speed
		missile:setPosition(x, y, z)
		-- Speed up the missile with each frame:
		missile_speed = missile_speed + 0.2
		-- Store the current missile position for collision detection:
		missile_x = x
		missile_y = y
		missile_z = z
		-- Animate the missile flames if it has them:
		if missile_flames then
			-- Rotate them around randomly:
			missile_flames:setRotation(math.random(0,360))
			-- And make them vay in length randomly:
			local scale = math.random(50,100) * 0.1
			missile_flames:setScale(2, 2, scale)
		end	
		-- Spin the missile as it flies:
		missile:setRotation(frame_count * 5)
		-- Has the missile traveled very far away?
		if z < -5000 then
			-- Yes. Get rid of this missile:
			if missile:getParent() then
				missile:getParent():removeChild(missile)
			end
			missile.status = nil
		end
	end -- of dealing with an active missile
end -- of on_missile_enter_frame()

-- Function for general per-frame work:
function on_enter_frame()
	-- Update on-screen text if any:
	if screen_text then
		-- Text may have a limited life span:
		if text_life then
			text_life = text_life - 1
			if text_life <= 0 then
				screen_text:removeFromParent()
			end
		end
		-- Text may be fading in:
		if text_alpha < 1 then
			text_alpha = text_alpha + 0.1
			screen_text:setAlpha(text_alpha)
		end
	end

	-- If the player is streering right now
	if steering_ship then
		-- We stored the position of their touch/move. Copy those for easy reference:
		local x = steering_x
		local y = steering_y
		if x and y then
			-- Calculate where the ship would be with this steering input:
			local new_x = ((x / SCREEN_WIDTH) - 0.5) * global_move_x_range
			local new_y = 0 - ((y / SCREEN_HEIGHT) - 0.5) * global_move_y_range 
			-- But don't just jump the ship there. Do so gradually:
			local smoothing_factor = 25
			ship_loc.x = (ship_loc.x * smoothing_factor + new_x) / (smoothing_factor + 1)
			ship_loc.y = (ship_loc.y * smoothing_factor + new_y) / (smoothing_factor + 1)
			ship:setPosition(ship_loc.x, ship_loc.y, ship_loc.z)
		end -- of if we have steering values
	end -- of if steering

	-- Update the missile launcher progress, unless the ship has been destroyed:
	if not collided then
		if missile_launcher_status == MISSILE_LOADING then
			-- Fast progress for loading the missile:
			missile_launcher_progress = math.min(1, missile_launcher_progress + 0.1)
		elseif missile_launcher_status == MISSILE_ROTATING then
			-- medium fast progress for rotating the missile:
			missile_launcher_progress = math.min(1, missile_launcher_progress + 0.03)
		elseif missile_launcher_status ~= MISSILE_READY then
			-- Normal progress:
			missile_launcher_progress = math.min(1, missile_launcher_progress + 0.01)
		-- Else - No progress for ready status (nothing to do.)			
		end
	end

	-- See if we've finished a phase of missile launcher function:
	if missile_launcher_progress ~= nil then
		if missile_launcher_progress >= 1 then
			-- We're done with this state. Move on to the next.
			missile_launcher_status = missile_launcher_status + 1
			if missile_launcher_status > MISSILE_WAITING then
				-- We're done waiting between missiles. We can create a new one:
				missile = loadObj(".", "missile.obj")
				-- And start loading it:
				missile_launcher_status = MISSILE_LOADING
				-- Play the sound looping, not paused:
				missile_prep_sound_player = missile_prep_sound:play(0, true, false)
				-- Scale it to a reasonable size:
				missile:setScale(0.5, 0.5, 0.5)
				-- Make it a child of the ship, to it moves with the ship:
				ship:addChild(missile)
				-- Rotate it to face the back of the ship where it will come out:
				setRotationZXYOrder(missile, 180, 0, 0)
				-- Position it inside the ship. We'll animate it coming out:
				missile:setPosition(0,0.5,-1)
			end
			-- We're in a new state of missile prep. Start the progress for this phase:
			missile_launcher_progress = 0
			-- Did we finish the loading phase?
			if missile_launcher_status == MISSILE_READY then
				-- Yes, so stop that sound (it loops.)
				missile_prep_sound_player:stop()
				-- And play a sound of the loading process ending:
				missile_loaded:play(0)
			end
		end
	end
	
	-- Animate the missile during prep:
	if missile_launcher_status == MISSILE_LOADING then
		-- Slide it out the back of the ship:
		missile:setPosition(0,0.5,-1 + missile_launcher_progress * 4.5)
	elseif missile_launcher_status == MISSILE_ROTATING then
		-- Rotate it to face forwards:
		setRotationZXYOrder(missile, 180 - (180 * missile_launcher_progress), 0, 0)
		-- And raise it so it ends up at the top of the ship:
		missile:setPosition(0,0.5 + missile_launcher_progress * 1.5,-1 + 4.5)
	end

	-- Every so often, ramp up the rate at which we add new asteroids:
	if frame_count % 500 == 0 then
		frames_per_asteroid = frames_per_asteroid - 1
	end

	-- Are we doing a cinematic opening:
	if cam_transition then
		-- Transition between the initial camera view and the game-play view:
		cam_transition = math.min(1, cam_transition + 0.01)
		cam_x = flying_cam_x * cam_transition + start_cam_x * (1 - cam_transition)
		cam_y = flying_cam_y * cam_transition + start_cam_y * (1 - cam_transition)
		cam_z = flying_cam_z * cam_transition + start_cam_z * (1 - cam_transition)
		-- Adjust the volume of the engine sound as the camera moves closer to the ship:
		engine_sound_player:setVolume(1 * cam_transition)
		-- In case the missile launcher prep sound is playing, adjust the volume so
		-- it gets louder as we get closer:
		if missile_prep_sound_player then
			missile_prep_sound_player:setVolume(cam_transition)
		end
		-- Once the opening in done,
		if cam_transition >= 1 then
			if not score_text then
				-- Show the score on the top left of the screen:
				score_text = TextField.new(score_font, comma_value(score))
				score_text:setPosition(20, 65)
				score_text:setTextColor(0xFFFF00)				
				stage:addChild(score_text)
			else
				score_text:setText(comma_value(score))
			end
		end
	end

	-- We might have had a recent explosion that flashes the whole screen:
	if flash_frames then
		-- Shift from full brightness to zero over the course of max_flash_frames:
		local brightness = flash_frames / max_flash_frames
		-- Set the background color (red and green) based on the flash, leaving the blue at 0,
		-- so the blackness of space becomes bright yellow at the peak of the flash:
		stage:setBackgroundColor(brightness, brightness, 0)
		
		flash_frames = flash_frames - 1
		
		if flash_frames <= 0 then
			-- Done flashing - back to normal black background:
			flash_frames = nil			
			stage:setBackgroundColor(0, 0, 0)
		end
	end
	
	-- Did the ship get destroyed?
	if frames_since_collision then
		-- Keep track of how long it's been since the ship was destroyed:
		frames_since_collision = frames_since_collision + 1
		
		-- Show the player score after a few seconds:
		if frames_since_collision == 150 then
			screen_text = TextField.new(message_font, "Score: " .. comma_value(score))
			screen_text:setPosition((SCREEN_WIDTH - screen_text:getWidth()) / 2, (SCREEN_HEIGHT - screen_text:getHeight()) / 2)
			screen_text:setTextColor(0x00AAFF)
			
			stage:addChild(screen_text)
			
			-- We'll fade the text in over time:
			text_alpha = 0
			text_life = 200
		end

		-- Reset the game after a few more seconds:
		if frames_since_collision == 500 then
			-- The ship was removed from the scene when it was destroyed. Put it back:
			misc_3d_layer:addChild(ship)
			
			-- Clear the score text from the screen:
			if screen_text and screen_text:getParent() then
				screen_text:removeFromParent()
			end
			
			-- Reset all the game factors:
			start_game()
			
		end
	else
		-- Give the player some points just for staying alive:
		score = score + 10
	end

	-- Did the ship hit an asteroid, and is it still in the scene?
	if collided and ship:getParent() == misc_3d_layer then

		-- Make the background flash bright yellow and fade to black in a few seconds:
		max_flash_frames = 30
		flash_frames = max_flash_frames
		
		-- Track how long it has been since the ship was destroyed, for showing the score and
		-- resetting the game after a while:
		frames_since_collision = 0
		
		-- Blow up the ship. First remove it from the scene:
		misc_3d_layer:removeChild(ship)
		
		-- Now replace it with a bunch of fragments of the ship:
		for i = 1, 500 do
			-- Make a new fragment as a 3D mesh:
			local frag = Mesh.new(true)
			-- Pick top, left, bottom and right coorinates in the ship texture:
			local l = math.random(0, ship_texture:getWidth() - 100)
			local t = math.random(0, ship_texture:getHeight() - 100)
			local r = l + math.random(20, 50)
			local b = t + math.random(20, 50)
			
			-- Make a bitmap with that portion of the ship texture:
			local bmp = Bitmap.new(TextureRegion.new(ship_texture, l, t, r, b))
			
			-- We'll be rotating and moving this fragment. Do that around its center:
			bmp:setAnchorPoint(0.5, 0.5, 0.5)
			
			-- Add the image to the 3D mesh:
			frag:addChild(bmp)
			
			-- Size it randomly:
			frag:setScale(math.random(40, 100) * 0.00005)
			
			-- Give the fragment a random speed, rotation, and rotation speed on each axis:
			frag.rot_xs = math.random(-2, 2)
			frag.rot_ys = math.random(-2, 2)
			frag.rot_zs = math.random(-2, 2)
			frag.rx = math.random(0, 360)
			frag.ry = math.random(0, 360)
			frag.rz = math.random(0, 360)
			frag.vx = math.random(-200, 200) * 0.001 -- 0.01
			frag.vy = math.random(-200, 200) * 0.001
			frag.vz = math.random(-200, 200) * 0.001
			
			-- Give the fragment a limited life:
			frag.life = math.random(60, 180)
			
			-- Start the fragment where the ship used to be, and add it to the scene:
			frag:setPosition(ship_loc.x, ship_loc.y, ship_loc.z)
			misc_3d_layer:addChild(frag)
			
			-- Add an event listener so we can animate the fragment:
			frag:addEventListener(Event.ENTER_FRAME, frag_enter_frame, frag)
		end -- of loop to create fragments
	end -- of if the ship hit an asteroid
	
	-- Is it time to add an asteroid to the scene?
	if frame_count % frames_per_asteroid == 0 then
		-- Yes. Add one. 40 percent chance of asteroid being in danger zone.
		-- 2nd parameter is false - don't want them scattered on the Z axis, just X and Y.
		add_asteroid(math.random(1, 100) < 40, false)
	end
	
	-- Speed up over time to increase difficulty:
	ship_speed = ship_speed + 0.004	
	
	-- Add rings trailing behind the engines, if the ship hasn't been destroyed:
	if not collided then
	
		-- Loop to add one ring for the left engine and one for the right:
		for lr = 1, 2 do
			-- Create a 3D mesh for the ring:
			local ring = Mesh.new(true)
			
			-- Add a ring bitmap, centered in the mesh:
			local bmp = Bitmap.new(ring_texture)
			bmp:setAnchorPoint(0.5, 0.5, 0.5)
			ring:addChild(bmp)
			
			-- Start it at zero size and we'll make it grow over time:
			ring.scale = 0
			ring:setScale(ring.scale, ring.scale, ring.scale)
			
			-- Position the ring behind the appropriate engine of the ship:
			if lr == 1 then
				ring:setPosition(ship_loc.x - 4, ship_loc.y - 0.5, ship_loc.z + 3)
			else
				ring:setPosition(ship_loc.x + 4, ship_loc.y - 0.5, ship_loc.z + 3)
			end
			
			-- Add the ring to the scene:
			trail_layer:addChildAt(ring, 1)
			
			-- Add an event listener so we can animate the ring:
			ring:addEventListener(Event.ENTER_FRAME, ring_enter_frame, ring)
			
			-- Start the ring fully opaque, and we'll fade it out later:
			ring.alpha = 1
		end -- of loop for left and right engines
	end -- of if the ship hasn't been destroyed

	-- Position the camera each frame:
	viewport:lookAt(
		cam_x, cam_y, cam_z,
		-- Look at a point halfway between the ship and the origin on X and Y, 
		-- so we see the ship to the left/right/up/down from the camera, and get
		-- to see it from a varying perspective:
		-- This may make things a bit disorienting for the player, but that can be
		-- a good thing, making the player have to constantly judge whether an
		-- asteroid is a danger to them or not.
		ship_loc.x / 2, ship_loc.y / 2, 0, -- Look at the center of the landscape
		0, 1, 0)

	-- Keep track of the passage of time:
	frame_count = frame_count + 1
	
end -- of on_enter_frame()


-- Call on_enter_frame once per frame:
scene_3d:addEventListener(Event.ENTER_FRAME, on_enter_frame)

-- All done with functions. Set things up for a new game:
start_game()

-- Show the player some instructions:
screen_text = TextField.new(message_font, "Touch edges to steer.\nTouch center to launch missile.")
screen_text:setPosition((SCREEN_WIDTH - screen_text:getWidth()) / 2, (SCREEN_HEIGHT - screen_text:getHeight()) * 0.3)
stage:addChild(screen_text)

-- Start with invisible text and we'll fade in over time:
text_alpha = 0

-- We'll remove the text after a number of frames:
text_life = 150

-- We don't want black (default) text over a black scene. Use light colored text:
screen_text:setTextColor(0x00AAFF)
