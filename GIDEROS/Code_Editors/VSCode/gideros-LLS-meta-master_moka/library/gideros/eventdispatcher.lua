---@meta
---@diagnostic disable: codestyle-check


---@class EventDispatcher : Object
EventDispatcher = {}

---
---Creates a new EventDispatcher object.
---
---@return EventDispatcher
function EventDispatcher.new() end

---
---Registers a listener function and an optional data value so that the listener function is called when an event of a particular type occurs.
---
---@param type string # the type of event
---@param listener function # the listener function that processes the event
---@param data? any # an optional data parameter that is passed as a first argument to the listener function
function EventDispatcher:addEventListener(type, listener, data) end

---
---Dispatches an event to this EventDispatcher instance. 
---
---@param event Event # The Event object to be dispatched.
function EventDispatcher:dispatchEvent(event) end

---
---Checks if the EventDispatcher object has an event listener registered for the specified type of event. 
---
---@param type string # the type of event
---@return boolean # A value of true if a listener of the specified type is registered; false otherwise.
function EventDispatcher:hasEventListener(type) end

---
---Removes described event listener
---
---@param type string # the type of event
---@param listener function # the listener function that processes the event
---@param data? any # an optional data parameter that is passed as a first argument to the listener function
function EventDispatcher:removeEventListener(type, listener, data) end

---@class Event
-- EventDispatcher
---@field APPLICATION_BACKGROUND string # This event is dispatched when application gets sent to background. Sent to background also means application is suspended, thus Event.APPLICATION_SUSPEND is dispatched first. 
---@field APPLICATION_EXIT string # This event is dispatched when application is closed.
---@field APPLICATION_FOREGROUND string # This event is dispatched when application gets sent back to foreground.
---@field APPLICATION_RESIZE string # This event is dispatched when app window has changed its size on Desktops.
---@field APPLICATION_RESUME string # This event is dispatched when application is resumed (become active).
---@field APPLICATION_START string # This event is dispatched when application is started.
---@field APPLICATION_SUSPEND string # This event is dispatched when application is suspended (becomes inactive). It does not always mean that application was sent to background, for example, this event is dispatched, when low battery notification is displayed. 
---@field APPLICATION_MEMORY_WARNING string # This event is dispatched when device has low memory and you can try to free memory in your app, by releasing unnecessary resources.
---@field OPEN_URL string # This event is dispatched when the  is launched in response to an open url request. It has a parameter of the url that triggered the application launch.
-- Sprite
---@field ADDED_TO_STAGE string
---@field ENTER_FRAME string
---@field KEY_DOWN string
---@field KEY_UP string
---@field LAYOUT_RESIZED string
---@field MOUSE_DOWN string
---@field MOUSE_HOVER string
---@field MOUSE_MOVE string
---@field MOUSE_UP string
---@field MOUSE_WHEEL string
---@field REMOVED_FROM_STAGE string
---@field TOUCHES_BEGIN string
---@field TOUCHES_CANCEL string
---@field TOUCHES_END string
---@field TOUCHES_MOVE string
Event = {}
