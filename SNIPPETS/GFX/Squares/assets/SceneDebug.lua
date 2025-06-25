
SceneDebug = gideros.class(Sprite)


function SceneDebug:init()


	local padding = 5

	self.sprite = Sprite.new()
	
	self.txt_kb = TextField.new(nil, "0 kB")
	self.sprite:addChild(self.txt_kb)

	self.txt_fps = TextField.new(nil, "0 fps")
	self.txt_fps:setY( self.txt_kb:getHeight() + padding )
	self.sprite:addChild(self.txt_fps)
	
	local x = padding
	local y = padding + self.txt_kb:getHeight()
	self.sprite:setPosition(x,y)
	
	self:addChild( self.sprite )
	self.timer = 0
	
	self:update()
	

	
end

function SceneDebug:update()

	if self.frame_counter == 60 or self.frame_counter == nil then

		local bytes = collectgarbage("count")
		local toInt = function(n)
			local s = tostring(n)
			local i, j = s:find('%.')
			if i then
				return tonumber(s:sub(1, i-1))
			else
				return n
			end
		end		
		bytes = toInt(bytes) .. " kB"
		self.txt_kb:setText( bytes )
		
		local fps = toInt(60 / (os.timer()-self.timer))
		fps = fps .. " fps"
		self.txt_fps:setText(fps)
		
		self.frame_counter = 0
		
		self.timer = os.timer()
				
	end

	self.frame_counter = self.frame_counter + 1

	
end
