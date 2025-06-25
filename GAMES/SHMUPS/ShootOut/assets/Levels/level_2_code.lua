Level_2 = Core.class(Sprite)

function Level_2:init()

w = application:getContentWidth()
h = application:getContentHeight()
application:setBackgroundColor(0)

local track = Sound.new("sound/soundtrack/song2.mp3")
local stars = Particles.new()
local damage = Damage.new()
local ship = Ship.new(damage)
local gears = {}
local gears2 = {}

stars:setPosition(0, -(w/2))
self:addChild(stars)
self:addChild(ship)
self:addChild(damage)
track:play(0, true, false)

frame = 0
timeline = 0
timeline2 = 0
enterInAction = 50
gearQuantity = 1
gear2Quantity = 1
kickoff = false
notAglomerate = false
function onEnterFrame(event)

	frame += 1
	timeline += 1
	timeline2 += 1
	
	gears = {
		Gear.new(ship),
		Gear.new(ship),
		Gear.new(ship),
		Gear.new(ship),
		Gear.new(ship),
	}
	gears2 = {
		Boss1.new(ship, false),
		Boss1.new(ship, false),
	}
	
	for i=1, #gears2 do
		gears2[i]:setColorTransform(math.random(1,2), math.random(1,2),math.random(1,2),1)
	end
	
	for i=1, #gears do 
		gears[i]:setColorTransform(math.random(1,2), math.random(1,2), math.random(1,2), 1)
	end
	
	if frame > 3 then
		stars:addParticles(
		{
			{x=math.random(w),
			 y=0,
			 size=5,
			 ttl=1000,
			 speedX=0,
			 speedY=math.random(),
			 --decay=0.9
			}	
		})
		frame = 0
	end
	
	if not notAglomerate then
		if timeline == enterInAction then
			self:addChild(gears[gearQuantity])
			gearQuantity+=1
			if not kickoff then
				enterInAction*=2
				kickoff = true
			end
			enterInAction*=2
			
			if gearQuantity == 5 then
				enterInAction = 100
				timeline = 0
				gearQuantity = 1
			end
		end
	end
	
	if timeline2 == 1000 then
		self:addChild(gears2[1])
		local items = Items.new(ship, 1)
		self:addChild(items)
		notAglomerate = true
	end
	
	if timeline2 == 2000  then
		items = Items.new(ship, 2)
		self:addChild(items)
		notAglomerate = false
		timeline = 0
	end
	
	if timeline2 == 4000 then
		self:addChild(gears2[2])
		items = Items.new(ship, 1)
		self:addChild(items)
	end
	
	if timeline2 == 7000 then
		items = Items.new(ship, 3)
		self:addChild(items)
	end
	
	if timeline2 == 7600 then
		notAglomerate = true
	end
	
	if timeline2 == 8000 then
		local boss2 = Boss2.new(ship)
		self:addChild(boss2)
	end
end

self:addEventListener(Event.ENTER_FRAME, onEnterFrame)

end