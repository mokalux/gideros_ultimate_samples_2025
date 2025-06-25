CircleTime = Core.class(Sprite)


function CircleTime:init(config)
	-- Settings
	self.conf = {
		addBackground = true,
		radius = 100,
		fillColor = 0x1EEFA8,
		lineColor = 0x16B17D,
		backgroundFillColor = 0x2FE5EF,
		backgroundLineColor = 0x23AAB1,
		lineThickness = 4,
		fillAlpha = 1,
		totalMillisecond = 60000, -- 1 min
		tick = 1,  --Effects Performance
		autoStart = true
	}
	
	if config then
		--copying configuration
		for key,value in pairs(config) do
			self.conf[key]= value
		end
	end
	
	self.isStarted = false
	
	if self.conf.autoStart == true then
		self:StartTimer()
	end	
	
	if self.conf.addBackground==true then
		local backgroundPath = self:DrawBackgroundPath()
		self:addChild(backgroundPath)
	end
	
	self.path = self:DrawTimePath()
	self:addChild(self.path)
	
	self:addEventListener(Event.ENTER_FRAME,self.OnEnterFrame,self)
end

function CircleTime:DrawBackgroundPath()
	local path=Path2D.new()
	local ms="MAAZ" 
	local mp={
	self.conf.radius,-self.conf.radius,     --M
	self.conf.radius,self.conf.radius,0,0,0,self.conf.radius,self.conf.radius, --A    
	self.conf.radius,self.conf.radius,0,0,0,self.conf.radius,-self.conf.radius,  --A 
	}
	
	path:setPath(ms,mp) --Set the path from a set of commands and coordinates
	path:setLineThickness(self.conf.lineThickness) -- Outline width
	path:setFillColor(self.conf.backgroundFillColor,self.conf.fillAlpha) --Fill color
	path:setLineColor(self.conf.backgroundLineColor) --Line color
	path:setAnchorPosition(0-self.conf.lineThickness/2,-self.conf.radius-self.conf.lineThickness/2)
	
	return path
end

function CircleTime:DrawTimePath()
	
	local path=Path2D.new()
	local ms="MAALLZ" 
	local mp={
	self.conf.radius,-self.conf.radius,     --M
	self.conf.radius,self.conf.radius,0,0,0,self.conf.radius,self.conf.radius, --A    
	self.conf.radius,self.conf.radius,0,0,0,self.conf.radius,-self.conf.radius,  --A 
	self.conf.radius,0, --L
	self.conf.radius,-self.conf.radius  --L  
	}
	
	path:setPath(ms,mp) --Set the path from a set of commands and coordinates
	path:setLineThickness(self.conf.lineThickness) -- Outline width
	path:setFillColor(self.conf.fillColor,self.conf.fillAlpha) --Fill color
	path:setLineColor(self.conf.lineColor) --Line color
	path:setAnchorPosition(0-self.conf.lineThickness/2,-self.conf.radius-self.conf.lineThickness/2)
	
	return path
end

function CircleTime:DrawCircleWithTime(timePassed)
	local degree = self:CalcDegree(timePassed)
	
	local x,y = self:CalcPoints(self.conf.radius,degree)
	local ms="MAALLZ"
	local mp={
	self.conf.radius,-self.conf.radius,     --M
	self.conf.radius,self.conf.radius,0,0,0,self.conf.radius,self.conf.radius, --A    
	self.conf.radius,self.conf.radius,0,0,0,x,y,  --A 
	self.conf.radius,0, --L
	self.conf.radius,-self.conf.radius  --L  
	}
	if degree > 180 then
		ms="MALLZ" 
		mp={
			self.conf.radius,-self.conf.radius,     --M
			self.conf.radius,self.conf.radius,0,0,0,x,y, --A  
			self.conf.radius,0, --L
			self.conf.radius,-self.conf.radius  --L  
		}
	end	
	
	self.path:setPath(ms,mp) 

end

function CircleTime:StartTimer()
	self.isStarted = true
	self.startTime = os.timer()*1000
end

function CircleTime:OnEnterFrame(event)
	if event.frameCount % self.conf.tick == 0 then
		if self.isStarted == true and self.startTime then
			
			local currentTime = os.timer()*1000 - self.startTime
			
			if currentTime >= self.conf.totalMillisecond then
				
				self:removeEventListener(Event.ENTER_FRAME,self.OnEnterFrame,self)
				currentTime = self.conf.totalMillisecond 
				
			end
			
			self:DrawCircleWithTime(currentTime)
			
		end
	end
end

function CircleTime:CalcDegree(timePassed)

	return (360/self.conf.totalMillisecond)*timePassed

end

function CircleTime:CalcPoints(radius,angle)
	local x,y = 0
	
	x = radius * ( math.sin(math.rad(angle))+1) 
	y =  -math.cos(math.rad(angle)) *radius
	
	return x,y

end

