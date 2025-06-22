Bag=Core.class()
	
function Bag:init()
	self.contents={}
end

function Bag:add(object)
	local tally=self.contents[object] or 0
	self.contents[object]=tally+1
end

function Bag:remove(object)
	local tally=self.contents[object]
	assert(tally and tally>0)
	tally=tally-1
	if tally==0 then tally=nil end
	self.contents[object]=tally
end

function Bag:getTally(object)
	return self.contents[object] or 0
end
