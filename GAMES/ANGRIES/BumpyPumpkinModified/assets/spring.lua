--include box2d library
require "box2d"

CreateSpring = gideros.class(Sprite)

function CreateSpring:init()
	local x = math.random(200, 500)
	spring = Bitmap.new(Texture.new("images/Springs.png"));
	spring:setPosition(x, 200);
	stage:addChild(spring);
	--print("Hiiiiiiii " .. spring:getX())
	--print(spring:getWidth()/2)
	
	springTop = Bitmap.new(Texture.new("images/SpringTOp.png"));
	springTop:setPosition(x - 14, 180);
	stage:addChild(springTop);
	--print(springTop:getWidth()/2)
	
	spring:setScaleY(20)
end