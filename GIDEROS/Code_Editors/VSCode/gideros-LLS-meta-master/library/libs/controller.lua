---@meta

-- Events and KeyCodes at end of file

---@class Controller : Sprite
Controller = {}
controller = Controller

---
--- gets the name of controller
---
---@param id number
---@return string
function Controller:getControllerName(id) end

---
---returns amount of connected controllers
---
---@return number
function Controller:getPlayerCount() end

---
---returns table with controller IDs
---
---@return table
function Controller:getPlayers() end

---
---return true if any controller is connected
---
---@return boolean
function Controller:isAnyAvailable() end

---
---vibrate the controller for provided amount of miliseconds
---
---@param ms number # time to vibrate for
function Controller:vibrate(ms) end

---
---registers a listener function
---
---@param type string
---|`Event.CONNECTED`
---|`Event.DISCONNECTED`
---|`Event.KEY_DOWN`
---|`Event.KEY_UP`
---|`Event.LEFT_JOYSTICK`
---|`Event.LEFT_TRIGGER`
---|`Event.RIGHT_JOYSTICK`
---|`Event.RIGHT_TRIGGER`
---@param listener function
---@param data any
function Controller:addEventListener(type, listener, data) end

---
---removes a listener function
---
---removeEventListener() function expects the same arguments than the addEventListener() to remove the event.
---
---If there is no matching listener registered, a call to this function has no effect. 
---
---@param type string
---|`Event.CONNECTED`
---|`Event.DISCONNECTED`
---|`Event.KEY_DOWN`
---|`Event.KEY_UP`
---|`Event.LEFT_JOYSTICK`
---|`Event.LEFT_TRIGGER`
---|`Event.RIGHT_JOYSTICK`
---|`Event.RIGHT_TRIGGER`
---@param listener function
---@param data any
function Controller:removeEventListener(type, listener, data) end

---
---Checks if the EventDispatcher object has an event listener registered for the specified type of event. 
---
---@param type string
---|`Event.CONNECTED`
---|`Event.DISCONNECTED`
---|`Event.KEY_DOWN`
---|`Event.KEY_UP`
---|`Event.LEFT_JOYSTICK`
---|`Event.LEFT_TRIGGER`
---|`Event.RIGHT_JOYSTICK`
---|`Event.RIGHT_TRIGGER`
---@return boolean
function Controller:hasEventListener(type) end

---@class Event
---@field CONNECTED string
---@field DISCONNECTED string
---@field KEY_DOWN string
---@field KEY_UP string
---@field LEFT_JOYSTICK string
---@field LEFT_TRIGGER string
---@field RIGHT_JOYSTICK string
---@field RIGHT_TRIGGER string

---@class KeyCode
---@field BUTTON_A integer
---@field BUTTON_B integer
---@field BUTTON_X integer
---@field BUTTON_Y integer
---@field DPAD_DOWN integer
---@field DPAD_UP integer
---@field DPAD_LEFT integer
---@field DPAD_RIGHT integer
---@field BUTTON_MENU integer
---@field BUTTON_BACK integer
---@field BUTTON_L1 integer
---@field BUTTON_R1 integer
---@field BUTTON_L2 integer
---@field BUTTON_R2 integer
---@field BUTTON_L3 integer
---@field BUTTON_R3 integer
