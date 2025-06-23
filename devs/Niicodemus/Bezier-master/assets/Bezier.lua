-- Bezier
-- https://github.com/nshafer/Bezier

-- The MIT License (MIT)

-- Copyright (c) 2013 Nathan Shafer

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

Bezier = Core.class(Shape)

function Bezier:init()
	self.points = {}
	self.autoStepScale = .1
end

function Bezier:getPoints()
	return self.points
end

function Bezier:setPoints(points)
	self.points = points
end

function Bezier:setAutoStepScale(scale)
	self.autoStepScale = scale
end

function Bezier:getAutoStepScale()
	return self.autoStepScale
end

function Bezier:pointDistance(p1, p2)
	local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	return math.sqrt(dx*dx + dy*dy)
end

function Bezier:getLength()
	local length = 0
	local last = nil
	
	for i,point in ipairs(self.points) do
		if last then
			length = length + self:pointDistance(point, last)
		end
		last = point
	end
	
	return(length)
end

function Bezier:draw(isClosed)
	self:beginPath()

	for i,point in ipairs(self.points) do
		self:lineTo(point.x, point.y)
	end

	if isClosed then self:closePath() end

	self:endPath()
end

-- Estimate number of steps based on the distance between each point/control
-- Inspired by http://antigrain.com/research/adaptive_bezier/
function Bezier:estimateSteps(p1, p2, p3, p4)
	local distance = 0
	if p1 and p2 then
		distance = distance + self:pointDistance(p1, p2)
	end
	if p2 and p3 then
		distance = distance + self:pointDistance(p2, p3)
	end
	if p3 and p4 then
		distance = distance + self:pointDistance(p3, p4)
	end

	return math.max(1, math.floor(distance * self.autoStepScale))
end

-- Bezier functions from Paul Bourke
-- http://paulbourke.net/geometry/bezier/
function Bezier:createQuadraticCurve(p1, p2, p3, steps)
	self.points = {}
	steps = steps or self:estimateSteps(p1, p2, p3)
	for i = 0, steps do
		table.insert(self.points, self:bezier3(p1, p2, p3, i/steps))
	end
end

function Bezier:createCubicCurve(p1, p2, p3, p4, steps)
	self.points = {}
	steps = steps or self:estimateSteps(p1, p2, p3, p4)
	for i = 0, steps do
		table.insert(self.points, self:bezier4(p1, p2, p3, p4, i/steps))
	end
end

function Bezier:bezier3(p1,p2,p3,mu)
	local mum1,mum12,mu2
	local p = {}
	mu2 = mu * mu
	mum1 = 1 - mu
	mum12 = mum1 * mum1
	p.x = p1.x * mum12 + 2 * p2.x * mum1 * mu + p3.x * mu2
	p.y = p1.y * mum12 + 2 * p2.y * mum1 * mu + p3.y * mu2
	--p.z = p1.z * mum12 + 2 * p2.z * mum1 * mu + p3.z * mu2
	
	return p
end

function Bezier:bezier4(p1,p2,p3,p4,mu)
	local mum1,mum13,mu3;
	local p = {}

	mum1 = 1 - mu
	mum13 = mum1 * mum1 * mum1
	mu3 = mu * mu * mu

	p.x = mum13*p1.x + 3*mu*mum1*mum1*p2.x + 3*mu*mu*mum1*p3.x + mu3*p4.x
	p.y = mum13*p1.y + 3*mu*mum1*mum1*p2.y + 3*mu*mu*mum1*p3.y + mu3*p4.y
	--p.z = mum13*p1.z + 3*mu*mum1*mum1*p2.z + 3*mu*mu*mum1*p3.z + mu3*p4.z

	return p	
end

-- Reduce nodes based on Ramer-Douglas-Peucker algorithm
-- http://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
-- Additional help from http://quangnle.wordpress.com/2012/12/30/corona-sdk-curve-fitting-1-implementation-of-ramer-douglas-peucker-algorithm-to-reduce-points-of-a-curve/
function Bezier:reduce(epsilon)
	epsilon = epsilon or .1

	if #self.points > 1 then
		-- Keep first and last
		self.points[1].keep = true
		self.points[#self.points].keep = true

		-- Figure out the rest
		self:douglasPeucker(1, #self.points, epsilon)
	end

	-- Replace point list with only those that are marked to keep
	local old = self.points
	self.points = {}

	for i,point in ipairs(old) do
		if point.keep then
			table.insert(self.points, {x=point.x, y=point.y})
		end
	end
end

function Bezier:douglasPeucker(first, last, epsilon)
	local dmax = 0
	local index = 0

	for i=first+1, last-1 do
		local d = self:pointLineDistance(self.points[i], self.points[first], self.points[last])

		if d > dmax then
			index = i
			dmax = d
		end
	end

	if dmax >= epsilon then
		self.points[index].keep = true

		-- Recursive call
		self:douglasPeucker(first, index, epsilon)
		self:douglasPeucker(index, last, epsilon)
	end
end

function Bezier:pointLineDistance(p, a, b)
	-- calculates area of the triangle
	local area = math.abs(0.5 * (a.x * b.y + b.x * p.y + p.x * a.y - b.x * a.y - p.x * b.y - a.x * p.y))
	-- calculates the length of the bottom edge
	local dx = a.x - b.x
	local dy = a.y - b.y
	local bottom = math.sqrt(dx*dx + dy*dy)
	-- the triangle's height is also the distance found
	return area / bottom
end

