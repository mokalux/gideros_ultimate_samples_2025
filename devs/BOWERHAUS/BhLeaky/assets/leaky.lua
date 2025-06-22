--[[ 
leaky.lua

Memory leak instrumentation for Gideros

WARNING. EXCLUDE THIS FILE FROM YOUR PROJECT BEFORE DEPLOYMENT TO AVOID ANY
UNWANTED PERFORMANCE HIT!!
 
MIT License
Copyright (C) 2012. Andy Bower, Bowerhaus LLP

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

EventDispatcher._allObjectsBag=Bag.new()

function EventDispatcher:postInit()
	EventDispatcher._allObjectsBag:add(self.class)
	self._proxy = newproxy(true)
	getmetatable(self._proxy).__gc = function() self:_destroy() end
end

function EventDispatcher:_destroy()
	EventDispatcher._allObjectsBag:remove(self.class)
end

function EventDispatcher.printAllInstances(tag)
	print("*** OBJECT SNAPSHOT", tag or os.date("%c"), "***")
	for class, tally in pairs(EventDispatcher._allObjectsBag.contents) do
		print(string.format("%s has %d instances", getClassName(class), tally))
	end
	print("*** OBJECT SNAPSHOT END ****")
end