Plotter = Core.class(Sprite)

function Plotter:init()
	-- BG
	application:setBackgroundColor(0x222222)
	application:configureFrustum(120)
	-- our 3d view
	noise:getInterp()
	local view1 = Viewport.new()
	view1:lookAngles(0,0,10,0,0,0)
	view1:lookAt(0,2,-10,0,0,0,0,1,0)
	-- a mesh
	self.xmesh = Mesh.new(true)
	self.xmesh:setVertexArray(
		0, 0,
		100, 0,
		100, 150,
		0, 150
	)
	self.xmesh:setIndexArray(
		1, 2, 3,
		1, 3, 4
	)
	self.xmesh:setColorArray(
		0xff0000, 1,
		0x00ff00, 1,
		0x0000ff, 1,
		0xffff00, 1
	)
--	self.xmesh:setPosition(64, 0, 0)
--[[
	-- imgui init
--	self.imgui = ImGui.new()
--	self.imgui = ImGui.new(myappwidth, myappheight)
	self.imgui = ImGui.new(true, true, false)
	self.io = self.imgui:getIO()
	-- imgui params
	self.io:setFontGlobalScale(1.7)
	-- creates some imgui windows
	self.window01 = false
]]
	-- order
	view1:setContent(self.xmesh)
	self:addChild(view1)
--	self:addChild(self.imgui)
	-- let's go!
--[[
	self:onWindowResize()
	self.imgui:setAutoUpdateCursor(true)
	self.imgui:captureMouseFromApp(true)
--	self.io:addConfigFlags(ImGui.ConfigFlags_DockingEnable)
]]
	-- LISTENERS
	self:addEventListener("applicationResize", self.onWindowResize, self)
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- GAME LOOP
function Plotter:onEnterFrame(e)
	self.imgui:newFrame(e)
	if (self.window01) then
		local mainWindowDrawn = false
		self.window01, mainWindowDrawn = self.imgui:beginWindow( -- begin window
			"Table", -- main window title
			self.window01 -- main window is expanded
		)
		if (mainWindowDrawn) then -- the variable is false when main window is collapsed
			self.imgui:text("Vertices") -- we add a text element to our GUI
			self.imgui:text("Hello Dear ImGui!") -- we add a text element to our GUI
		end
		self.imgui:endWindow()
	end
	self.imgui:endFrame()
	self.imgui:render()
end

-- EVENT LISTENERS
function Plotter:onWindowResize()
--	self.imgui:setPosition(-32, 0)
--	self.io:setDisplaySize(myappwidth, myappheight)
end
function Plotter:onTransitionInBegin()
--	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Plotter:onTransitionInEnd() self:myKeysPressed() end
function Plotter:onTransitionOutBegin() self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Plotter:onTransitionOutEnd() end

-- KEYS HANDLER
function Plotter:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then
--			scenemanager:changeScene("menu", 1, transitions[2], easing.outBack)
		end
	end)
end
