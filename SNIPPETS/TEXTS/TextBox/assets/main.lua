
application:setBackgroundColor(0x000000)

local textBox = TextBox.new({
  text = "This is a TextBox. It contains text that is automatically split into multiple lines"..
	" #color# 0xffff00 and of course #color# 0xffffff every #color# 0x0066ff word #color# 0x33ff55 can #color# 0x33ffff be"..
	" #color# 0xff66ff individually #color# 0x00ff00 colored. #color# 0x00f000 Then there are line breaks which make life..."..
	" #n# #n# so much easier!!!"..
	" #n# #n# #color# 0xf00000 #align# right Lets align the text to the right #n#"..
	" It looks pretty good this way #n# #n# #align# center #color# 0x4080d0 but centered text #n# is always good"..
	" also #n# #n# #color# 0xf0f0f0 #align# left Well that's a wrap :)",
})
textBox:setScale(2.75)
stage:addChild(textBox)

-- recolor all occurences of "is" to the color magenta
textBox:recolor("is", 0xff00ff, true)

-- recolor the first occurence of "the" to the color cyan
textBox:recolor("the", 0x00ffff)
