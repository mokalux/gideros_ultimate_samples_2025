ROBOTO_FONT = TTFont.new("Roboto-Regular.ttf",24)
local dialogBox, dialogText, delayedPic

dialogBox=Bitmap.new(Texture.new("dialogBox.png",true))
dialogBox:setPosition(20,40)
stage:addChild(dialogBox)

dialogText=TextField.new(ROBOTO_FONT, "")
dialogText:setPosition(30,45)
dialogBox:addChild(dialogText)

delayedPic=Bitmap.new(Texture.new("calendar.png",true))
delayedPic:setPosition(330,100)
stage:addChild(delayedPic)
delayedPic:setVisible(false)

local function sayText(content)
	for i=1, utf8.len(content) do
		--if i==100 then delayedPic:setVisible(true) end	--though we expect it to be shown earlier, there's significant delay, it shows after all text is finished
		Core.yield(0.03)
		dialogText:setText(utf8.sub(content,1,i))
	end
	
	delayedPic:setVisible(true)
end

--[[ When we use english characters, pic appears without delay:
Core.asyncCall(sayText,"Hello there,\nI'm testing delay.\nPic should appear\nimmediately after\ntext finished.")
]]

-- With non-english characters there's delay:
Core.asyncCall(sayText,"Привет,\nтестируем задержку\nкартинка появится\nсразу после\nокончания диалога.")
