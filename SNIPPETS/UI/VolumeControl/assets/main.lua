---------------------------------------------------------------------------------------------
---------------------- ***  STYLISH VOLUME CONTROL IN CORONA SDK   *** ----------------------
---------------------------------------------------------------------------------------------

-- By iNSERT.CODE - http://insertcode.co.uk
-- Version: 1.0
-- 
-- This code is MIT licensed

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

-- Converted to Gideros by evs, Corona code commented out, not removed. Project settings 768 * 1024, No Scale-Top Left

application:setOrientation(Application.LANDSCAPE_LEFT) -- ADDED evs

--display.setStatusBar( display.HiddenStatusBar )

-- Forward References

--local _W = display.contentWidth
--local _H = display.contentHeight
local _W = application:getContentWidth()
local _H = application:getContentHeight()

local musicPercent

local volMinPos = -170

local volMaxPos = 170

-- Load & Play Music On Infinite Loop

--local bgMusic = audio.loadStream("systematic.mp3")
--audio.play( bgMusic, { channel=1, loops=-1, fadein=700 }  )
local sound = Sound.new("Braam - Retro Pulse.wav")
local length = sound:getLength()
local channel = sound:play()

-- Setup Background Image

--local bg = display.newImage("bg.png")
--bg.x = _W * 0.5; bg.y = _H * 0.5
local bg = Bitmap.new(Texture.new("bg_balloon.png"))
stage:addChild(bg)

-- Setup Control Knob

--local controlKnob = display.newImage("controlKnob.png")
--controlKnob.x = _W * 0.5; controlKnob.y = _H * 0.5
local controlKnob = Bitmap.new(Texture.new("Breezeicons-apps-48-multimedia-volume-control.svg.png"))
controlKnob:setScale(0.1)
controlKnob:setAnchorPoint(0.5, 0.5)
controlKnob:setPosition(_W  * 0.5, _H  * 0.5)
stage:addChild(controlKnob)

-- Setup LEDs & Labels In A For Loop 

local ledOffTable = {}

local ledOnTable = {}

local ledLabelTextTable = {}

for i = 1, 20 do
	local ledStartX = _W - 14*32 -- 965
	local ledStartY = 16
	local ledLabel = i * 5
	
	--ledOffTable[i] = display.newImage("LED_Off.png")
	ledOffTable[i] = Bitmap.new(Texture.new("mid_up.png"))
	ledOffTable[i]:setScale(0.1)
	ledOffTable[i]:setAnchorPoint(0.5, 0.5)
	stage:addChild(ledOffTable[i])
	--ledOnTable[i] = display.newImage("LED_On.png")
	ledOnTable[i] = Bitmap.new(Texture.new("mid_down.png"))
	ledOnTable[i]:setScale(0.1)
	ledOnTable[i]:setAnchorPoint(0.5, 0.5)
	stage:addChild(ledOnTable[i])
	--ledOnTable[i].isVisible = false
	ledOnTable[i]:setVisible(false)
	ledOnTable[i].lightValue = ledLabel
	--ledLabelTextTable[i] = display.newText( ledLabel, 0, 0, "Helvetica", 10 )
	ledLabelTextTable[i] = TextField.new(nil, ledLabel)
	ledLabelTextTable[i]:setTextColor(0xdd00dd)
	stage:addChild(ledLabelTextTable[i])
	
	if i == 0 then
		--ledOffTable[i].x = ledStartX
		ledOffTable[i]:setX(ledStartX)
		--ledOnTable[i].x = ledStartX
		ledOnTable[i]:setX(ledStartX)
		--ledLabelTextTable[i].x = ledStartX
		ledLabelTextTable[i]:setX(ledStartX)
	else
		--ledOffTable[i].x =  (i * 43) + ledStartX
		ledOffTable[i]:setX(i * 16 + ledStartX)
		--ledOnTable[i].x = ledOffTable[i].x
		ledOnTable[i]:setX(ledOffTable[i]:getX())
		--ledLabelTextTable[i].x = ledOffTable[i].x
		ledLabelTextTable[i]:setX(ledOffTable[i]:getX() - ledLabelTextTable[i]:getWidth() * 0.5 + 2)
	end

	--ledOffTable[i].y = ledStartY
	ledOffTable[i]:setY(ledStartY)
	--ledOnTable[i].y = ledOffTable[i].y
	ledOnTable[i]:setY(ledOffTable[i]:getY())
	--ledLabelTextTable[i].y = ledOffTable[i].y + 25
	ledLabelTextTable[i]:setY(ledOffTable[i]:getY() + 25)
