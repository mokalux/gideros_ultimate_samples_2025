print("initial test")


local e = EndlessBackground2D.new()



local scaleFactor = 2

local anchorX = 0.0
local anchorY = 0.0


local container = Sprite.new()

container:addChild(e)


container:setPosition((application:getDeviceWidth() - container:getWidth())*anchorX,
			  (application:getDeviceHeight() - container:getHeight())*anchorY )

container:setScale((application:getDeviceHeight()*scaleFactor)/container:getHeight(),
		   (application:getDeviceHeight()*scaleFactor)/container:getHeight()
)


stage:addChild(container)

stage:addEventListener(Event.ENTER_FRAME,
					   function()
					   
							
							e:moveBy(1,1)   
					   end
					   
					   )
