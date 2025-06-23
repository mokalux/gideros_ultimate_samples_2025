application:setBackgroundColor(0x323232) --set app background
require "ImGui" --require the plugin

local ui = ImGui.new() --create local instance of imgui 
local IO = ui:getIO() --this is mandatory, I guess it's Input/Output interface

--set custom fonts:
local FontAtlas = IO:getFonts() --get fontAtlas
--define custon fonts in fonts table { font[1], font[2], font[3] }
local fonts = FontAtlas:addFonts{ {"fonts/CharisSIL-Regular.ttf", 18}, {"fonts/CharisSIL-Bold.ttf", 28},  {"fonts/CharisSIL-Italic.ttf", 28} }

--set first font as default font
IO:setFontDefault(fonts[1])
--build updated fontAtlas
FontAtlas:build()
	
--this function is called everytime the window is resized, AND if specified it returns the size/position values of stuff in a table
function onWindowResize(rt)
	local minX, minY, maxX, maxY = application:getLogicalBounds()
	
	local sx = application:getLogicalScaleX()
	local sy = application:getLogicalScaleY()
 
	ui:setScale(1 / sx, 1 / sy)
	-- move UI to top left corner
	ui:setPosition(minX, minY)
	-- resize display area
	IO:setDisplaySize((maxX - minX) * sx, (maxY - minY) * sy)
	
	if rt then --if rt was not empty return the values
		rt = {
			x  = minX,
			X  = maxX,
			y  = minY,
			Y  = maxY,
			Sx = sx,
			Sy = sy,
			w  = (maxX - minX) * sx,
			h  = (maxY - minY) * sy
		}
		return rt
	end
end
--ss stores the values we need in order to center/position stuff on screen: (true) neans that the function must return those values (see above)
local ss = onWindowResize(true)

--scene selector: check in enterframe, changes with button1 in drawWindow_1() and button4 in drawWindow_2()
local scene = 1

--this is what draws the windows
local function drawWindow_1()

	--set size and position of the next drawn window 
	ui:setNextWindowSize(ss.w, ss.h) --width, height
	ui:setNextWindowPos(ss.x, ss.y) --coords of the top left corner 
	--start drawing window
	window02 = ui:beginWindow(
		"Window02", --title
		nil,  -- no close button
		ImGui.WindowFlags_NoCollapse | ImGui.WindowFlags_NoResize | ImGui.WindowFlags_NoBringToFrontOnFocus | ImGui.WindowFlags_NoMove
		)
		
--TEXT on top		
	--horizontal center a text line made up of several parts: 
	local avail = ui:getContentRegionAvail() --calc the still available portion of the window
	local text_width = ui:calcTextSize("Te")+ui:calcTextSize("xtur")+ui:calcTextSize("ize") --calc how much space my text occupies
	local center_text_x = (avail - text_width) /2 -- old trick to center stuff
	ui:setCursorPosX(center_text_x) 	--this actually draws the next object starting at position center_text_x
	
	--define different fonts for text portions:
	ui:pushStyleVar(ui.StyleVar_ItemSpacing, 0,40) --from this line (push...) change item spacing so that the 2 words look the same string without blanks (0) and add some space below (40).
	local word1 = ui:text("Te") --first part of test text
	ui:sameLine() --tell the ui to draw the next stuff on the same line
	ui:pushFont(fonts[3]) -- push font: "starts drawing with font 3" the next elements
	local word3 = ui:text("xtur") --second part of test text
	ui:popFont() -- pop font: "stops drawing with the font selected before using pushFont".
	ui:sameLine()  --tell the ui to draw the next stuff on the same line
	local word4 = ui:text("ize") --third part of test text
	ui:popStyleVar() --stop (pop...) handling item spacing as set before.


