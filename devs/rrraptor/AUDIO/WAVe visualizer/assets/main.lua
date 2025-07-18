require "lfs"
require "ImGui"
require "microphone"


ui		= ImGui.new()
Style	= ui:getStyle()
IO		= ui:getIO()
stage:addChild(ui)

RangeStart		= 0
RangeEnd		= 1
FileLoading		= false
FileReady		= false
FileSelected	= 2
GraphWidth		= 1024
GraphHeight		= 256
ShowLoading		= false
UsePointsGraph	= false
UseHistogram	= false
PointsAutoAdj	= true

MicSettings		= {
	fname = "tesetRecording",
	sampleRate = 44100,
	numChannels = 2,
	bitsPerSample = 2, -- 1=8, 2=16
	quality = 1,
	recordTime = 10,
}

MicTimeStart	= 0
MicPeakAmp		= 0
MicCurrentAmp	= 0
MicPauseTime	= 0
MicPaused		= false -- track by myself because "Mic" object does not exist until you hit "Record" button
MicRecording	= false
MicFileOutput	= false
MicPoints		= {}

ImageTexture	= nil -- RenderTarget
Points			= nil -- table of points per channel ({ {channel 1 points}, {channel 2 points} }
FileError		= nil -- io.open() error message

local function getFiles(ext, ...)
	ext = ext:lower()
	local t = {}
	local stack = {...}
	
	while #stack > 0 do
		local path = table.remove(stack)
		
		for file in lfs.dir(path) do
			if file == '.' or file == '..' then
				continue
			end
			
			local fpath = `{path}/{file}`
			local attrib = lfs.attributes(fpath)
			
			if attrib.mode == 'directory' then
				stack[#stack + 1] = fpath
			elseif attrib.mode == 'file' then
				local dotExt = file:match("%.[^.]*$")
				if dotExt:sub(2):lower() == ext then
					t[#t + 1] = fpath
				end
			end
		end
	end
	
	return t
end

function scanFiles()
	SoundFiles = getFiles("wav", "|R|", "|D|")
	assert(#SoundFiles > 0, "No WAV files found...")
end

function map(n, start1, stop1, start2, stop2, withinBounds)
	local v = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2
	
	if not withinBounds then
		return v
	end
	
	if (start2 < stop2) then
		return v <> start2 >< stop2
	else
		return v <> stop2 >< start2
	end
end

function updateWave(width, height, start, finish, data)
	ShowLoading = true
	
	if UsePointsGraph then
		Points = updatePoints(width, height, start, finish, data)
	else
		ImageTexture = updateGraph(width, height, start, finish, data)
	end
	
	ShowLoading = false
end

function updateGraph(desiredWidth, height, start, finish, data)
	local padding = 4
	local ampMin = data.ampMin
	local ampMax = data.ampMax
	local channels = data.channelNum
	local arr = data.samples
	local realLen = #arr
	local halfHeight = height * 0.5
	
	if desiredWidth > realLen then 
		desiredWidth = realLen 
	end
	
	local viewLen = finish - start
	local len = math.floor(realLen * viewLen)
	
	local samplesCount = len / channels
	local interval = samplesCount // desiredWidth
	if interval == 0 then interval = 1 end
	
	local startIdx = math.floor(realLen * start)
	local rtHeight = (height + padding * 2) * channels
	local rtWidth = desiredWidth + padding * 2
	local rt = RenderTarget.new(rtWidth, rtHeight)
	rt:clear(0, 1)
	--[[
	-- draw padding
	rt:clear(0xa0a0a0, 1, 0, 0, rtWidth, padding)
	rt:clear(0xa0a0a0, 1, 0, 0, padding, rtHeight)
	rt:clear(0xa0a0a0, 1, 0, rtHeight - padding, rtWidth, padding)
	rt:clear(0xa0a0a0, 1, rtWidth - padding, 0, padding, rtWidth)
	rt:clear(0xa0a0a0, 1, 0, rtHeight * 0.5 - padding, rtWidth, padding * 2)
	--]]
	
	-- fit samples into screen pixels
	for ch = 1, channels do
		for i = 0, desiredWidth - 1 do
			local v = 0
			
			-- calculate samples avg
			for j = i * interval, (i + 1) * interval - 1 do
				local idx = startIdx + j * channels + ch
				
				if idx > startIdx + len then
					break
				end
				
				v += arr[idx]
			end
			v /= interval
			local x = padding + i
			local clamped = map(v, ampMin, ampMax, -1, 1, true)
			local h = (math.abs(clamped) * halfHeight) <> 1
			local y = padding * ch + halfHeight - h * 0.5 + (ch - 1) * height
			
			rt:clear(0xffffff, 1, x, y, 1, h)
		end
		rt:clear(0xa0a0a0, 1, 0, padding * ch + halfHeight + height * (ch - 1), rtWidth, 2)
	end
	
	return rt
end

function updatePoints(desiredWidth, height, start, finish, data)
	local ampMin = data.ampMin
	local ampMax = data.ampMax
	local channels = data.channelNum
	local arr = data.samples
	local realLen = #arr
	
	if desiredWidth > realLen then desiredWidth = realLen end
	
	local viewLen = finish - start
	local len = math.floor(realLen * viewLen)
	
	local interval = (len / channels) // desiredWidth
	if interval == 0 then interval = 1 end
	local startIdx = math.floor(realLen * start)
	
	local points = {}
	for k = 1, channels do
		points[k] = {}
	end
	
	for i = 0, desiredWidth - 1 do
		for ch = 1, channels do
			local t = points[ch]
			local v = 0
			
			for j = i * interval, (i + 1) * interval - 1 do
				local idx = startIdx + j * channels + ch
				
				if idx > startIdx + len then
					break
				end
				
				v += arr[idx]
			end
			
			t[#t + 1] = v / interval
		end
	end
	
	return points
end

-- async
function startReadingCurrentFile()
	ImageTexture = nil
	Points = nil
	FileLoading = false
	
	Core.asyncCall(function()
		FileError = nil
		FileLoading = true
		FileReady = false
		
		local ok, errorMsg = pcall(function()
			local path = SoundFiles[FileSelected + 1]
			WaveFile = WAVreader.new(path)
		end)
		
		FileLoading = false
		
		if ok then
			FileReady = true
			updateWave(GraphWidth, GraphHeight, RangeStart, RangeEnd, WaveFile)
		else
			FileError = errorMsg
		end
	end)
end

function micListener(e)
	MicCurrentAmp = e.averageAmplitude
	MicPeakAmp = e.peakAmplitude
	MicPoints[#MicPoints + 1] = e.averageAmplitude
end

function onEnterFrame(e)
	local dt = e.deltaTime
	ui:newFrame(dt)
	
	if ui:beginFullScreenWindow("WAV visualizer") then
		local availW, availH = ui:getContentRegionAvail()
		-- tabs
		
		ui:beginTabBar("Body")
		
		if ui:beginTabItem("Files") then
			ui:pushItemWidth(availW - 120)
			local fileChanged = false
			
			
			ui:beginDisabled(FileLoading)
				
				if ui:button("Refresh files", availW) then
					scanFiles()
				end
				
				FileSelected, fileChanged = ui:combo("File", FileSelected, SoundFiles)
				
				local openClicked = ui:button("Open", availW)
				
				local clicked = false
				UsePointsGraph, clicked = ui:checkbox("Use points graph", UsePointsGraph)
				
				if UsePointsGraph then
					ui:sameLine()
					UseHistogram = ui:checkbox("Use histogram", UseHistogram)
					ui:sameLine()
					PointsAutoAdj = ui:checkbox("Auto adjust points min & max", PointsAutoAdj)
				end
				
				if openClicked or clicked or fileChanged then
					startReadingCurrentFile()
				end
			ui:endDisabled()
			
			if FileReady then
				ui:textColored("File is ready", 0x00ff00, 1)
			elseif FileLoading then
				ui:textColored("Reading file...", 0xe6a400, 1)
			else
				ui:textColored("File is NOT ready", 0xff0000, 1)
			end
			
			if FileError then
				ui:textColored(FileError, 0xff0000, 1)
			end
			
			local changedX, changedY, changedRange = false
			
			ui:beginDisabled(not FileReady)
				GraphWidth,  changedX = ui:sliderInt("Image width",  GraphWidth,  128, 4096)
				GraphHeight, changedY = ui:sliderInt("Image height", GraphHeight, 128, 4096)
				RangeStart, RangeEnd, changedRange = ui:dragFloatRange2("View range", RangeStart, RangeEnd, 0.0001, 0, 1, nil, nil, ImGui.SliderFlags_AlwaysClamp)		
			ui:endDisabled()
			
			if WaveFile then
				ui:text("Amp min:") ui:sameLine()
				ui:text(WaveFile.ampMin)
				ui:text("Amp max:") ui:sameLine()
				ui:text(WaveFile.ampMax)
			end
			
			if changedX or changedY or changedRange then
				Core.asyncCall(updateWave, GraphWidth, GraphHeight, RangeStart, RangeEnd, WaveFile)
			end
			
			if ShowLoading then
				ui:text("Loading...")
			end
			
			if ImageTexture and not ShowLoading then
				ui:scaledImage("WAVE", ImageTexture, availW, GraphHeight, ImGui.ImageScaleMode_Stretch)
			end
			
			if Points and not ShowLoading then
				local scaleMin = 0
				local scaleMax = 0
				
				if PointsAutoAdj then
					scaleMin = nil
					scaleMax = nil
				else
					scaleMin = WaveFile.ampMin
					scaleMax = WaveFile.ampMax
				end
				
				for i, points in ipairs(Points) do
					if UseHistogram then
						ui:plotHistogram(`CH {i}`, points, nil, nil, scaleMin, scaleMax, 0, GraphHeight)
					else
						ui:plotLines(`CH {i}`, points, nil, nil, scaleMin, scaleMax, 0, GraphHeight)
					end
				end
			end
			
			ui:popItemWidth()
			
			ui:endTabItem()
		end
		
		if ui:beginTabItem("Microphone") then
			ui:beginDisabled(MicRecording)
				MicSettings.sampleRate		= ui:sliderInt("Sample rate", MicSettings.sampleRate, 4000, 44100)
				MicSettings.numChannels		= ui:sliderInt("Channels", MicSettings.numChannels, 1, 2)
				MicSettings.bitsPerSample	= ui:sliderInt("Bits per sample", MicSettings.bitsPerSample, 1, 2, MicSettings.bitsPerSample * 8)
				MicSettings.quality			= ui:sliderFloat("Quality", MicSettings.quality, 0.1, 1)
				MicSettings.recordTime		= ui:sliderFloat("Record time (in s.)", MicSettings.recordTime, 1, 60)
			ui:endDisabled()
			
			ui:beginDisabled(MicRecording)
			MicFileOutput = ui:checkbox("Output to file", MicFileOutput)
			ui:endDisabled()
			
			ui:beginDisabled(not MicFileOutput)
				MicSettings.fname = ui:inputText("File name", MicSettings.fname, 1024)
			ui:endDisabled()
			
			ui:pushStyleVar(ImGui.StyleVar_FramePadding, 10, 10)
			
			local spX = Style:getItemSpacing()
			local btnW = (availW - spX * 2) / 3
			
			ui:beginDisabled(MicRecording)
				if ui:button("Record", btnW) then
					if Mic then
						Mic:removeEventListener(Event.DATA_AVAILABLE, micListener)
						Mic = nil
					end
					
					Mic = Microphone.new(nil, MicSettings.sampleRate, MicSettings.numChannels, MicSettings.bitsPerSample * 8, MicSettings.quality)
					Mic:addEventListener(Event.DATA_AVAILABLE, micListener)
					MicPoints = {}
					MicRecording = true
					MicTimeStart = ui:getTime()
					
					if MicFileOutput then
						Mic:setOutputFile(`|D|{MicSettings.fname}.wav`)
					end
					
					Mic:start()
				end
			ui:endDisabled()
			
			ui:sameLine()
			ui:beginDisabled(not MicRecording)
				if ui:button("STOP", btnW) then
					MicRecording = false
					MicPaused = false
					Mic:stop()
				end
				
				ui:sameLine()
				
				if MicPaused then
					if ui:button("Resume", btnW) then
						MicPaused = false
						Mic:setPaused(false)
					end
				else
					if ui:button("Pause", btnW) then
						MicPauseTime = ui:getTime()
						MicPaused = true
						Mic:setPaused(true)
					end
				end
			ui:endDisabled()
			
			if MicRecording then
				local frac = 0
				
				if MicPaused then
					frac = (MicPauseTime - MicTimeStart) / MicSettings.recordTime
				else
					local time = ui:getTime() - MicTimeStart
					frac = time / MicSettings.recordTime
				end
				
				ui:progressBar(frac, nil, nil, "Record time: %.2f")
				
				ui:progressBar(MicCurrentAmp)
				local minX, minY, maxX, maxY = ui:getItemRect()
				local list = ui:getWindowDrawList()
				local x = minX + MicPeakAmp * (maxX - minX)
				list:addLine(x, minY, x, maxY - 1, 0xff0000, 1)
				
				if frac >= 1 then
					MicRecording = false
					MicPaused = false
					Mic:stop()
				end
			end
			
			if #MicPoints > 0 then
				ui:plotLines("MicInput", MicPoints, nil, nil, 0, 1, 0, 256)
			end
			
			ui:popStyleVar()
			ui:endTabItem()
		end
		
		ui:endTabBar()
	end
	ui:endWindow()
	
	--ui:showDemoWindow()
	
	ui:render()
	ui:endFrame()
end

function onAppResize(self, e)
	local minX, minY, maxX, maxY = application:getLogicalBounds()
	ScreenW = maxX - minX
	ScreenH = maxY - minY
	IO:setDisplaySize(ScreenW, ScreenH)
	ui:setPosition(minX, minY)
end

scanFiles()
startReadingCurrentFile()
onAppResize()
stage:addEventListener("applicationResize", onAppResize)
stage:addEventListener("enterFrame", onEnterFrame)
