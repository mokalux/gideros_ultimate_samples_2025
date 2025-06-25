local scrW=1024
local scrH=768
application:setLogicalDimensions(scrH,scrW)
application:setScaleMode("fitWidth")
application:setOrientation(Application.LANDSCAPE_LEFT)
--font=Font.new("Font128.txt","Font128.png",true)
-- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~Â²Ã©Ã Ã§Ã¨Ã®Ã¹ÂµÃ¯Ã«Ã´â‚¬Â£Ã¢Ãª
font = TTFont.new("fonts/Kenney Space.ttf", 50)

local bg=Shape.new()
--bg:setFillStyle(Shape.TEXTURE, Texture.new("gfx/cat.jpg",true, {wrap = Texture.REPEAT}))
bg:setFillStyle(Shape.TEXTURE, Texture.new("gfx/cat.jpg",true))
bg:beginPath()
bg:moveTo(0,0)
bg:lineTo(scrW,0)
bg:lineTo(scrW,scrH)
bg:lineTo(0,scrH)
bg:lineTo(0,0)
bg:endPath()
stage:addChild(bg)

local txt="A long time ago, in a galaxy far, far away....\n\n\n\n"..
"It is a period of civil war. Rebel\n"..
"spaceships, striking from a hidden\n"..
"base, have won their first victory\n"..
"against the evil Galactic Empire.\n\n\n"..

"During the battle, rebel spies managed\n"..
"to steal secret plans to the Empire's\n"..
"ultimate weapon, the DEATH STAR, an\n"..
"armored space station with enough\n"..
"power to destroy an entire planet.\n\n\n"..

"Pursued by the Empire's sinister agents,\n"..
"Princess Leia races home aboard her\n"..
"starship, custodian of the stolen plans\n"..
"that can save her people and restore\n"..
"freedom to the galaxy....\n"..

"A long time ago, in a galaxy far, far away....\n\n\n\n"..
"It is a period of civil war. Rebel\n"..
"spaceships, striking from a hidden\n"..
"base, have won their first victory\n"..
"against the evil Galactic Empire.\n\n\n"..

"During the battle, rebel spies managed\n"..
"to steal secret plans to the Empire's\n"..
"ultimate weapon, the DEATH STAR, an\n"..
"armored space station with enough\n"..
"power to destroy an entire planet.\n\n\n"..

"Pursued by the Empire's sinister agents,\n"..
"Princess Leia races home aboard her\n"..
"starship, custodian of the stolen plans\n"..
"that can save her people and restore\n"..
"freedom to the galaxy....\n"

local textwidth=2500
local targetwidth=1024
local scrollspeed=0.4
textHolder=Sprite.new()
txtline=TextWrap.new(txt,textwidth,"center",10,font)
txtline:setScale(targetwidth/textwidth)
txtline:setTextColor(0xffff00)
txtline:setY(0)
textHolder:addChild(txtline)
textHolder:setY(targetwidth+50)
mesht=RenderTarget.new(targetwidth,targetwidth,true)
mesht:draw(textHolder)

textHolder:addEventListener(Event.ENTER_FRAME, function ()
	textHolder:setY(textHolder:getY()-scrollspeed)
	mesht:clear(0,0)
	mesht:draw(textHolder)	
end)

--mesh=StarWarsEffect.new(scrW,scrH-100,200,mesht,0.4)
--mesh:setPosition(0,100)
--stage:addChild(mesh)

--mesh=StarWarsEffect.new(768,400,200,mesht,1)
mesh=StarWarsEffect.new(scrW+64*2, scrH-64*4, 64*2, mesht, 0.2)
mesh:setPosition(0, 100)
stage:addChild(mesh)
--stage:addChild(textHolder)
