

lines ={}

lines[1] = 
{
	text = {"Now", "that", "lilacs", "are", "in", "bloom"	},
	x = 40,
	y = 60
}

lines[2] = 
{
	text = {"She", "has", "a", "bowl" ,"of" ,"lilacs", "in" ,"her" ,"room"	},
	x = 40,
	y = 100
}


myFont = Font.new("i_36.txt", "i_36.png")

textFieldList = {}
textSprite = Sprite.new()

function loadTextData(screen)
	for i=1, #lines do 
		data = lines[i].text
		local nextX = lines[i].x    --line start x
		local nextY = lines[i].y    --line y
		for k = 1, #data do
			textfield = TextField.new(myFont, data[k] )
			textfield:setTextColor(0x000000)
			textfield.x1 = nextX    --the destination X of the word
			textfield.y1 = nextY    --the destination Y of the word
			if (i== 1) then 
				textfield:setX(nextX - 400)   -- if you do only this line, the words come from left.
				textfield:setY(nextY - 400)   -- if you do only this line, the words come from top.
			elseif (i == 2)  then
				textfield:setX(nextX + math.random(-200, 200))  
				textfield:setY(nextY + math.random(-200, 200))			
			end 
			textfield:setAlpha(0)
			textSprite:addChild(textfield)
			textFieldList[#textFieldList + 1] = textfield		
			nextX = nextX + textfield:getWidth()+ 14
		end	
	end 	
	screen:addChild(textSprite)
end 



local back =  Bitmap.new(TextureRegion.new(Texture.new("19_fon.png", true)))
loadTextData(back)

function onMouseDown(event)
	print(event)
	for i = 1, #textFieldList do
		GTween.new(textFieldList[i], 0.5, {x = textFieldList[i].x1, y= textFieldList[i].y1, alpha=1, scaleX = 1, scaleY = 1 }, {delay = i * 0.3, ease = easing.inExponential } )
	end 
end 

back:addEventListener(Event.MOUSE_DOWN, onMouseDown) 


stage:addChild(back)

