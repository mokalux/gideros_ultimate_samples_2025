graphicConf = gideros.class(Sprite)

--Los Devices Sizes son los tamaños de los dispositivos
--Los Logical Sizes es el tamaño logico del aplicativo  
	-- En landscape el ancho es 480 y el alto es 320 o
	-- En landscape el ancho es 960 y el alto es 640
	----- Pero si es Portrai
	-- En portrait el ancho es 320 y el alto es 480
	-- En portrait el ancho es 640 y el alto es 960
--Los Content Sizes el tamaño del alto logico () 
--- Ejemplo si el ancho logico es 100 entonces 
-- contentSizeWidth=100 y el contentSizeHeight=100


function graphicConf:init()
	graphicConfSelf=self
	self.font = TTFont.new("fonts/Comfortaa_Bold.ttf", 20, true)
	self.debuggerFlag=true
	self.debuggerLine=0
	self:configure()
end

function graphicConf:configure()
	--application:setFps(30)
	--application:setOrientation("landscapeLeft")
	self:setResolutions()
	self:setScaleModeGame()
	self:getSizes()
	self:blackTapes()
	self:setFPSVisor()
end

function graphicConf:debugger(message)
	if(self.debuggerFlag==true)then
		self.debuggerLine=self.debuggerLine+40
		local info = TextField.new(self.font, message)
		info:setTextColor(0x000000)
		info:setPosition(10,self.debuggerLine)
		self:addChild(info)
	end
end

function graphicConf:getSizes()	
	local width
	local height
	width, height = self:getSizesDevice()
		--self:debugger("Size Device: "..width.." , "..height)
	width, height = self:getSizesLogical()
		--self:debugger("Size Logical: "..width.." , "..height)
	width, height = self:getSizesContent()
		--self:debugger("Size Content: "..width.." , "..height)
	width 	= nil
	height 	= nil
	--self:debugger(application:getScaleMode())
end


function graphicConf:getSizesDevice()
	return application:getDeviceWidth(), application:getDeviceHeight()
end

function graphicConf:getSizesLogical()
	return application:getLogicalWidth(), application:getLogicalHeight()
end

function graphicConf:getSizesContent()
	return application:getContentWidth(), application:getContentWidth()
end

function graphicConf:setResolutions()
	--Referencia de 480 para Landscape mode
	--#*************************IDIOMA*************************
	_LANG="en"
	if(application:getDeviceHeight()<=480)then			
		_IMAGESFOLDER		= "images_low" 
		_TYPERESOLUTION		= "low"
		_SCALEPROPORTIONS 	= 1
		_SCREENWIDTH 		= 320
		_SCREENHEIGHT 		= 480
		application:setLogicalDimensions(_SCREENWIDTH,_SCREENHEIGHT)	
	else			
		_IMAGESFOLDER		= "images_high" 
		_TYPERESOLUTION		= "hight"
		_SCALEPROPORTIONS 	= 2
		_SCREENWIDTH 		= 640
		_SCREENHEIGHT 		= 960	
		application:setLogicalDimensions(_SCREENWIDTH,_SCREENHEIGHT)	
	end
	_FONDOSLEVELS = {
		"cajaAmanoEstructuraRosa.png",
		"cajaAmanoEstructuraMarronAmarillo.png",
		"cajaAmanoEstructuraMarron.png",
		"cajaAmanoEstructuraVerde.png",
		"cajaAmanoEstructuraPlateada.png",
		"cajaAmanoEstructuraMarronAzul.png"
	}
end