end	

-- Touch To Rotate Function For Control Knob

local function rotateControlKnob(event)
                    
	--if (event.phase == "began") then
	if (event.type == "touchesBegin") then
  
		-- Store Initial Touch Position In The Control Knob Object
		
		--controlKnob.x1 = event.x
		--controlKnob.y1 = event.y
		controlKnob.x1 = event.touch.x
		controlKnob.y1 = event.touch.y
		
		
	end
		                
	--if (event.phase == "moved") then
	if (event.type == "touchesMove") then
	 
		-- Calculate Amount Of Rotation To Apply To Control Knob Depending On Where The User Moves Their Finger To
		
		--controlKnob.x2 = event.x
		--controlKnob.y2 = event.y
		controlKnob.x2 = event.touch.x
		controlKnob.y2 = event.touch.y
		
		controlKnob.x, controlKnob.y = controlKnob:getPosition() -- ADDED evs
		
		angle1 = 180 / math.pi * math.atan2( controlKnob.y1 - controlKnob.y , controlKnob.x1 - controlKnob.x )
		angle2 = 180 / math.pi * math.atan2( controlKnob.y2 - controlKnob.y , controlKnob.x2 - controlKnob.x )

		local amountOfRotation = angle1 - angle2
 
		-- Rotate The Control Knob
		
		--controlKnob.rotation = controlKnob.rotation - amountOfRotation
		controlKnob:setRotation(controlKnob:getRotation() - amountOfRotation)
			
	end	
	
end

-- Apply Touch Event Listener To The Control Knob

--controlKnob:addEventListener("touch", rotateControlKnob)
controlKnob:addEventListener("touchesBegin", rotateControlKnob)
controlKnob:addEventListener("touchesMove", rotateControlKnob)

---------------------------------------------------------------------------------------------
----------------------------   MAIN LOOP- (CALLED EVERY FRAME)   ----------------------------
---------------------------------------------------------------------------------------------

-- Check For Minimum/Maximum Volume Stops & Prevent Control Knob From Rotating Past Them

local function checkMaxMinVol()

if channel:getPosition() == length then channel = sound:play() end -- ADDED evs 

	controlKnob.rotation = controlKnob:getRotation() -- ADDED evs
		
		if controlKnob.rotation >= volMaxPos then
			
			--controlKnob.rotation = volMaxPos
			controlKnob:setRotation(volMaxPos)
			
		end
					
		if controlKnob.rotation <= volMinPos then
			
			--controlKnob.rotation = volMinPos
			controlKnob:setRotation(volMinPos)
			
		end
	
end

--  Calculate (And Set) The Correct Volume Based On The Rotation Of The Control Knob

local function getVol()
	
	controlKnob.rotation = controlKnob:getRotation() -- ADDED evs
	--if controlKnob.rotation < 0 then
	if controlKnob.rotation < 0 then
		
		musicPercent = math.floor(50 - ((controlKnob.rotation / volMinPos) * 50))
		
	else
	
		musicPercent = math.floor(50 + ((controlKnob.rotation / volMaxPos) * 50))
		
	end	

	--print ("Music Volume: ", musicPercent)
	
	--audio.setVolume( musicPercent / 100,  { channel=1 }  )
	channel:setVolume( musicPercent / 100 )
		
end

--  Calculate (And Set) The Correct Number Of LEDs To Be Illuminated Based On The Volume Level

local function updateLeds()
	
	local numberOfLeds = 20
	
	for i = 1, numberOfLeds do
		
		if musicPercent >= ledOnTable[i].lightValue then
			
			--ledOnTable[i].isVisible = true
			ledOnTable[i]:setVisible(true)
			
		else
		
			--ledOnTable[i].isVisible = false
			ledOnTable[i]:setVisible(false)
			
		end	
		
	end	
	
end	

-- Call The Main Loop & It's Other Functions Every Frame

local function mainLoop( event )
	
	checkMaxMinVol()

	getVol()
	
	updateLeds()
		
end
 
--Runtime:addEventListener( "enterFrame", mainLoop )
stage:addEventListener( "enterFrame", mainLoop )

---------------------------------------------------------------------------------------------
----------------------------------   END OF MAIN LOOP   -------------------------------------
---------------------------------------------------------------------------------------------