application:setBackgroundColor(0x323232)
require "ImGui"

local VERTEX_BASE = [[
local vertex = hF4(vVertex, 0.0, 1.0)
fTexCoord = vTexCoord
return vMatrix * vertex]]

local FRAGMENT_BASE = [[
local frag = lF4(fColor) * texture2D(fTexture, fTexCoord)
if (frag.a == 0.0) then 
	discard() 
end
return frag]]

Window = {}

local ui = ImGui.new() 
--ui:setAutoUpdateCursor(true)

local IO = ui:getIO()
local FontAtlas = IO:getFonts()
local avm = FontAtlas:addFont("AverageMono.ttf", 16)
IO:setFontDefault(avm)
FontAtlas:build()

local function loadStyles(imgui)
	local style = imgui:getStyle()
	
	style:setColor(ImGui.Col_TabHovered, 0x54575b, 0.83)
	style:setColor(ImGui.Col_NavWindowingHighlight, 0xffffff, 0.70)
	style:setColor(ImGui.Col_FrameBgActive, 0xababaa, 0.39)
	style:setColor(ImGui.Col_PopupBg, 0x212426, 1.00)
	style:setColor(ImGui.Col_DragDropTarget, 0x1ca3ea, 1.00)
	style:setColor(ImGui.Col_FrameBgHovered, 0x616160, 1.00)
	style:setColor(ImGui.Col_ScrollbarBg, 0x050505, 0.53)
	--style:setColor(ImGui.Col_DockingEmptyBg, 0x333333, 1.00)
	--style:setColor(ImGui.Col_DockingPreview, 0x4296f9, 0.70)
	style:setColor(ImGui.Col_ResizeGripActive, 0x4296f9, 0.95)
	style:setColor(ImGui.Col_FrameBg, 0x40403f, 1.00)
	style:setColor(ImGui.Col_Separator, 0x6e6e7f, 0.50)
	style:setColor(ImGui.Col_Button, 0x40403f, 1.00)
	style:setColor(ImGui.Col_Header, 0x383838, 1.00)
	style:setColor(ImGui.Col_ScrollbarGrabActive, 0x828282, 1.00)
	style:setColor(ImGui.Col_ModalWindowDimBg, 0xcccccc, 0.35)
	style:setColor(ImGui.Col_NavWindowingDimBg, 0xcccccc, 0.20)
	style:setColor(ImGui.Col_TabUnfocused, 0x141416, 1.00)
	style:setColor(ImGui.Col_HeaderHovered, 0x40403f, 1.00)
	style:setColor(ImGui.Col_BorderShadow, 0x000000, 0.00)
	style:setColor(ImGui.Col_Border, 0x6e6e7f, 0.50)
	style:setColor(ImGui.Col_HeaderActive, 0xababaa, 0.39)
	style:setColor(ImGui.Col_NavHighlight, 0x4296f9, 1.00)
	style:setColor(ImGui.Col_ChildBg, 0x212426, 1.00)
	style:setColor(ImGui.Col_TextSelectedBg, 0x4296f9, 0.35)
	style:setColor(ImGui.Col_TitleBg, 0x141416, 1.00)
	style:setColor(ImGui.Col_PlotHistogramHovered, 0xff9900, 1.00)
	style:setColor(ImGui.Col_PlotHistogram, 0xe6b200, 1.00)
	style:setColor(ImGui.Col_ScrollbarGrab, 0x4f4f4f, 1.00)
	style:setColor(ImGui.Col_CheckMark, 0x1ca3ea, 1.00)
	style:setColor(ImGui.Col_ButtonActive, 0xababaa, 0.39)
	style:setColor(ImGui.Col_PlotLines, 0x9c9c9b, 1.00)
	style:setColor(ImGui.Col_TextDisabled, 0x80807f, 1.00)
	style:setColor(ImGui.Col_ScrollbarGrabHovered, 0x696968, 1.00)
	style:setColor(ImGui.Col_Text, 0xffffff, 1.00)
	style:setColor(ImGui.Col_TitleBgActive, 0x141416, 1.00)
	style:setColor(ImGui.Col_TabUnfocusedActive, 0x212426, 1.00)
	style:setColor(ImGui.Col_SliderGrabActive, 0x1480b7, 1.00)
	style:setColor(ImGui.Col_ResizeGrip, 0x000000, 0.00)
	style:setColor(ImGui.Col_Tab, 0x141416, 0.83)
	style:setColor(ImGui.Col_TitleBgCollapsed, 0x000000, 0.51)
	style:setColor(ImGui.Col_ResizeGripHovered, 0x4a4c4f, 0.67)
	style:setColor(ImGui.Col_TabActive, 0x3b3b3d, 1.00)
	style:setColor(ImGui.Col_WindowBg, 0x212426, 1.00)
	style:setColor(ImGui.Col_SeparatorActive, 0x4296f9, 0.95)
	style:setColor(ImGui.Col_SeparatorHovered, 0x696b70, 1.00)
	style:setColor(ImGui.Col_PlotLinesHovered, 0xff6e59, 1.00)
	style:setColor(ImGui.Col_SliderGrab, 0x1ca3ea, 1.00)
	style:setColor(ImGui.Col_ButtonHovered, 0x616160, 1.00)
	style:setColor(ImGui.Col_MenuBarBg, 0x242423, 1.00)
	style:setColor(ImGui.Col_TableRowBgAlt, 0x00ff00, 1)
	
	style:setWindowRounding(0)
	style:setChildRounding(0)
	style:setPopupRounding(3)
	style:setFrameRounding(3)
	style:setScrollbarRounding(0)
	style:setGrabRounding(3)
	style:setTabRounding(0)
