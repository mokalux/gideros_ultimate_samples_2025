ButtonSimple = ButtonSimple or Core.class(Sprite)

function ButtonSimple:init(sprite)

    self.sprite = sprite

    self:addChild(self.sprite)
    
    --- EVENTS -----
    self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
    --self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
    
end

function ButtonSimple:onMouseDown(event)
    
    if self:hitTestPoint(event.x, event.y) then
        -- click on button
        event:stopPropagation()
        local clickEvent = Event.new("click")
        self:dispatchEvent(clickEvent)
    end
end

function ButtonSimple:onMouseUp(event)
    event:stopPropagation() 
end