--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Localize class provides localization support for gideros, 
 * by loading string constants from specific files based on user locale.
 * This class also has function, that allows string formating printf style, 
 * and dynamic loading of language specific images (images with texts).
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Localization-in-Gideros
**************************************************************
]]--

require "json"

--module("Localize", package.seeall)
Localize = {}

--public properties
Localize.path = "locales"
Localize.filetype = "lua"

--local properties
local locale
local file
local data = {}

function reset()
	data = {}
	--initialziation
	if Localize.filetype == "lua" then
		file = loadfile(Localize.path.."/"..locale.."."..Localize.filetype)
		if file then
			data = assert(file)()
			print("locale:", locale)
		end
	elseif Localize.filetype == "json" then
		file = io.open(path.."/"..locale.."."..Localize.filetype, "r")
		if file then
			data = Json.Decode(file:read( "*a" ))
		end
	end
end

function Localize.changeLocale(l)
	locale = l
	reset()
end

--public method for overriding methods
function Localize.load(object, func, indeces)
	if object ~= nil and object[func] ~= nil and object.__LCfunc == nil then
		object.__LCfunc = object[func]
		object[func] = function(...)
			local arg = {...}
			local index
			if type(indeces) == "table" then
				for i = 1, #indeces do
					local index = indeces[i]
					arg[index] = data[arg[index]] or arg[index]
				end
			else
				arg[indeces] = data[arg[indeces]] or arg[indeces]
			end
			return object.__LCfunc(unpack(arg))
		end
	end
end

--overriding native objects
Localize.load(string, "format", {1,2})
Localize.load(TextField, "__new", 2)
Localize.load(Texture, "__new", 1)
Localize.load(AlertDialog, "__new", {1, 2, 3, 4, 5})
Localize.load(TextInputDialog, "__new", {1, 2, 3, 4, 5, 6})
