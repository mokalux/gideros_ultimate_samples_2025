application:setBackgroundColor(0)

Intro = Core.class(Sprite)

function Intro:init()
w = application:getContentWidth()
h = application:getContentHeight()

local frame = 0
local stars = Particles.new()
stars:setPosition(0, -5)

self:addChild(stars)
local logo = Bitmap.new(Texture.new("game_management/intro_objects/game_logo.png"))
local pack = TexturePack.new("game_management/buttons/buttons.txt", "game_management/buttons/buttons.png", true)

local botaoStart = { 
		Bitmap.new(pack:getTextureRegion("play_1.PNG")),
		Bitmap.new(pack:getTextureRegion("play_2.PNG")),
	}
for i=1, #botaoStart do
	botaoStart[i]:setPosition(w/2, (h/2)+((h/2)/2))
	botaoStart[i]:setAnchorPoint(0.5,0.5)
end

local logo_game = MovieClip.new {
	{1, 64, logo, {alpha = {0.7, 1, "easeOut"}}},
	{64, 70, logo, {y = {0,30, "inBounce"}}},
	{70, 74, logo, {y = {30,-15, "outBounce"}}},
	{74, 78, logo, {y = {-15,0, "inBounce"}}},
	{64, 128, logo, {alpha = {1, 0.7, "easeIn"}}}, 
}
logo_game:setGotoAction(128, 1)
logo_game:setAnchorPoint(0.5,0.5)
logo_game:setPosition(w/2, (h/2)/2)
logo_game:setScale(0.8)
self:addChild(logo_game)

self.i = 1
self:addChild(botaoStart[self.i])

function onEnterFrame(event)

frame += 1
	if frame > 8 then
		stars:addParticles(
		{
			{x=math.random(w),
			 y=0,
			 size=5,
			 ttl=1000,
			 speedX=0,
			 speedY=math.random(),
			 --decay=0.9
			 color=math.random(46250, 64500)
			}	
		})
		frame = 0
	end
end

function onMouseDown(event)
	if botaoStart[self.i]:hitTestPoint(event.x, event.y) then
		self:removeChild(botaoStart[self.i])
		self.i = 2
		self:addChild(botaoStart[self.i])
	end
end
function onMouseUp(event)
	if self.i == 2 then
		if botaoStart[self.i]:hitTestPoint(event.x, event.y) then
			self:removeChild(botaoStart[self.i])
			self.i = 1
			self:addChild(botaoStart[self.i])
			
			Game:changeScene("level_1", 2, SceneManager.fade)
		end
	end
end

self:addEventListener(Event.MOUSE_DOWN, onMouseDown)
self:addEventListener(Event.MOUSE_UP, onMouseUp)
self:addEventListener(Event.ENTER_FRAME, onEnterFrame)

end
