local Tail = Core.class(Mesh)

local function clipAngle(angle)
	if angle < 0 then
		while angle < 0 do
			angle = angle + math.pi * 2
		end
	elseif angle > math.pi * 2 then
		while angle > math.pi * 2 do
			angle = angle - math.pi * 2
		end
	end
	return angle
end

function Tail:init(options)
	
	local defaults = {
		numPoints = 20,
		width = 20,
		color = 0xff0000,
		scaleFactor = 1,
		gradient = false,
	}
	
	local config = defaults
	
	if type(options) == "table" then
		for k, v in pairs(options) do
			if type(options[k]) == type(config[k]) then
				config[k] = v
			end
		end
	end
	
	for k, v in pairs(config) do
		self[k] = v
	end
	
	self.linePoints = {}
	self.lineThetas = {}
	self.vertexPoints = {}
	self.indexArray = {}

end

function Tail:addPoint(x, y)
	
	if #self.linePoints >= self.numPoints then
		for i = 3, (#self.linePoints * 2), 1 do
			local x2, y2 = self:getVertex(i)
			self:setVertex(i - 2, x2, y2)
		end
		table.remove(self.linePoints, 1)
		table.remove(self.lineThetas, 1)
	end
	
	table.insert(self.linePoints, {x = x, y = y})
	
	local curNumPoints = #self.linePoints
	
	if curNumPoints > 1 then
	
		local p1 = self.linePoints[curNumPoints - 1]
		local p2 = self.linePoints[curNumPoints]		
		local lineTheta = math.atan2(p2.y - p1.y, p2.x - p1.x)
		table.insert(self.lineThetas, lineTheta)
		local perpTheta = lineTheta + math.pi/2
		local dx = self.width * math.cos(perpTheta)
		local dy = self.width * math.sin(perpTheta)
		local mx1 = p2.x + dx
		local my1 = p2.y + dy
		local mx2 = p2.x - dx
		local my2 = p2.y - dy
		self:setVertex(curNumPoints * 2 - 1, mx1, my1)
		self:setVertex(curNumPoints * 2, mx2, my2)
		local alpha = 1.0
		if self.gradient then
			alpha = (curNumPoints - 1)/(self.numPoints - 1)
		end
		self:setColor(curNumPoints * 2 - 1, self.color, alpha)
		self:setColor(curNumPoints * 2, self.color, alpha)
		local addIndeces = {curNumPoints * 2 - 3, curNumPoints * 2 - 2, curNumPoints * 2 - 1, curNumPoints * 2 - 2, curNumPoints * 2 - 1, curNumPoints * 2}
		for i = 1, #addIndeces, 1 do
			table.insert(self.indexArray, addIndeces[i])
		end
		if curNumPoints == 2 then
			mx1 = p1.x + dx
			my1 = p1.y + dy
			mx2 = p1.x - dx
			my2 = p1.y - dy
			self:setVertex(1, mx1, my1)
			self:setVertex(2, mx2, my2)
			if self.gradient then alpha = 0 end
			self:setColor(1, self.color, alpha)
			self:setColor(2, self.color, alpha)
		else
			local prevLineTheta = self.lineThetas[#self.lineThetas - 1]
			local diagTheta = (lineTheta - prevLineTheta)/2
			local d = self.width/math.cos(diagTheta)
			perpTheta = math.pi * 0.5 + (lineTheta + prevLineTheta)/2
			if diagTheta % (math.pi * 0.5) == 0 then
				d = self.width
				perpTheta = lineTheta + math.pi * 0.5
			end
			dx = d * math.cos(perpTheta)
			dy = d * math.sin(perpTheta)
			mx1 = p1.x + dx
			my1 = p1.y + dy
			mx2 = p1.x - dx
			my2 = p1.y - dy
			self:setVertex((curNumPoints - 1) * 2 - 1, mx1, my1)
			self:setVertex((curNumPoints - 1) * 2, mx2, my2)
		end
		self:setIndexArray(self.indexArray)
			
	end

	if self.scaleFactor ~= 1 then
		for i = 1, #self.linePoints - 1, 1 do
			local p = self.linePoints[i]
			local vx, vy = self:getVertex(i * 2 - 1)
			local dx = p.x - vx
			local dy = p.y - vy
			dx = dx * self.scaleFactor
			dy = dy * self.scaleFactor
			vx = p.x - dx
			vy = p.y - dy
			self:setVertex(i * 2 - 1, vx, vy)
			vx = p.x + dx
			vy = p.y + dy
			self:setVertex(i * 2, vx, vy)
		end
	end
	
end

return Tail