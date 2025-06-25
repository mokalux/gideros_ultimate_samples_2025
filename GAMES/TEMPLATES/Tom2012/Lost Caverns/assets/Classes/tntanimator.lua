-- ######################################## --
-- TNT Animator Sudio v1.18                 --
-- Copyright (C) 2012 By Gianluca D'Angelo  --
-- All right Reserved.                      --
-- YOU CAN USE IN FREE OR COMMERCIAL GAMES  --
-- PLEASE DONATE TO KEEP THIS PROJECT ALIVE --
-- ---------------------------------------- --
-- for bug, tips, suggestion contact me at  --
-- gregbug@gmail.com or                     --
-- support@tntparticlesengine.com           --
-- ---------------------------------------- --
-- coded for Gideros Mobile SDK             --
-- ######################################## --

----v 1.18 Piretro 24/10/2016
--added CTNTAnimator:free(all) --if parameter exists clear _animations completely and remove the EnterFrame eventListener 

--v 1.17 Piretro 24/10/2016
--removed many EventListeners in favor of a single global eventListener (added to stage, and removed by CTNTAnimator:free())

--v 1.16 Pietro 05/07/2016
--Can use callbacks instead of events (retrocompatible, can handle both)
--CTNTAnimator:callbackDo(action, event, callback)
--action = "add" "remove" "clear"
--event = ANIM_CHANGE, ANIM_START... (all documented tnt events)
--callback = function to trigger on event: same values of default tnt events are returned

--[[USAGE EXAMPLE:
local function myCallbackFunction(e)
	print(e.animationName, e.previousAnimationName )
end
self.anim:callbackDo("add", "ANIM_CHANGE", myCallbackFunction )
]]


-- v1.15 04/12/2012

-- CTNTAnimator:setVisible(isVisible) isVisible default = true
-- CTNTAnimator:getCurrentFrame() - return current frame animation. (Asked by tom2012)
-- CTNTAnimator:pauseAnimation() -- pause current animation (Asked by tom2012)
-- CTNTAnimator:unPauseAnimation() -- unpause current animation (Asked by tom2012)


-- v1.1 Beta 4 11/09/2012
----------------------------------------------------------------
-- v1.1 Beta3 04/09/2012
-- ++ BUG SOLVED if No Stop Frame defined in Editor for an animation = Error on self.anim.free()
----------------------------------------------------------------
-- v1.1 Beta2 rev.2 04/09/2012
-- ++ BUG SOLVED self:anim:setLoop() 
-- now if loop is set to false animator play all animation frames and stop on last frame if not "stopOnFrame" is defined. 
-- if StopOnFrameIs defined it play all animation frames and then stop one fame defined in "stopOnFrame".
-- ++ Added function CTNTAnimator::stopOnFrame(FrameNumber) - is like in Editor StopOnFrame but "via Code"
-- ++ Added function CTNTAnimator:animationExists(animationName) - release true if exists else release false.
-- ++ Improved ANIM_CHANGE Event now release also previous animation name
-- so you'll get 
-- animationName = name of animation you changed to
-- previousAnimationName = previous animation name.
-- (see example 2)
----------------------------------------------------------------
-- v1.1 Beta 130/08/2012
-- Corrected bug in GetSpeed that return speed in secs not millisecs. Thanks to Mells!
----------------------------------------------------------------
-- v1.04 22/08/2012
-- Added check for Animation in setAnimation and release a nice error log if animation not found. ;) thanks to mells!
-- Corrected a Bug in PlayAnimation that if a StopFrame is definided in a non loop animation animation wont start. (reported by draconar)
-- function CTNTAnimator:addToParent(parentGroup) added and CTNTAnimator:addChildAnimation(parentGroup) NOW DEPRECATED!!!!
----------------------------------------------------------------
-- v1.03 30/07/2012
-- ! Free() "C stack overflow" error Fixed - report by ar2rsawseen 
-- + internal reference to animation sprites changed from .mClip to .sprite
-- + Added new Event "ANIM_NEWLOOP" animation loop restart. release every new anim loop is restarted.
-- + Added new function "getSpriteHandle" that return anim sprite handle
-- (is like direct accesing to CTNTAnimator.sprite) and so you can apply
-- all Gideros sprite transformations and effects (ex: setRotation, setColorTransformm, etc)
----------------------------------------------------------------
-- v1.01 26/07/2012
-- Fixed setVisible() and isVisible() - report by ar2rsawseen 
-- Fixed Animation:Free() - report by ar2rsawseen 
-- Added new Event "ANIM_FREE" released when an animation is free.
----------------------------------------------------------------

