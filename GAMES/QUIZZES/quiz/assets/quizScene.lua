quizScene = Core.class(Sprite)

local myScene

local myArr = {}
local index = 1
local myQuestions = {"question1",
			"it is a very long question just to test it is a very long question just to test it is a very long question just to test question2",
			"question3",
			"question4",
			"question5",
			"question6",
			"question7",
			"question8"}
local isTween = false
local answers = {
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
	{"answer1","answer2","answer3","answer4"},
}

local correctAnswers = {"answer1","answer2","answer3","answer4","answer2","answer1","answer1","answer3","answer1",}

local function loadQuestions(direction)
	local myQuestion = TextWrap.new(myQuestions[index], 420, "justify",5,mySmallFont)
	myQuestion:setLineSpacing(5)
	
	myQuestion:setPosition(10,50)
	if direction == "right" then
		myQuestion:setPosition(1024,50)
	elseif direction == "left" then
		myQuestion:setPosition(-500,50)
	else
	
	end
	
	myScene:addChild(myQuestion)
	table.insert(myArr,myQuestion)
	local myTween = GTween.new(myQuestion,1,{x = 10,y=50},{dispatchEvents = true})
	isTween = true
	myTween:addEventListener("complete", function()
		
		for i=#myArr,1,-1 do
			if myArr[i]:getX() > 1024 or myArr[i]:getX() < 0 then
				myScene:removeChild(myArr[i])
				table.remove(myArr,i)
			end
		end
		isTween = false
	end)
	for i=1,4 do
		local myAnswers = TextField.new(mySmallFont,answers[index][i])
		myAnswers.name = "answer"
		myAnswers.isSelected = false
		myAnswers:setPosition(-110+i*120,210)
		table.insert(myArr,myAnswers)
		myScene:addChild(myAnswers)
		myAnswers:addEventListener(Event.MOUSE_DOWN,onMouseDown,myAnswers)
		if direction == "right" then
			myAnswers:setPosition(myAnswers:getPosition()+1024,210)
		elseif direction == "left" then
			myAnswers:setPosition(myAnswers:getPosition()-500,210)
		else
		
		end
		GTween.new(myAnswers,1,{x = -110+i*120,y=210})
	end
end

function onMouseDown(self,event)
	if self:hitTestPoint(event.x,event.y) and isTween == false then
		if self.name == "next" then
			if index < #myQuestions then
				index = index + 1
				for i=1,#myArr do
					GTween.new(myArr[i],1,{x = -500})
				end
				loadQuestions("right")
			else
				print("can't go next")
			end
			
		elseif self.name == "prev" then
			
			if index > 1 then
				index = index - 1
				for i=1,#myArr do
					GTween.new(myArr[i],1,{x = 1024+myArr[i]:getX()})
				end
				loadQuestions("left")
			else
				print("can't go back")
			end
			
		elseif self.name == "choose" then
			for i=1,#myArr do
				if myArr[i].name == "answer" then
					if myArr[i].isSelected == true then
						if correctAnswers[index] == myArr[i]:getText() then
							print("correct answer")
						else 
							print("wrong answer")
						end
					end
				else
					print("plz select the answer")
				end
			end
		elseif self.name == "answer" then
			for i=1,#myArr do
				if myArr[i].name == "answer" then
					myArr[i].isSelected = false
					myArr[i]:setTextColor(0x000000)
				end
			end
			self:setTextColor(0x00ff00)
			self.isSelected = true
		end
	end
end

function quizScene:init(t)
	myScene = self
	
	local w,h = 480,320
	
	local myNextBtn = TextField.new(mySmallFont,"Next")
	myNextBtn.name = "next"
	myNextBtn:setPosition(w-myNextBtn:getWidth()-10,h-myNextBtn:getHeight())
	
	local myPrevBtn = TextField.new(mySmallFont,"Prev")
	myPrevBtn.name = "prev"
	myPrevBtn:setPosition(0,h-myPrevBtn:getHeight())
	
	local myChooseBtn = TextField.new(mySmallFont,"confirm Answer")
	myChooseBtn.name = "choose"
	myChooseBtn:setPosition(240-myChooseBtn:getWidth()*0.5,h-myChooseBtn:getHeight())
	self:addChild(myNextBtn)
	self:addChild(myPrevBtn)
	self:addChild(myChooseBtn)
	myNextBtn:addEventListener(Event.MOUSE_DOWN,onMouseDown,myNextBtn)
	myPrevBtn:addEventListener(Event.MOUSE_DOWN,onMouseDown,myPrevBtn)
	myChooseBtn:addEventListener(Event.MOUSE_DOWN,onMouseDown,myChooseBtn)
	
	loadQuestions()
	
end