--BUTTONS
--	center buttons
	local avail = ui:getContentRegionAvail()
	local center_button_x = (avail - ss.w) /2 --since each button has width ss.w/3, and there are 3 buttons, I can use ss.w
	ui:setCursorPosX(center_button_x)


	--change button color in 3 states
	ui:pushStyleColor(ui.Col_Button, 0x606060, 1.00)
	ui:pushStyleColor(ui.Col_ButtonHovered, 0x707070, 1.00)
	ui:pushStyleColor(ui.Col_ButtonActive, 0xa0a0a0, 1.00)
	local button1 = ui:button("Go to scene 2", ss.w/3, ss.h/10) --place the button
	
	--stop pushing style color, 3 times. one for each state of the button.
	ui:popStyleColor() 
	ui:popStyleColor()
	ui:popStyleColor()
	
	ui:sameLine() --tell the ui to draw the next stuff on the same line
	ui:pushFont(fonts[2])  -- push font "starts drawing with font 2" the next elements
	local button2 = ui:button("Button 2", ss.w/3, ss.h/10)
	ui:popFont() -- pop font: "stops drawing with the font 2 selected before using pushFont".
	ui:sameLine()
	local button3 = ui:button("Button 3", ss.w/3, ss.h/10)

	--center single button
	local avail = ui:getContentRegionAvail()
	local center_button_x = (avail - ss.w/5) /2
	ui:setCursorPosX(center_button_x)
	
	local button4 = ui:button("Button 4", ss.w/5, ss.h/5)
	

	--actions for the buttons console output
	if (button1) then 
		print("button1") 
		scene = 2 
	elseif (button2) then print("button2") 
	elseif (button3) then print("button3") 
	elseif (button4) then print("button4", avail, center_button_x)
	end

	ui:endWindow()
		
		

end

--this is what draws the window on scene 2
local function drawWindow_2()

	ui:setNextWindowSize(ss.w, ss.h)
	ui:setNextWindowPos(ss.x, ss.y)
	window02 = ui:beginWindow(
		"Window02", --title
		nil,  -- no close button
		ImGui.WindowFlags_NoCollapse | ImGui.WindowFlags_NoResize | ImGui.WindowFlags_NoBringToFrontOnFocus | ImGui.WindowFlags_NoMove
		)
		
		
	--horizontal center a text line :
	
	local avail = ui:getContentRegionAvail() --calc the still available portion of the window
	local text_width = ui:calcTextSize("SCENE 2") --calc how much space my text occupies
	local center_text_x = (avail - text_width) /2 -- old trick to center stuff
	ui:setCursorPosX(center_text_x) 	--this actually draws the next object starting at position center_text_x
	
	--define different fonts for text:
	ui:pushStyleVar(ui.StyleVar_ItemSpacing, 40,40) --from this line (push...) change item spacing so that the 2 words look the same string without blanks (0) and add some space below (40).
	local word1 = ui:text("SCENE 2") --first part of test text
	ui:popStyleVar() --stop (pop...) handling item spacing as set before.



	
	
	--center single button
	local avail = ui:getContentRegionAvail()
	local center_button_x = (avail - ss.w/5) /2
	ui:setCursorPosX(center_button_x)
	
	--change button color in 3 states
	ui:pushStyleColor(ui.Col_Button, 0x606060, 1.00)
	ui:pushStyleColor(ui.Col_ButtonHovered, 0x707070, 1.00)
	ui:pushStyleColor(ui.Col_ButtonActive, 0xa0a0a0, 1.00)
	local button4 = ui:button("Back to scene 1", ss.w/5, ss.h/5)
	
	--stop pushing style color, 3 times. one for each state of the button.
	ui:popStyleColor() 
	ui:popStyleColor()
	ui:popStyleColor()
	--action for button4
	if button4 then scene = 1 end
	

	ui:endWindow()
		
		

end

--this runs every frame to redraw the gui
local function onDrawGui(e)
	ui:newFrame(e.deltaTime)
	
	if scene == 1 then
		drawWindow_1()
	else --scene = 2
		drawWindow_2()
	end
	
	
	ui:updateCursor()
	ui:render()
	ui:endFrame()
end


onWindowResize()


stage:addEventListener("enterFrame", onDrawGui) --check onDrawGui every frame
stage:addEventListener("applicationResize", onWindowResize) --check if container app resizes
stage:addChild(ui) --add the gui to stage
