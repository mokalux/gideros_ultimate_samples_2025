application:setBackgroundColor(0x000033)
-- Key
local _key = "A"
local _keyCode = 65

-- Texture
local _up_tex = Texture.new("img/button_up_small.png")
local _down_tex = Texture.new("img/button_down_small.png")

-- Button
local _btn = Bitmap.new(_up_tex)
_btn:setAnchorPoint(0.5, 0.5)
_btn:setPosition(150, 100)

-- Label button
local _font = TTFont.new("fonts/Galada.ttf", 64)
local _lbl = TextField.new(_font, _key)
_lbl:setTextColor(0xFFFFFF)
_lbl:setAnchorPoint(0.5, -0.5)
local _x, _y = _lbl:getPosition()
_lbl:setPosition(_x, _y)
_btn:addChild(_lbl)

-- key codes are integer. we map to strings so that we can display key name easily
local keyNames = {
  [KeyCode.BACK] = "back",
  [KeyCode.SEARCH] = "search",
  [KeyCode.MENU] = "menu",
  [KeyCode.CENTER] = "center",
  [KeyCode.SELECT] = "select",
  [KeyCode.START] = "start",
  [KeyCode.L1] = "L1",
  [KeyCode.R1] = "R1",
  [KeyCode.LEFT] = "left",
  [KeyCode.UP] = "up",
  [KeyCode.RIGHT] = "right",
  [KeyCode.DOWN] = "down",
  [KeyCode.SPACE] = "space",
  [KeyCode.BACKSPACE] = "backspace",
  [KeyCode.SHIFT] = "shift",
  [KeyCode.CTRL] = "control",
  [KeyCode.ALT] = "alt",
  [KeyCode.F4] = "f4",
--  [KeyCode.&] = "&",
}

-- Function
_btn.onKeyDown = function(event) 
	if (keyNames[event.keyCode] or "unknown") ~= "unknown" then
		print("KeyCode 1: ".. tostring(event.keyCode))
		print("Key 1:"..keyNames[event.keyCode])
		--
		_key = keyNames[event.keyCode]
		_keyCode = event.keyCode
	else
		print("KeyCode 2: ".. tostring(event.keyCode))
		print("Key 2:"..utf8.char(event.keyCode))
		--
		_key = utf8.char(event.keyCode)
		_keyCode = event.keyCode
	end
	setChange(false)
end

local function onKeyChar(ev)
	local extra=""
	if ev.text:len() then
		extra=" (Byte:"..ev.text:byte(1)..")"
	end
--	textc:setText("key chars: "..event.text..extra)
	print("onKeyChar", ev.text, ev.keyCode)
--	_lbl:setText(ev.text)
	_lbl:setText("key chars: "..ev.text..extra)
end

function setChange(change)
	if change then
		_btn:setTexture(_down_tex)
		_btn:addEventListener(Event.KEY_DOWN, _btn.onKeyDown)		
--		_btn:addEventListener(Event.KEY_CHAR, onKeyChar)
	else
		_btn:setTexture(_up_tex)
		change = false
		_btn:removeEventListener(Event.KEY_DOWN, _btn.onKeyDown)
--		_btn:removeEventListener(Event.KEY_CHAR, onKeyChar)
		-- Update position label
		_lbl:setText(_key)
		local _, _y = _lbl:getPosition()
		_lbl:setPosition(- string.len(_key) / 2 * 8, _y)
	end
end

-- Listener
_btn:addEventListener(Event.MOUSE_DOWN, function(e)
	if _btn:hitTestPoint(e.x, e.y) then
		e:stopPropagation()
		setChange(true)
	end
end)
 
stage:addChild(_btn)
