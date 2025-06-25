ItemPool = gideros.class(Sprite)

--static variable
local lw = application:getLogicalWidth()
local lh = application:getLogicalHeight()
local MinX = -application:getLogicalTranslateX() / application:getLogicalScaleX()
local MinY = -application:getLogicalTranslateY() / application:getLogicalScaleY()
local MaxX,MaxY = lw - MinX,lh - MinY;
local W, H = MaxX - MinX, MaxY - MinY;
local CenterX,CenterY = MinX + W/2, MinY + H/2

local math_random = math.random;
local event_item_out_of_screen = "item_out_of_screen";
local event_item_collision = "item_collision";

function ItemPool:init(params)
	-- body
	self.pool_size = params.pool_size or 20;

	self.moveSpeed = params.moveSpeed or 100;
	self.itemW = params.itemW or 40;
	self.itemH = params.itemH or 40;

	self.minDistanceX = params.minDistanceX or 45;
	self.minDistanceY = params.minDistanceY or 45;
	self.lastPosX = MinX;
	self.lastPosY = MinY;

	self.item_list = {};
	for i=1,self.pool_size do
		self.item_list[i] = self:createNewItem({w = self.itemW, h = self.itemH});
	end
end

function ItemPool:ItemOutOfScreen(event)
	-- body
	local id = event:getTarget().id;
	self:removeItem(id);
end

local ColorArray = {0xffffff,0xe37f26,0xedc41b,0x0d9e84,0x1f7ebb,0xf03b66,0xd04a9f};
function ItemPool:createNewItem(params)
	local item = Item.new(ColorArray[math_random(1,#ColorArray)],params.w,params.h);
	item.id = os.timer();
	item:addEventListener(event_item_out_of_screen,self.ItemOutOfScreen,self)
	self:makeRandomPosition(item)
	self:addChild(item)
	return item;
end

function ItemPool:removeItem(id)
	-- body
	for i=1,#self.item_list do
		if self.item_list[i] and self.item_list[i].id == id then
			self.item_list[i]:removeEventListener(event_item_out_of_screen,self.ItemOutOfScreen,self)
			self.item_list[i]:removeFromParent();
			print( "remove item", self.item_list[i].id )
			table.remove(self.item_list, i);
			table.insert(self.item_list,1,self:createNewItem({w = self.itemW, h = self.itemH}));
		end
	end	
end

function ItemPool:makeRandomPosition(item)
	-- body
	local px = math_random(MinX + self.itemW,MaxX - self.itemW)
	local py = self.lastPosY - self.minDistanceY - math_random(1, self.itemH)
	item:setPosition(px,py);
	self.lastPosX,self.lastPosY = px,py;
end

function ItemPool:update(deltaTime)
	-- body
	--print(#self.item_list)
	for i=1,#self.item_list do
		if self.item_list[i] then
			self.item_list[i]:update(deltaTime,self.moveSpeed);
		end
	end
end
