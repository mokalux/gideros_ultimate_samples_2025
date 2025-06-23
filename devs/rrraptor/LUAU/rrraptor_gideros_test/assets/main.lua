--!strict

local function canJump(xplayable : {age: number, isonground: boolean}) : boolean
	if xplayable.isonground then return true end
	return false
end

local adog = {}
adog.age = 4
adog.isonground = false

local acat = {}
acat.age = 8
acat.isonground = true
acat.lives = 7 -- bug :-)

print(canJump(adog), canJump(acat))

local name : string
local age : number

name = "mac doe"
age = 22

print(name, age)
