--[[
*************************************************************
*	---------------------------------------------
*	FlipPageView: create simple comic book with page curl effect
*	
*	Coded By hnim Copyright (C) 2012
*	contact: hnim0801@gmail.com
*	blog: http://hnimpage.wordpress.com/
*	---------------------------------------------
*	Feel free to distribute and modify code, but keep reference to its author
*	---------------------------------------------
*************************************************************	
--]]
FlipPageView = gideros.class(Sprite)
-- init
function FlipPageView:init()
    self.width = application:getContentWidth()
    self.height = application:getContentHeight()
    self.currentPage = 0
    self.page1 = self.currentPage + 1
    self.page2 = self.page1 + 1
    self.page1Tx = nil
    self.page2Tx = nil
    self.imgPath = {}
    self.xTouch = 20
    self.yTouch = 20
    self.dx = 3
    self.isFlipping = false
    self.flip = false
    self.isNext = false    
    --
    self.oldX = 0
    self.oldY = 0
    --
    self.oldxF = 0
    self.oldyF = 0
    --
    self.visiblePage = Shape.new()
    self:addChild(self.visiblePage)
    --
    self.flipPart = Sprite.new()
    self:addChild(self.flipPart)
    --
    self.invisiblePage = Shape.new()
    self:addChild(self.invisiblePage)    
end

--
function FlipPageView:registerEventListener()
    self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
    self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
    self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

--
function FlipPageView:unregisterEventListener()
    self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
    self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
    self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

--
function FlipPageView:createPageTexture()
    self.page1Tx = nil
    self.page2Tx = nil
    collectgarbage()
    self.page1Tx = Texture.new(self.imgPath[self.page1])
    if self.page2 <= #self.imgPath then
        self.page2Tx = Texture.new(self.imgPath[self.page2])
    end
end

--
function FlipPageView:pointGenerateAutoRoll(distance, width, height)
    local Ax = width - distance
    local Ay = height;
    local Dx = 0;
    local Dy = 0;
    if Ax > width * 0.5 then
        Dx = width
        Dy = height - (width - Ax) * height / Ax
    else
        Dx = 2 * Ax
        Dy = 0
    end
    local a = (height - Dy) / (Dx + distance - width)
    local alpha = math.atan(a)
    local mcos = math.cos(2 * alpha)
    local msin = math.sin(2 * alpha)
    -- E
    local Ex = Dx + mcos * (width - Dx)
    local Ey = -(msin * (width - Dx))
    -- F
    local Fx = width - distance + (mcos * distance)
    local Fy = height - (msin * distance)
    --
    if Ax > width * 0.5 then
        Ex = Dx
        Ey = Dy
    end
    --
    return Ax, Ay, width, height, width, 0, Dx, Dy, Ex, Ey, Fx, Fy
end


function FlipPageView:pointGenerateBaseOnFingurePosition(xTouch, yTouch, width, height)
    --
    local Ay = height
    local Dx = width
    --

    --
    local Fx = width - xTouch + 0.1
    local Fy = height - yTouch + 0.1
    --
    if self.xA == 0 then
        Fx = math.min(Fx, self.oldxF)
        Fy = math.max(Fy, self.oldyF)
    end

    if Fy > height then
        Fy = height
    end

    --
    local deltaX = width - Fx
    local deltaY = math.max(0.1, height - Fy)
    --
    local BH = math.sqrt(deltaX * deltaX + deltaY * deltaY) / 2
    local tangAlpha = deltaY / deltaX
    local alpha = math.atan(tangAlpha)
    local _cos = math.cos(alpha)
    local _sin = math.sin(alpha)
    --
    local Ax = width - (BH / _cos)
    local Dy = height - (BH / _sin)
    --

    Ax = math.max(0, Ax)
    if (Ax == 0) then
        self.oldxF = Fx
        self.oldyF = Fy
    end
    --
    local Ex = Dx
    local Ey = Dy
    --

    if (Dy < 0) then
        Dx = width + tangAlpha * Dy
        Ey = 0
        Ex = width + math.tan(2 * alpha) * Dy
    end
    --
    return Ax, Ay, width, height, width, 0, Dx, math.max(0, Dy), Ex, Ey, Fx, Fy
end

function FlipPageView:createMirrorPage()
    for i = 1, #self.flipPart do
        self.flipPart:removeChildAt(1)
    end
    bitmap = Bitmap.new(self.page1Tx)
    bitmap:setColorTransform(220 / 255, 220 / 255, 220 / 255, 1)
    bitmap:setScaleX(-1)
    bitmap:setAnchorPoint(1, 1)
    self.flipPart:addChild(bitmap)