end

local function onWindowResize()
	local minX, minY, maxX, maxY = application:getLogicalBounds()
	local W, H = maxX - minX, maxY - minY
	
	ui:setPosition(minX, minY)
	IO:setDisplaySize(W, H)
	
	Window.X = minX
	Window.Y = minY
	Window.Right = maxX
	Window.Bottom = maxY
	Window.W = W
	Window.H = H
	Window.CX = minX + W / 2
	Window.CY = minY + H / 2
end

loadStyles(ui)
onWindowResize()

local editorFragment = ImGuiTextEditor.new()
--editorFragment:setPalette(editorFragment:getPaletteDark())
editorFragment:setLanguageDefinition(editorFragment:getLanguageLua())
editorFragment:setText(FRAGMENT_BASE)
--editorFragment:setPaletteColor(ImGui.TE_Keyword, 0xffffff, 1)

--[[
editorFragment:loadPalette{
	0,1, --"Default",
	0xff0000,1, --"Keyword",
	2,1, --"Number",
	3,1, --"String",
	4,1, --"CharLiteral",
	5,1, --"Punctuation",
	6,1, --"Preprocessor",
	7,1, --"Identifier",
	8,1, --"KnownIdentifier",
	9,1, --"PreprocIdentifier",
	10,1, --"Comment",
	11,1, --"MultiLineComment",
	0xffffff,1, --"Background",
	13,1, --"Cursor",
	14,1, --"Selection",
	15,1, --"ErrorMarker",
	16,1, --"Breakpoint",
	17,1, --"LineNumber",
	18,1, --"CurrentLineFill",
	19,1, --"CurrentLineFillInactive",
	20,0.5, --"CurrentLineEdge",
}
]]

local editorVertex = ImGuiTextEditor.new(editorFragment)
editorVertex:setText(VERTEX_BASE)
--[[
local markers = ImGuiErrorMarkers.new()
markers:add(2, "Error message here")
markers:add(92, "Another error message")
markers:add(93, "Uhhh...")
editorFragment:setErrorMarkers(markers)
--]]

--[[
local points = ImGuiBreakpoints.new()
points:add(90)
points:add(94)
points:add(98)
editorFragment:setBreakpoints(points)
--]]

