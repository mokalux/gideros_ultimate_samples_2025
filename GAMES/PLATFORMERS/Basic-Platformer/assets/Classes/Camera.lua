Camera = Core.class(Sprite)

function Camera:init(scene)

self.scene = scene

-- Set the distance for camera from top and left
self.cameraX = 220;
self.cameraY = 140;

end

function Camera:moveCameraTo(x,y)

-- move backgrounds the opposite way to x and y

x = x - self.cameraX
y = y - self.cameraY

-- Set the scrolling boundaries
if(x<0) then
x = 0
end

if(y<0) then
y = 0
end


self.scene.tilemap:setPosition(x*-1, y*-1)
self.scene.backgroundTiles:setPosition((x*-1)*.4, (y*-1)*.4)
self.scene.physicsLayer:setPosition(x*-1, y*-1)

--self.scene:setPosition(-x,-y)

local x,y = self.scene.hero.body:getPosition()

if(self.correctLeft) then
	self.correctLeft = false;
else



end

self.scene.patch = 0;

self.x = self:getX()
self.y = self:getY()


end