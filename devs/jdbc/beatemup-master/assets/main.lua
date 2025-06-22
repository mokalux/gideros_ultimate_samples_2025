application:setKeepAwake(true)

-- local client_async = require ("websocket.client_async")

local ColyseusClient = require "colyseus.client"

--local client = ColyseusClient.new("ws://localhost:2567")
--local client = ColyseusClient.new("127.0.0.1:8080")
--local client = ColyseusClient.new("ws://127.0.0.1:8080")
local client = ColyseusClient.new("ws://localhost:8080")
if (client) then
	print("Created client >> Endpoint "..client.hostname);
	
	-- join chat room
    client:join_or_create("chat", {}, function(err, _room)
		if err then
			print("JOIN ERROR: " .. err)
			return
		end
		
		print("Joined to room")
		room = _room
    end)
end

--[[local ws=WebSocket.new("ws://echo.websocket.org")
ws:send("Stuff")
print(ws:receive())
]]--

local function enter_frame() 

	client:loop()
	--client:loop(1)
	--print("update")
end

stage:addEventListener(Event.ENTER_FRAME, enter_frame)