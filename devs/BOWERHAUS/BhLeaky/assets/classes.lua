--[[ 
classes.lua

Modified Gideros class (OOP) system.
Mods by Andy Bower, Bowerhaus LLP

This is a slightly modified version of the Gideros class system that was published by Atilim Cetin
in this forum thread:

http://www.giderosmobile.com/forum/discussion/comment/19237#Comment_19237

Although version 2012.09.7 of Gideros includes support for the postInit() function there are a couple
of omissions from the code discussed in the above thread. This file includes the following changes:

1) All objects have a .class field that points to their class object (table)

2) All objects have a .super field that points to their superclass obect (table)

3) A global "god" class called Object is provided as a proposed root of all other classes. 
However, at the time of writing it doesn't seem possible to make EventDispatcher descend
from this so it's inclusion here is probably of limited use.

You should be able to include this "classes.lua" file in your project without affecting the operation
of the built-in Gideros classes. However, you shoul try and ensure that it gets loaded before any
other class based code is run. To do this, turn "Exclude from Execution" on and then require "classes"
in your init.lua. If everything is working okay, you should see a console message 
"MODIFIED classes.lua INITIALISED" printed once only.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

Core = {}
 
Core.class = function (b)
    local c = {}
    c.__index = c
    setmetatable(c, b)    
 
    c.super = b
    c.class=c
 
    local __new
 
    if b == nil then
        __new = function(...)
            local s1 = {}
 
            setmetatable(s1, c)
 
            local init = rawget(c, "init")
            if type(init) == "function" then
                init(s1, ...)
            end
 
            return s1        
        end
    else
        __new = function(...)
            local b = getmetatable(c)
 
            local s1 = (b.__new or b.new)(...)
 
            setmetatable(s1, c)
 
            local init = rawget(c, "init")
            if type(init) == "function" then
                init(s1, ...)
            end
 
            return s1
        end
    end
 
    c.__new = __new
 
    c.new = function(...)
        local s1 = __new(...)
 
        local postInit = s1["postInit"]
        if type(postInit) == "function" then
            postInit(s1, ...)
        end
 
        return s1            
    end    
 
    return c
end

Object=Core.class()

function getClassName(class)
	-- Answers a string name for a supplied class object.
	-- Note, this involves a sequential search through the global table so is 
	-- not particularly fast.
	--
	if class.__name then return class.__name end
	for k,v in pairs(_G) do
		if v==class then
			class.__name=k
			return k
		end
	end
end

print("MODIFIED classes.lua INITIALISED")