-- ################################################################################################
-- XML READER Class derived from code
-- by Jonathan Beebe
-- on tutorial "How to use XML files in Corona"
-- original article and code at http://blog.anscamobile.com/2011/07/how-to-use-xml-files-in-corona/
-- ################################################################################################

local CxmlReader = Core.class()
local osTimer = os.timer

function CxmlReader:init()
    self.xmlParser = {}
    return self.xmlParser
end

function CxmlReader:free()
    self.xmlParser = {}
    self.xmlParser = nil
    return nil
end

function CxmlReader:ToXmlString(value)
    self.value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
    self.value = string.gsub(self.value, "<", "&lt;"); -- '<' -> "&lt;"
    self.value = string.gsub(self.value, ">", "&gt;"); -- '>' -> "&gt;"
    self.value = string.gsub(self.value, "\"", "&quot;"); -- '"' -> "&quot;"
    self.value = string.gsub(self.value, "([^%w%&%;%p%\t% ])",
        function(c)
            return string.format("&#x%X;", string.byte(c))
        end);
    return self.value;
end

function CxmlReader:FromXmlString(value)
    self.value = string.gsub(value, "&#x([%x]+)%;",
        function(h)
            return string.char(tonumber(h, 16))
        end);
    self.value = string.gsub(self.value, "&#([0-9]+)%;",
        function(h)
            return string.char(tonumber(h, 10))
        end);
    self.value = string.gsub(self.value, "&quot;", "\"");
    self.value = string.gsub(self.value, "&apos;", "'");
    self.value = string.gsub(self.value, "&gt;", ">");
    self.value = string.gsub(self.value, "&lt;", "<");
    self.value = string.gsub(self.value, "&amp;", "&");
    return self.value;
end

function CxmlReader:ParseArgs(s)
    self.arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
        self.arg[w] = self:FromXmlString(a);
    end)
    return self.arg
end