--local shaderPreview = RenderTarget.new(512, 512, true)
local texture = Texture.new("image.png", true)
local image = Bitmap.new(texture)
local RT = RenderTarget.new(texture:getWidth(), texture:getHeight(), true)
RT:draw(image)
local errorMsg = ""
local autoUpdate = false

local function makeFunction(code,env)
    local compiled, msg = loadstring("return "..code)
    if (compiled) then 
		return compiled()
	else
		error(msg) 
	end
end

local function updateShader()
	local fragment = editorFragment:getText()
	fragment = "function() " .. fragment .. " end"
	local vertex = editorVertex:getText()
	vertex = "function(vVertex, vColor, vTexCoord) " .. vertex .. " end"
	
	local shader = Shader.lua(
		makeFunction(vertex), 
		makeFunction(fragment), 
		0,
		{
			{name="vMatrix", type=Shader.CMATRIX, sys=Shader.SYS_WVP, vertex=true},
			{name="fColor", type=Shader.CFLOAT4, sys=Shader.SYS_COLOR, vertex=false},
			{name="fTexture", type=Shader.CTEXTURE, vertex=false},
			{name="fTextureInfo", type=Shader.CFLOAT4, sys=Shader.SYS_TEXTUREINFO, vertex=false},
			{name="fTime", type=Shader.CFLOAT, sys=Shader.SYS_TIMER, vertex=false},
		},
		{
			{name="vVertex", type=Shader.DFLOAT, mult=2, slot=0, offset=0},
			{name="vColor", type=Shader.DUBYTE, mult=4, slot=1, offset=0},
			{name="vTexCoord", type=Shader.DFLOAT, mult=2, slot=2, offset=0},
		},
		{
			{name="fTexCoord", type=Shader.CFLOAT2},
		}
	)
	image:setShader(shader)
	RT:clear(0,0)
	RT:draw(image)
end

local function protectedUpdateShader()
	local ok, msg = pcall(updateShader)
	if (not ok) then 
		errorMsg = msg
	else
		errorMsg = ""
	end
end
local function drawMenuBar(ui, editor)
	if (ui:beginMenuBar()) then
		if (ui:beginMenu("File")) then
			
			ui:menuItem("Open")
			ui:menuItem("Save")
			ui:menuItem("Save as")
			
			ui:separator()
			
			if (ui:menuItem("Exit", "Alt-F4")) then
				application:exit()
			end
			
			ui:endMenu()
		end
		
		if (ui:beginMenu("Edit")) then
			local ro = editor:isReadOnly()
			local sw = editor:isShowingWhitespaces()
			
			if (ui:menuItem("Read-only mode", nil, ro)) then
				editor:setReadOnly(not ro)
			end
			if (ui:menuItem("Show white spaces", nil, sw)) then
				editor:setShowWhitespaces(not sw)
			end
			
			if (ui:beginMenu("Syntax")) then
				local name = editor:getLanguageDefinition():getName()
				if (ui:menuItem("C++", nil, name == "С++")) then 
					editor:setLanguageDefinition(editor:getLanguageCPP())
				end
				if (ui:menuItem("GLSL", nil, name == "GLSL")) then 
					editor:setLanguageDefinition(editor:getLanguageGLSL())
				end
				if (ui:menuItem("HLSL", nil, name == "HLSL")) then 
					editor:setLanguageDefinition(editor:getLanguageHLSL())
				end
				if (ui:menuItem("C", nil, name == "C")) then 
					editor:setLanguageDefinition(editor:getLanguageC())
				end
				if (ui:menuItem("SQL", nil, name == "SQL")) then 
					editor:setLanguageDefinition(editor:getLanguageSQL())
				end
				if (ui:menuItem("Lua", nil, name == "Lua")) then 
					editor:setLanguageDefinition(editor:getLanguageLua())
				end
				ui:endMenu()
			end
			
			if (ui:beginMenu("Colors")) then
				if (ui:menuItem("Dark palette")) then
					editor:setPalette(editor:getPaletteDark()) 
				end
				if (ui:menuItem("Light palette")) then
					editor:setPalette(editor:getPaletteLight()) 
				end
				if (ui:menuItem("Retro blue palette")) then
					editor:setPalette(editor:getPaletteRetro()) 
				end
				ui:endMenu()
			end
			
			ui:separator()
			
			if (ui:menuItem("Undo", "Ctrl-Z", nil, not ro and editor:canUndo())) then
				editor:undo()
			end
			if (ui:menuItem("Redo", "Ctrl-Y", nil, not ro and editor:canRedo())) then
				editor:redo()
			end
			
			ui:separator()
			
			if (ui:menuItem("Copy", "Ctrl-C", nil, editor:hasSelection())) then
				editor:copy()
			end
			if (ui:menuItem("Cut", "Ctrl-X", nil, not ro and editor:hasSelection())) then
				editor:cut()
			end
			if (ui:menuItem("Delete", "Del", nil, not ro and editor:hasSelection())) then
				editor:delete()
			end
			if (ui:menuItem("Paste", "Ctrl-V", nil, not ro)) then
				editor:paste()
			end
			
			ui:separator()
			
			if (ui:menuItem("Select all")) then
				editor:selectAll()
			end
			
			ui:separator()
			
			ui:endMenu()
		end
		
		ui:endMenuBar()
	end
