-- @4aiman
move=false



game = {}
game.cube = require("cubes")
game.map_loader = require("map_loader")
game.keys = {}


application:setBackgroundColor(0x808080)
--application:configureFrustum(60,500000)


cube = game.cube:new({size=200, x=400, y=300, z=000, textures={"box.png",nil,nil,nil,"box_top.png"}, sides={true,true,true,true,true,true}, colors={0xff0000,0x00ff00,0x0000ff,0xffff00,0xff00ff,0x00ffff,0xffffff,0x000000}}) -- 3D mesh
cube2 = game.cube:new({size=200, x=200, y=300, z=000, textures={"box.png",nil,nil,nil,"box_top.png"}, sides={true,true,true,true,true,true}, colors={0xff0000,0x00ff00,0x0000ff,0xffff00,0xff00ff,0x00ffff,0xffffff,0x000000}}) -- 3D mesh
cube3 = game.cube:new({size=200, x=600, y=300, z=000, textures={"box.png",nil,nil,nil,"box_top.png"}, sides={true,true,true,true,true,true}, colors={0xff0000,0x00ff00,0x0000ff,0xffff00,0xff00ff,0x00ffff,0xffffff,0x000000}}) -- 3D mesh
--texture =Texture.new("box.png")
--mesh:setTexture(texture)

--cube:set_visible(stage)
--cube2:set_visible(stage)
--cube3:set_visible(stage)


local textfield = TextField.new()
local camera = Viewport.new()

local map = game.map_loader:load_file("untitled.lua")
local map3d = game.map_loader:cuboid_level_create(map, 200)
camera:setContent(map3d.root)
xxx = 64*96 -- -3400
yyy = 0
zzz = 10037 -- 10800
rrr = 0 -- 70
--camera:setPosition(-3400,0,10800)
--camera:setRotationY(126)

textfield:setText("234")
textfield:setScale(2)
textfield:setPosition(50,50)

--cube.mesh:setRotationX(cube.mesh:getRotationX()-45)
--cube.mesh:setRotationY(cube.mesh:getRotationY()+25)

function update()
   if move then 
      --cube.mesh:setRotationY(cube.mesh:getRotationY()+0.5 )
      --cube.mesh:setRotationX(cube.mesh:getRotationX()+0.1 )
	  --stage:setRotationY(stage:getRotationY()+0.5 )
	  --local x, y, z = stage:getPosition()
	  --stage:setPosition(x, y, z+0.1)
   end 

   local rot = rrr
   if rot>360 then rot = 0 end
   if rot<0 then rot = 360 end
   --view1:setRotationY(rot-0.5 )

   local x, y, z = xxx, yyy, zzz --camera:getPosition()
   local rot = rrr -- in degrees
   textfield:setText("Position: " ..x.. ", "..y.. ", "..z.. "\n" ..
                     "Yaw: " .. rot)

   if game.keys[KeyCode.RIGHT] then
--      camera:setPosition()
      x=x-math.cos(^<rot)*5
	  y=y
	  z=z+math.sin(^<rot)*5
   end
   
   if game.keys[KeyCode.DOWN] then
      x=x-math.sin(^<rot)*5
	  y=y
	  z=z+math.cos(^<rot)*5
   end

   if game.keys[KeyCode.LEFT] then
      x=x+math.cos(^<rot)*5
	  y=y
	  z=z-math.sin(^<rot)*5
   end

   if game.keys[KeyCode.UP] then
      x=x+math.sin(^<rot)*5
	  y=y
	  z=z-math.cos(^<rot)*5
   end


   if game.keys[KeyCode.A] then	  
      rot=rot-0.5
   end

   if game.keys[KeyCode.Z] then
      rot=rot+0.5
   end
   
   --print("1", xxx,yyy,zzz,rrr,x,y,z,rot)
   --camera:setPosition(x,y,z)
   --camera:setRotationY(rot)
   --camera:setAnchorPosition(x,y,z)
   --x,y,z = camera:getPosition()
   --rot = camera:getRotationY()
   
   --print("2",xxx,yyy,zzz,rrr,x,y,z,rot)
   if game.keys[KeyCode.G] then
--      os.exit()
   end
   camera:lookAngles(xxx,yyy,zzz,0,-rrr,0)
   --view1:lookAt(xxx, yyy, zzz, x , y, z, 0, 1, 0)
   
   xxx,yyy,zzz,rrr=x,y,z,rot
end

function keyUp(event)
   local key, rc = event.keyCode, event.realCode
   game.keys[key] = false
   game.keys[rc] = false
end

function keyDown(event)
   local key, rc = event.keyCode, event.realCode
   -- why 2 codes IDK, since those are equal on US layout and key==0 on non-US layout
   game.keys[key] = true
   game.keys[rc] = true
   if key==KeyCode.SPACE then
      print("toggle")
      move = not move
   end
   
end


stage:addEventListener(Event.ENTER_FRAME,update)
stage:addEventListener(Event.KEY_DOWN,keyDown)
stage:addEventListener(Event.KEY_UP,keyUp)



-- content we want to display in multiple views
local content = Bitmap.new(Texture.new("box.png"))
-- add some transformations, just to see the difference
lsx,lsy,lsw,lsh=application:getLogicalBounds()
print(lsx,lsy,lsw,lsh)
local perspective=Matrix.new()
camera:setScale((lsw-lsx)/2,(lsh-lsy)/2)
camera:setPosition(lsx+(lsw-lsx)/2,lsy+(lsh-lsy)/2)
perspective:perspectiveProjection(60,-(lsw-lsx)/(lsh-lsy),0.1,50000)
camera:setProjection(perspective)
camera:lookAngles(xxx,yyy,zzz,0,-rrr,0)

-- add view to stage
stage:addChild(camera)


stage:addChild(textfield)