function CxmlReader:ParseXmlText(xmlText)
    self.stack = {}
    self.top = { name = nil, value = nil, properties = {}, child = {} }
    table.insert(self.stack, self.top)
    local ni, c, label, xarg, empty
    local i, j = 1, 1
    while true do
        ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w:]+)(.-)(%/?)>", i)
        if not ni then break end
        self.text = string.sub(xmlText, i, ni - 1);
        if not string.find(self.text, "^%s*$") then
            self.top.value = (self.top.value or "") .. self:FromXmlString(self.text);
        end
        if empty == "/" then -- empty element tag
            table.insert(self.top.child, { name = label, value = nil, properties = self:ParseArgs(xarg), child = {} })
        elseif c == "" then -- start tag
            self.top = { name = label, value = nil, properties = self:ParseArgs(xarg), child = {} }
            table.insert(self.stack, self.top) -- new level
        else -- end tag
            local toclose = table.remove(self.stack) -- remove top
            self.top = self.stack[#self.stack]
            if #self.stack < 1 then
                error("XmlParser: nothing to close with " .. label)
            end
            if toclose.name ~= label then
                error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
            end
            table.insert(self.top.child, toclose)
        end
        i = j + 1
    end
    local text = string.sub(xmlText, i);
    if not string.find(text, "^%s*$") then
        stack[#stack].value = (stack[#stack].value or "") .. self:FromXmlString(text);
    end
    if #self.stack > 1 then
        error("XmlParser: unclosed " .. self.stack[self.stack.n].name)
    end
    return self.stack[1].child[1];
end

function CxmlReader:loadFile(xmlFileName)
    local hFile, err = io.open(xmlFileName, "r");
    if (not err) then
        local xmlText = hFile:read("*a"); -- read file content
        io.close(hFile);
        return self:ParseXmlText(xmlText), nil;
    else
        return nil, err;
    end
end

-- ################################################################################################
-- TNT Animation Loader Class
-- ################################################################################################

CTNTAnimatorLoader = Core.class()

---------------------------------
-- init Animation loader class --
---------------------------------
function CTNTAnimatorLoader:init()
    self.xml = CxmlReader.new()
    self.tempXmlFile = {} -- where all xml animator code is loaded and parsed
    self.sprites = {}
    self.animations = {
        loop = true,
        speed = 100,
        stopOnFrame = -1,
        excludeFromAnimation = false,
        framesCount = 0,
        frame = {} -- animations frames infos...
    } -- contains all animation and frame infos.. l
end

----------------------------
-- load animation project --
----------------------------
function CTNTAnimatorLoader:loadAnimations(fileName, texture, midHandle)
    local number = tonumber
    -- load xml animator file
    -------------------------
    self.tempXmlFile = self.xml:loadFile(fileName)
    -- if file not exists...
    ------------------------
    if self.tempXmlFile == nil then
        error("TNTAnimator Error: file '" .. fileName .. "' error loading file.", 2)
    end

    -- Check if texture is correct
    ------------------------------
    if texture == nil then
        error("TNTAnimator Error: texture error.", 2)
    end

    -- check if file is correct
    ---------------------------
    if self.tempXmlFile.name ~= "TNTANIMATOR" then
        error("TNTAnimator Error: file '" .. fileName .. "' unknow file format.", 2)
        -- to check version .. print(" ",self.tempXmlFile.properties["v"])
    end
    -- load all used sprites
    ------------------------------------------
    for j = 1, #self.tempXmlFile.child[1].child do
        self.sprites[j] = Bitmap.new(texture:getTextureRegion(self.tempXmlFile.child[1].child[j].value))
        if midHandle then
            self.sprites[j]:setAnchorPoint(.5, .5)
        end
    end
    -- load all animations...
    -------------------------
    for j = 2, #self.tempXmlFile.child do
        local tLoop, tExclude
        if number(self.tempXmlFile.child[j].properties["loop"]) == 0 then
            tLoop = false
        else
            tLoop = true
        end
        if number(self.tempXmlFile.child[j].properties["exclude"]) == 0 then
            tExclude = false
        else
            tExclude = true
        end

        self.animations[self.tempXmlFile.child[j].properties["name"]] = {
            loop = tLoop,
            speed = number(self.tempXmlFile.child[j].properties["speed"]) / 1000,
            excludeFromAnimation = tExclude,
            stopOnFrame = number(self.tempXmlFile.child[j].properties["stoponframe"]),
            framesCount = #self.tempXmlFile.child[j].child,
            frame = {}
        }
        -- load all animation frames info...
        ------------------------------------
        for jj = 1, #self.tempXmlFile.child[j].child do
            local tXFlip, tYFlip
            if number(self.tempXmlFile.child[j].child[jj].properties["XFLIP"]) == 0 then
                tXFlip = false
            else
                tXFlip = true
            end
            if number(self.tempXmlFile.child[j].child[jj].properties["YFLIP"]) == 0 then
                tYFlip = false
            else
                tYFlip = true
            end
            self.animations[self.tempXmlFile.child[j].properties["name"]].frame[jj] = {
                xFlip = tXFlip,
                yFlip = tYFlip,
                idx = number(self.tempXmlFile.child[j].child[jj].value)
            }
        end
    end
    -- free xml file (not needed from now)
    --------------------------------------
    self.xml = self.xml:free()
    self.xml = nil
    self.tempXmlFile = {}
    self.tempXmlFile = nil
    collectgarbage()
end

---------------------------
-- free animation object --
---------------------------
function CTNTAnimatorLoader:free()
    self.animations = {}
    self.animations = nil
    for j = 1, #self.sprites do
        self.sprites[j] = nil
    end
    self.sprites = {}
    self.sprites = nil
    collectgarbage()
    return nil
end

-- ################################################################################################
-- TNT Animation Class
-- ################################################################################################

CTNTAnimator = Core.class(Sprite)

-------------------------
-- init Animator class --
-------------------------
function CTNTAnimator:init(AnimatorLoader)
    self.loader = AnimatorLoader -- animation project info
    self.parentGroup = nil -- sprite parent group
    self.currentAnimation = "" -- current animation name (string)
    self.animation = nil -- current animation table pointer
    --self.nextUpdate = 0

    self.flippedX = false
    self.flippedY = false

    self.animationIsRunning = false

    self.tClip = {}
    for j = 1, #self.loader.sprites do
        self.tClip[j] = { j, j, self.loader.sprites[j] }
    end
    self.sprite = MovieClip.new(self.tClip)

    self.currentFrame = 1 -- current frame

    self.animRunning = false -- animation is running ?

    if self.loader == nil then
        error("TNTAnimator Error: null loader address", 3)
    end

    for j = 1, #self.tClip do
        self.tClip[j] = nil
    end
    self.tClip = {}
    self.tClip = nil
    collectgarbage()
	
	--adding _animations table only at first instance
	if not CTNTAnimator._animations then
		CTNTAnimator._animations = {}
		

		stage:addEventListener(Event.ENTER_FRAME, self.forAnimations)
	end
end

function CTNTAnimator:forAnimations()
	for i, v in pairs(CTNTAnimator._animations) do
		i:onEnterFrame()
	end
		
end

----------------------------------------
--callback management in one function
----------------------------------------
function CTNTAnimator:callbackDo(action, event, callback)
--action = "add" "remove" "clear"
--event = ANIM_CHANGE, ANIM_START...
--callback function to trigger on event

	--ADD CALLBACK: sprite:callbackDo("add", "ANIM_CHANGE", function()... )
	if action == "add" then
		if not self.callback then
			self.callback = {}
		end
		self.callback[event] = callback
		
	--REMOVE CALLBACK:  sprite:callbackDo("remove", "ANIM_CHANGE")	
	elseif action == "remove" then
		--remove defined event callback
		if self.callback[event] then
			self.callback[event] = nil
		end
		
	--CLEAR ALL CALLBACKS: sprite:callbackDo("clear")		
	elseif action == "clear" then
		--remove all defined callbacks
		if self.callback then
			self.callback = nil
		end
	end
end

-------------------------------------
--- return animation sprite handle --
-------------------------------------
function CTNTAnimator:getSpriteHandle()
    return self.sprite
end

-------------------------
-- free animator class --
-------------------------
function CTNTAnimator:free(all) --all boolean: if provided removes every animation from _animations AND the Enterframe eventListener
    if self.animationIsRunning then
        self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
        if self.animation.stopOnFrame == -1 then
            self.sprite:gotoAndStop(self.animation.frame[self.animation.framesCount].idx)
        else
            self.sprite:gotoAndStop(self.animation.frame[self.animation.stopOnFrame].idx)
        end
        self.animationIsRunning = false
    end
		--look for a callback
		if self.callback and self.callback["ANIM_FREE"] then
			local event = {}
			event.animationName = self.currentAnimation
			self.callback["ANIM_FREE"](event)
		else --default with event
			local freeEvent = Event.new("ANIM_FREE")
			freeEvent.animationName = self.currentAnimation
			self:dispatchEvent(freeEvent)
		end

    self.parentGroup:removeChild(self.sprite)
	self.callback = nil
    self.loader = nil
    self.sprite = nil
	--clear from _animations
			
	if all then
		CTNTAnimator._animations = nil
	else
		if CTNTAnimator._animations[self] then
			CTNTAnimator._animations[self] = nil
		end
	end
	--if _animations is empty remove the eventListener too
	if CTNTAnimator._animations == nil or not next(CTNTAnimator._animations) then
		stage:removeEventListener(Event.ENTER_FRAME, self.forAnimations)
	end
    collectgarbage()
    return nil
end

----------------------------------------------------------
-- get if animation is looped or not --
----------------------------------------------------------
function CTNTAnimator:getLoop()
    return self.animation.loop
end

----------------------------------------
-- set animation Loop On/Off  --
----------------------------------------
function CTNTAnimator:setLoop(setLoop)
    self.animation.loop = setLoop
end

-----------------------------------------
-- get animation "AnimationName" speed --
-----------------------------------------
function CTNTAnimator:getSpeed()
    return self.animation.speed * 1000
end

-----------------------------------------
-- set animation "AnimationName" speed --
-----------------------------------------
function CTNTAnimator:setSpeed(newSpeed)
    self.animation.speed = newSpeed / 1000
end

--------------------------------------
-- get "AnimationName" frames count --
--------------------------------------
function CTNTAnimator:getFrameCount()
    return self.animation.framesCount
end

---------------------------
-- set Current animation --
---------------------------
function CTNTAnimator:setAnimation(AnimationName)
    if AnimationName ~= self.currentAnimation then
        local previousAnimationName = self.currentAnimation
        self.currentAnimation = AnimationName
        self.animation = self.loader.animations[AnimationName]
        if self.animation == nil then
            error("TNTAnimator Error: Animation '" .. AnimationName .. "' not definited. Error in setAnimation('" .. AnimationName .. "').", 2)
        end
		
			--look for a callback
			if self.callback and self.callback["ANIM_CHANGE"] then
				local event = {}
				event.animationName = self.currentAnimation
				event.previousAnimationName = previousAnimationName
				self.callback["ANIM_CHANGE"](event)
			else --default with event
				local changeEvent = Event.new("ANIM_CHANGE")
				changeEvent.animationName = self.currentAnimation
				changeEvent.previousAnimationName = previousAnimationName
				self:dispatchEvent(changeEvent)
			end
        self.currentFrame = 1
        CTNTAnimator._animations[self] = osTimer()
        self.sprite:gotoAndStop(self.animation.frame[self.currentFrame].idx)
    end
end

-------------------------------------
-- release if animation is running --
-------------------------------------
function CTNTAnimator:animationRunning()
    return self.animationIsRunning
end

---------------------------
-- get current animation --
---------------------------
function CTNTAnimator:getAnimation()
    return self.currentAnimation
end

---------------------------------
-- get current animation frame --
---------------------------------
function CTNTAnimator:getCurrentFrame()
	return self.currentFrame
end

---------------------------------
-- set Animations Anchor point --
---------------------------------
function CTNTAnimator:setAnimAnchorPoint(xHandle, yHandle, animation)
    if animation ~= nil then
        local currentAnim = self:getAnimation()
        -- set anchor point only for animation frames sprites...
        self:setAnimation(animation)
        for j = 1, self.animation.framesCount do
            self.loader.sprites[self.animation.frame[j].idx]:setAnchorPoint(xHandle, yHandle)
        end
        self:setAnimation(currentAnim)
    else
        -- set anchor point for all sprites...
        for j = 1, #self.loader.sprites do
            self.loader.sprites[j]:setAnchorPoint(xHandle, yHandle)
        end
    end
end

--------------------------
-- add animation sprite --
--------------------------
function CTNTAnimator:addToParent(parentGroup)
    self.parentGroup = parentGroup
    -- set current frame on stopFrame (if defined or first frame)...
    if self.animation.stopOnFrame > 0 then
        self.currentFrame = self.animation.stopOnFrame
    else
        self.currentFrame = self.animation.framesCount
    end
    -- flip x or y and preserve user size!
    if self.animation.frame[self.currentFrame].xFlip then
        if (not self.flippedX) then
            self.sprite:setScaleX(-self.sprite:getScaleX())
            self.flippedX = true
        end
    else
        if (self.flippedX) then
            self.sprite:setScaleX(-self.sprite:getScaleX())
            self.flippedX = false
        end
    end
    if self.animation.frame[self.currentFrame].yFlip then
        if (not self.flippedY) then
            self.sprite:setScaleY(-self.sprite:getScaleY())
            self.flippedY = true
        end
    else
        if (self.flippedY) then
            self.sprite:setScaleY(-self.sprite:getScaleY())
            self.flippedY = false
        end
    end
    self.parentGroup:addChild(self.sprite)
    self.sprite:gotoAndStop(self.animation.frame[self.currentFrame].idx)
end

function CTNTAnimator:setVisible(isVisible)
	if isVisible == nil then
		isVisible = true
	end
    self.sprite:setVisible(isVisible)
end

function CTNTAnimator:isVisible()
    return self.sprite:isVisible()
end

-------------------------------------------------------
-- start play animation and raise "ANIM_START" event --
-------------------------------------------------------
function CTNTAnimator:playAnimation(playFromFrame)
    if not self.animationIsRunning then -- execute only if animation is not running
        if playFromFrame ~= nil then
            if playFromFrame > self.animation.framesCount then
                playFromFrame = self.animation.framesCount
            end
            self.currentFrame = playFromFrame
        else
            self.currentFrame = 1
        end
			--look for a callback
			if self.callback and self.callback["ANIM_START"] then
				local event = {}
				event.animationName = self.currentAnimation
				self.callback["ANIM_START"](event)
			else --default with event
				local startEvent = Event.new("ANIM_START")
				startEvent.animationName = self.currentAnimation
				self:dispatchEvent(startEvent)
			end
        self.animationIsRunning = true
        --self.nextUpdate = osTimer()
        --self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		CTNTAnimator._animations[self] = osTimer()
    end
end

------------------------------------------------
-- stop animation and raise "ANIM_STOP" event --
------------------------------------------------
function CTNTAnimator:stopAnimation(stopOnFrame)
    if self.animationIsRunning then -- stops only if animation is running
       -- self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	   CTNTAnimator._animations[self] = nil
        if stopOnFrame ~= nil then
            if stopOnFrame > self.animation.framesCount then
                stopOnFrame = self.animation.framesCount
            end
            self.sprite:gotoAndStop(self.animation.frame[stopOnFrame].idx)
        else
            -- if stop on frame not defined stop on last frame...
            if self.animation.stopOnFrame == -1 then
                self.sprite:gotoAndStop(self.animation.frame[self.animation.framesCount].idx)
            else
                self.sprite:gotoAndStop(self.animation.frame[self.animation.stopOnFrame].idx)
            end
        end
			--look for a callback
		if self.callback and self.callback["ANIM_STOP"] then
			local event = {}
			event.animationName = self.currentAnimation
			self.callback["ANIM_STOP"](event)
		else --default with event
			local stopEvent = Event.new("ANIM_STOP")
			stopEvent.animationName = self.currentAnimation
			self:dispatchEvent(stopEvent)
		end
        self.animationIsRunning = false
    end
end

------------------------------------------
-- Set "Via code" GUI stopOnFrame value --
-- asked by Mells                       --
------------------------------------------
function CTNTAnimator:stopOnFrame(frameNumber)
    if frameNumber > self.animation.framesCount then
        self.animation.stopOnFrame = self.animation.framesCount
    else
        self.animation.stopOnFrame = frameNumber
    end
    -- Change also in animation loader
    self.loader.animations[self:getAnimation()].stopOnFrame = self.animation.stopOnFrame
end

-----------------------------------------------------
-- Check if "animationName" exists and release
-- True (if exists)
-- False (if not)
-----------------------------------------------------
function CTNTAnimator:animationExists(animationName)
    local animationFond = self.loader.animations[animationName]
    if animationFond == nil then
        return false
    else
        return true
    end
end

----------------------------------------------------------
-- pause current animation and raise ANIM_PAUSED event. --
----------------------------------------------------------
function CTNTAnimator:pauseAnimation()
	if self.animationIsRunning then
		--look for a callback
		if self.callback and self.callback["ANIM_PAUSED"] then
			local event = {}
			event.animationName = self.currentAnimation
			self.callback["ANIM_PAUSED"](event)
		else --default with event
			local startEvent = Event.new("ANIM_PAUSED")
			startEvent.animationName = self.currentAnimation
			self:dispatchEvent(startEvent)
		end
        self.animationIsRunning = false
        --self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		CTNTAnimator._animations[self] = nil
	end
end

--------------------------------------------------------------
-- Unpause current animation and raise ANIM_UNPAUSED event. --
--------------------------------------------------------------
function CTNTAnimator:unPauseAnimation()
	if not self.animationIsRunning then
	--look for a callback
		if self.callback and self.callback["ANIM_UNPAUSED"] then
			local event = {}
			event.animationName = self.currentAnimation
			self.callback["ANIM_UNPAUSED"](event)
		else --default with event
			local startEvent = Event.new("ANIM_UNPAUSED")
			startEvent.animationName = self.currentAnimation
			self:dispatchEvent(startEvent)
		end
		self.animationIsRunning = true
		--self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		CTNTAnimator._animations[self] = osTimer()
	end
end

----------------------
-- update animation --
----------------------
function CTNTAnimator:onEnterFrame(event)
    -- update animation if correct time is passed... (only if is needed we update sprite animation)
    if CTNTAnimator._animations[self] and osTimer() > CTNTAnimator._animations[self] then
        if (self.currentFrame <= self.animation.framesCount) then
            -- check if stop frame is excluded by animation... if so skip this frame and go to next frame...
            if ((self.currentFrame == self.animation.stopOnFrame) and (self.animation.excludeFromAnimation)) then
                self.currentFrame = self.currentFrame + 1
                CTNTAnimator._animations[self] = osTimer() - 1
                self:onEnterFrame(event)
            end
            --  check for flip x or y axis and preserve user defined size! (flip only when needed not every frame update!)
            if self.animation.frame[self.currentFrame].xFlip then
                if (not self.flippedX) then
                    self.sprite:setScaleX(-self.sprite:getScaleX())
                    self.flippedX = true
                end
            else
                if (self.flippedX) then
                    self.sprite:setScaleX(-self.sprite:getScaleX())
                    self.flippedX = false
                end
            end
            if self.animation.frame[self.currentFrame].yFlip then
                if (not self.flippedY) then
                    self.sprite:setScaleY(-self.sprite:getScaleY())
                    self.flippedY = true
                end
            else
                if (self.flippedY) then
                    self.sprite:setScaleY(-self.sprite:getScaleY())
                    self.flippedY = false
                end
            end
            -- select new frame
            self.sprite:gotoAndStop(self.animation.frame[self.currentFrame].idx)
            -- update frame counter
            self.currentFrame = self.currentFrame + 1
            -- update timer next update will occur... now + next update time...
           CTNTAnimator._animations[self] = osTimer() + self.animation.speed
        else
            -- animation is ended so... if looped restart else stop animation... :)
            if self.animation.loop then
                -- if animation is looped restart from frame 1
                self.currentFrame = 1
				
				--look for callback
				if self.callback and self.callback["ANIM_NEWLOOP"] then
					local event = {}
					event.animationName = self.currentAnimation
					self.callback["ANIM_NEWLOOP"](event)
				else --default using event
					local newLoopEvent = Event.new("ANIM_NEWLOOP")
					newLoopEvent.animationName = self.currentAnimation
					self:dispatchEvent(newLoopEvent)
				end
			else
                -- if not looped stop on default "stop" frame (frame 1 if not defined by user)
                self:stopAnimation()
            end
        end
    end
end
