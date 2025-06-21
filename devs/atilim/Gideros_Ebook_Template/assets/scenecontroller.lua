sceneController =  gideros.class(Sprite)

local pages = {}
-- create a list of pages, to set their order of apperance. 
pages[1] = "Page0"
pages[2] = "Page1"
pages[3] = "Page2"
pages[4] = "Page3"
pages[5] = "Page4"

local leftx = 0
local lefty = 970
local rightx = 700
local righty = 970


function sceneController:init()
	self.scenes = SceneManager.new({ --scenes are defined
	["Page0"] = Page0, 	
	["Page1"] = Page1,
	["Page2"] = Page2,
	["Page3"] = Page3,
	["Page4"] = Page4,
})
	music = Sound.new("sound/music4.mp3")	
	
	local channel  = music:play(0, 1000)
	channel:setVolume(0.4)
	
	self:addChild(self.scenes)
	-- add the first page
	self.scenes:changeScene("Page0")
	self.pageNo = 1

	-- this is the button on the left. to go back
	self.left = Button.new(Bitmap.new(Texture.new("gfx/left-up.png")), Bitmap.new(Texture.new("gfx/left-down.png")))
	self.left:setPosition(leftx, lefty)
	self:addChild(self.left)

	-- thins is the button on the right, to go fprward. 
	self.right = Button.new(Bitmap.new(Texture.new("gfx/right-up.png")), Bitmap.new(Texture.new("gfx/right-down.png")))
	self.right:setPosition(rightx, righty)
	self:addChild(self.right)
	
	-- "click" event is mapped to the function of scenecontroller, self.leftClick
	-- when the "click" event is pressed, this function will be called.
	self.left:addEventListener("click", self.leftClick, self)
	self.right:addEventListener("click", self.rightClick, self)
	

end


function sceneController:leftClick()
	print(self.pageNo)
	-- previous index
	self.pageNo = self.pageNo - 1
	if self.pageNo < 1 then self.pageNo = 1 end	
	print(self.pageNo)
	-- give next scene, the duration, the effect, and the easing mode. you can play with them to see how they look.
	self.scenes:changeScene(pages[self.pageNo],1, SceneManager.flipWithShade, easing.inBack) 
end 

function sceneController:rightClick()
	self.pageNo = self.pageNo + 1
	if self.pageNo > 5 then self.pageNo = 1 end
		
	self.scenes:changeScene(pages[self.pageNo],1, SceneManager.flipWithFade, easing.inBack) 
end 
