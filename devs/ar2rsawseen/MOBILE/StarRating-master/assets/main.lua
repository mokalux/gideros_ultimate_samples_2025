
local text = TextField.new(nil, "Display rating: ")
text:setPosition(0,10)
stage:addChild(text)

local rating = StarRating.new()
--display rating
rating:display(2.5)
stage:addChild(rating)
rating:setPosition(0,20)


local text = TextField.new(nil, "Rating input: ")
text:setPosition(0,100)
stage:addChild(text)


local rate = StarRating.new()
--allow to rate
--provides rating to callback function
rate:rate(function(rating)
	print(rating)
	rate:clear()
end)
stage:addChild(rate)
rate:setPosition(0,100)
