require ("box2d")

stage:setOrientation(Stage.LANDSCAPE_LEFT)
world = b2.World.new(0, 9.8);

map = TiledMap.new("map01");
stage:addChild(map);

local shape = b2.PolygonShape.new();
shape:setAsBox(20, 32, 32, 32, 0);	

mover = Sprite.new();
mover.body = world:createBody { type = b2.DYNAMIC_BODY, fixedRotation = true };
mover.body:createFixture { shape = shape, density = 1, restitution = 0.1, friction = 1 };
mover.body:setPosition(120, 50);
stage:addChild(mover);

directions = { IDLE = "IDLE", LEFT = "LEFT", RIGHT = "RIGHT" };
direction = directions.IDLE;

stage:addEventListener(Event.ENTER_FRAME, function(event)    
		local x = 0;
		local y = 0;
		
		if(direction == directions.LEFT) then
			mover.body:applyForce(-32, 0, mover:getX(), mover:getY())
		elseif(direction == directions.RIGHT) then
			mover.body:applyForce(32, 0, mover:getX(), mover:getY())
		end
		
		--map:move(x, y);
		world:step(1 / 60, 8, 3);
		local x, y = mover.body:getPosition()
		stage:setX(application:getContentWidth()/2 - x)
	end
);

stage:addEventListener(Event.KEY_DOWN, function(event)    
	local key = event.keyCode -- print(key)
    if(key == 39) then direction = directions.RIGHT
	elseif(key == 38) then mover.body:applyLinearImpulse(0, -20, mover:getX(), mover:getY())
    elseif(key == 37) then direction = directions.LEFT
    end
end)

stage:addEventListener(Event.KEY_UP, function(event) direction = directions.IDLE end)
world:addEventListener(Event.BEGIN_CONTACT, function(event) end)
world:addEventListener(Event.END_CONTACT, function(event) end)

local debugDraw = b2.DebugDraw.new()
debugDraw:setFlags(b2.DebugDraw.SHAPE_BIT)
world:setDebugDraw(debugDraw)
stage:addChild(debugDraw)