end

--
function FlipPageView:swapPage(i)
    self.page1 = self.page1 + i
    self.page2 = self.page1 + 1
    self:createPageTexture()
    self:createMirrorPage()
end

function FlipPageView:roll()	
    if self.xTouch <= self.width and self.xTouch >= 0 then
        local xA, yA, xB, yB, xC, yC, xD, yD, xE, yE, xF, yF
        if self.isFlipping then
            if self.isNext then
                self.xTouch = self.xTouch + self.dx
            else
                self.xTouch = self.xTouch - self.dx
            end

            xA, yA, xB, yB, xC, yC, xD, yD, xE, yE, xF, yF = self:pointGenerateAutoRoll(self.xTouch, self.width, self.height)
        else
            xA, yA, xB, yB, xC, yC, xD, yD, xE, yE, xF, yF = self:pointGenerateBaseOnFingurePosition(self.xTouch, self.yTouch, self.width, self.height)
        end
		self.xF = xF
		self.xA = xA
        

        self.invisiblePage:clear()
        self.invisiblePage:setFillStyle(Shape.TEXTURE, self.page2Tx)
        self.invisiblePage:beginPath()
        self.invisiblePage:moveTo(xA, yA)
        self.invisiblePage:lineTo(xB, yB)
        self.invisiblePage:lineTo(xC, yC)
        self.invisiblePage:lineTo(xD, yD)
        self.invisiblePage:closePath()
        self.invisiblePage:endPath()
        --
        self.flipPart:setPosition(xF, yF)
        --
        local a = 2 * 180 * math.atan((self.width - xA - (xC - xD)) / (self.height - yD)) / math.pi
        self.flipPart:setRotation(a)
        --
        self.visiblePage:clear()
        self.visiblePage:setFillStyle(Shape.TEXTURE, self.page1Tx)
        self.visiblePage:beginPath()
		self.visiblePage:moveTo(0, 0)
        self.visiblePage:lineTo(0, self.height)
        self.visiblePage:lineTo(self.width, self.height)
        self.visiblePage:lineTo(self.width, 0)                
        self.visiblePage:closePath()
        self.visiblePage:endPath()
    elseif self.isFlipping then
        if self.flip then
            local i = 0
            if self.isNext then
                i = 1
            else
                i = -1
            end
            self.currentPage = self.currentPage + i
            if i > 0 then				
                self:swapPage(i)
            end
        elseif self.isNext then
            self:swapPage(1)
        end
        self:removeEventListener(Event.ENTER_FRAME, self.roll, self)
        self.isFlipping = false
        self.flip = false
        self.xTouch = 20
        self.yTouch = 20		
    end
end


function FlipPageView:onMouseDown(event)
    if not self.isFlipping then
        self.oldX = event.x
        self.oldY = event.y
        if self.oldX <= 40 and self.page1 > 1 then			
            self.xTouch = self.width
            self.yTouch = 20
            self.isNext = false
            self.flip = true
            self:swapPage(-1)
        elseif self.oldX >= self.width - 50 and self.oldY >= self.height - 50 and self.currentPage < #self.imgPath - 1 then			
            self.xTouch = 20
            self.yTouch = 20
            self.isNext = true
            self.flip = true
        end
    end
end

--
function FlipPageView:onMouseMove(event)
    if self.flip and not self.isFlipping then
        local dx = event.x - self.oldX
        local dy = event.y - self.oldY
        self.xTouch = self.xTouch - dx
        self.yTouch = self.yTouch - dy
        self:roll()
        self.oldX = event.x
        self.oldY = event.y
    end
end

function FlipPageView:onMouseUp(event)
    if (not self.isFlipping) and self.flip then
        self.isFlipping = true
        if self.xF < 40 and (not self.isNext) then
            self.isNext = true
            self.flip = false
        elseif self.xF > self.width - 50 and self.isNext then
            self.isNext = false
            self.flip = false
        end		
		--
        self.xTouch = self.width - self.xA
        if self.xA <= 0 then
            self.xTouch = self.width * 0.75
        end
        self:addEventListener(Event.ENTER_FRAME, self.roll, self)
    end
end
--
function FlipPageView:addPage(path)
    self.imgPath[#self.imgPath + 1] = path
end

function FlipPageView:addPages(paths)
    for i = 1, #paths do
        self:addPage(paths[i])
    end
end

function FlipPageView:show()
    self:createPageTexture()
    self:createMirrorPage()
    self:roll()
    self:registerEventListener()
end