function graphicConf:setScaleModeGame()
	--Debe funcionar tanto para Potrait y Landscape porque es basado en el DeviceSize
	if ((application:getDeviceWidth() == 768) and (application:getDeviceHeight()== 1024)) then
		application:setScaleMode("fitWidth")
	elseif ((application:getDeviceWidth() == 768) and (application:getDeviceHeight()== 976)) then
		application:setScaleMode("fitWidth")
	elseif ((application:getDeviceWidth() == 640) and (application:getDeviceHeight()== 1136)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 1536) and (application:getDeviceHeight()== 2048)) then
		application:setScaleMode("fitWidth")
	elseif ((application:getDeviceWidth() == 320) and (application:getDeviceHeight()== 568)) then
		application:setScaleMode("stretch")
	elseif ((application:getDeviceWidth() == 480) and (application:getDeviceHeight()== 800)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 240) and (application:getDeviceHeight()== 320)) then
		application:setScaleMode("stretch")
	elseif ((application:getDeviceWidth() == 540) and (application:getDeviceHeight()== 960)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 480) and (application:getDeviceHeight()== 854)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 240) and (application:getDeviceHeight()== 400)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 340) and (application:getDeviceHeight()== 640)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 480) and (application:getDeviceHeight()== 854)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 800) and (application:getDeviceHeight()== 1280)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 600) and (application:getDeviceHeight()== 1024)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 600) and (application:getDeviceHeight()== 800)) then
		application:setScaleMode("fitWidth")
	elseif ((application:getDeviceWidth() == 768) and (application:getDeviceHeight()== 1366)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 720) and (application:getDeviceHeight()== 1280)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 1080) and (application:getDeviceHeight()== 1920)) then
		application:setScaleMode("fitHeight")
	elseif ((application:getDeviceWidth() == 320) and (application:getDeviceHeight()== 480)) then
		application:setScaleMode("pixelPerfect")
	elseif ((application:getDeviceWidth() == 640) and (application:getDeviceHeight()== 960)) then
		application:setScaleMode("pixelPerfect")
	else
		application:setScaleMode("stretch")
	end
end

function graphicConf:blackTapes()	
	local screenTop = Bitmap.new(Texture.new(_IMAGESFOLDER.."/topBar.png"))
	screenTop:setAnchorPoint(0, 1)	
	screenTop:setPosition(0,0)
	self:addChild(screenTop)

	local screenBottom = Bitmap.new(Texture.new(_IMAGESFOLDER.."/topBar.png"))
	screenBottom:setAnchorPoint(0,0)	
	screenBottom:setPosition(0,application:getLogicalWidth())
	self:addChild(screenBottom)


	local screenRight = Bitmap.new(Texture.new(_IMAGESFOLDER.."/lateralBar.png"))
	screenRight:setAnchorPoint(1,0)	
	screenRight:setPosition(0,0)
	self:addChild(screenRight)

	local screenLeft = Bitmap.new(Texture.new(_IMAGESFOLDER.."/lateralBar.png"))
	screenLeft:setAnchorPoint(0,0)	
	screenLeft:setPosition(application:getLogicalHeight(),0)
	self:addChild(screenLeft)
end

function graphicConf:round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function graphicConf:setFPSVisor()
	
	self.info1 = TextField.new(self.font, " Fps: 0")
	self.info1:setPosition(10, 50)
	self:addChild(self.info1,2)

	self.frame = 0
	self.timer = os.timer()
	self.frame1=0
	self.frameTemp1=0
	stage:addEventListener(Event.ENTER_FRAME, self.displayFps)
end


function graphicConf:displayFps()
	graphicConfSelf.frame = graphicConfSelf.frame + 1
	if graphicConfSelf.frame == application:getFps() then
		local currentTimer = os.timer()
		graphicConfSelf.frame1=graphicConfSelf:round(application:getFps() / (currentTimer - graphicConfSelf.timer))
		if(graphicConfSelf.frame1~=graphicConfSelf.frameTemp1)then
			graphicConfSelf.frameTemp1=graphicConfSelf.frame1
			graphicConfSelf.info1:setText(" Fps: "..graphicConfSelf.frame1)
			--print(frame1)
		end
		graphicConfSelf.frame = 0
		graphicConfSelf.timer = currentTimer	
	end
end

