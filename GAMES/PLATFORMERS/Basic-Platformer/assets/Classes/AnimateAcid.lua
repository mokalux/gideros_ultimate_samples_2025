AnimateAcid = Core.class(Sprite)


function AnimateAcid:init(scene)

	self.scene = scene;
	
	-- Store all acid frames in a table
	
	self.frames = {

	{x=10,y=20},
	{x=11,y=20},
	{x=12,y=20},
	{x=13,y=20},
	{x=14,y=20},
	{x=15,y=20},
	}
	
	self.frameCounter = 0;
	
	local timer = Timer.new(100);
	self.timer = timer;
	timer:addEventListener(Event.TIMER, self.animateTiles, self);

	--timer:addEventListener(Event.TIMER_COMPLETE,someFunction)
	timer:start();

end


-- Timer to change self.frames

function AnimateAcid:animateTiles()

	self.frameCounter = self.frameCounter + 1;

	-- For each tile that needs to be animated, change it to this frameCounter
	
	for key,value in pairs(self.scene.acidAnimTiles) do
		--print(self.scene.acidAnimTiles[key].x)
		self.scene.tilemap.animatedLayer:setTile(self.scene.acidAnimTiles[key].x,self.scene.acidAnimTiles[key].y,self.frames[self.frameCounter].x,self.frames[self.frameCounter].y)
	end



	--print(self.frames[self.frameCounter].x)
	
		--self.tilemap.animatedLayer:setTile()

	if(self.frameCounter == #self.frames) then
		self.frameCounter = 0;
	end

end