end

local function onDrawGui(e)
	ui:newFrame(e.deltaTime)
	
	--ui:showDemoWindow()
	
	if (ui:beginFullScreenWindow("Shader editor")) then 
		
		autoUpdate = ui:checkbox("Autoupdate", autoUpdate)
		if (not autoUpdate) then 
			if (ui:button("Update")) then 
				protectedUpdateShader()
			end
		end
		
		local w = ui:getWindowWidth()
		ui:scaledImage("##", RT, w, 512)
		
		ui:beginChild(1, w / 2, 0, true, ImGui.WindowFlags_MenuBar | ImGui.WindowFlags_HorizontalScrollbar)
		drawMenuBar(ui, editorFragment)
		local row, col = editorFragment:getCursorPosition()
		ui:text(("%6d/%-6d %6d lines  | %s | %s | %s | FragmentShader.lua"):format(
			row + 1, col + 1, 
			editorFragment:getTotalLines(), 
			(editorFragment:isOverwrite() and "Ovr" or "Ins"), 
			(editorFragment:canUndo() and "*" or " "), 
			editorFragment:getLanguageDefinition():getName())
		)
		editorFragment:render("My editorFragment")
		ui:endChild()
		
		ui:sameLine()
		
		ui:beginChild(2, -1, 0, true, ImGui.WindowFlags_MenuBar | ImGui.WindowFlags_HorizontalScrollbar)
		drawMenuBar(ui, editorVertex)
		local row, col = editorVertex:getCursorPosition()
		ui:text(("%6d/%-6d %6d lines  | %s | %s | %s | VertexShader.lua"):format(
			row + 1, col + 1, 
			editorVertex:getTotalLines(), 
			(editorVertex:isOverwrite() and "Ovr" or "Ins"), 
			(editorVertex:canUndo() and "*" or " "), 
			editorVertex:getLanguageDefinition():getName())
		)
		editorVertex:render("My vertex editor")
		ui:endChild()
		
		if (autoUpdate and (editorFragment:isTextChanged() or editorVertex:isTextChanged())) then 
			protectedUpdateShader()
		end
		
		if (errorMsg ~= "") then 
			local cx, cy = ui:getCursorPos()
			ui:setCursorPos(20, 20)
			ui:text(errorMsg)
			ui:setCursorPos(cx, cy)
		end
	end
	ui:endWindow()
	
	ui:render()
	ui:endFrame()
end

stage:addChild(ui)

stage:addEventListener("applicationResize", onWindowResize)
stage:addEventListener("enterFrame", onDrawGui)
