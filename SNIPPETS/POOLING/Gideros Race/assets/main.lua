--[[local fondos = {}

local fondo = bg.new("level/images/banquina_down.png")
stage:addChild(fondo)
table.insert(fondos, fondo)

local fondo1 = bg.new("level/images/banquina_down.png")
fondo1:setY(480 - fondo1:getHeight())
stage:addChild(fondo1)
table.insert(fondos, fondo1)

for _, v in ipairs(fondos) do
	v:setSpeed(15)
end

table.remove(fondos, 1)

print(fondos[1])
print(fondos[2])]]

local thepool = Pool.new()
local enemies = {}

local t = 0
local delay = 60

function crearenemigo()
	local enemigo = thepool:createObject("enemies")
	stage:addChild(enemigo)
	enemigo:start(0)
	if not enemigo.id then
		enemigo.id = #enemies
	end
	enemies[enemigo.id] = enemigo
	print(enemigo.id)
end

crearenemigo()

function onEnterFrame()
	--[[for _,v in ipairs(fondos) do
		v:update()
	end
	
	t = t + 1
	if t >= delay then	
		crearenemigo()
		t = 0
	end
	
	]]
	for i,e in pairs(enemies) do
          if e ~= "dead" then
			
            if e.destroy then --just check if there is a destroy property in your object
                enemies[i] = "dead" --or actors[i] = nil to remove the entry from actors table.
                thepool:destroyObject(e, e.destroy)
				crearenemigo()
				--print("asdasd")
            else
                e:update()
            end
         end
     end
	
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)



