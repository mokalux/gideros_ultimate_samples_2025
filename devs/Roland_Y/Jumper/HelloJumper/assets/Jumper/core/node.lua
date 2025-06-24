-- Internal Node Class
local Node = {}
Node.__index = Node

-- Custom initializer for nodes
function Node:new(x,y)
	return setmetatable({x = x, y = y}, Node)
end

-- Enables the use of operator '<' to compare nodes.
-- Will be used to sort a collection of nodes in a binary heap on the basis of their F-cost
function Node.__lt(A,B)
	return (A.f < B.f)
end

return Node
