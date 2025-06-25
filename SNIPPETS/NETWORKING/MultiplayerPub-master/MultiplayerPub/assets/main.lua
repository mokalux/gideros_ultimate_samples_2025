--function Networking:init(channelName, func, param)
local networking = Networking.new("test_channel", nil, {msg="hello",})

stage:addEventListener(Event.ENTER_FRAME, function(e)
	networking:update()
end)


--[[
        if self.secret_key then
            signature = crypto.digest( crypto.md5, table.concat( {
                self.publish_key,
                self.subscribe_key,
                self.secret_key,
                channel,
                message
            }, "/" ) )
        end
]]
stage:addEventListener(Event.KEY_DOWN, function(e) -- azerty
	if e.keyCode == KeyCode.A then
		print(networking.myPlayer.id)
	elseif e.keyCode == KeyCode.Z then
		networking:send(
			{
				channel = "test_channel",
				message = {
					"hello world!",
				},
			}
		)
	elseif e.keyCode == KeyCode.E then
		print(networking.lastMessage)
	end
end)
