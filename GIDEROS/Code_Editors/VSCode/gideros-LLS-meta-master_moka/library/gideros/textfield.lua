---@meta

---@class TextField : Sprite
TextField = {}

---
---creates a new TextField object with the specified font and text
---
---@param font Font|TTFont|nil # the font used for displaying the TextField object. If nil, default font is used
---@param text? string
---@param sample? string # sample to determine line height
---@param layout? table
---@return TextField
function TextField.new(font, text, sample, layout) end

---
---retrieves the layout parameters of the Textfield
---
---@return table
function TextField:getLayout() end

---
---returns the letter-spacing property which is used to increase or decrease the space between characters in a text
---
---@return number
function TextField:getLetterSpacing() end

---
---gets the textfield line height
---
---@return number
function TextField:getLineHeight() end

---
---returns the coordinates from a given offset within the text
---
---@param offset integer # The byte offset into the text string.
---@return number x coore
---@return number y coord
function TextField:getPointFromTextPosition(offset) end

---
---gets the string used as sample for determining line height
---
---@return string
function TextField:getSample() end

---
---returns the textfield text
---
---@return string
function TextField:getText() end

---
---returns the textfield text color in hexadecimal format
---
---@return integer
function TextField:getTextColor() end

---
---returns the offset into a text from x, y coordinates
---
---@return integer
function TextField:getTextPositionFromPoint(x, y) end

---
---sets the textfield font to use
---
---@param font Font|TTFont
function TextField:setFont(font) end

---
---changes the textfield layout parameters
---
function TextField:setLayout() end

---
---sets the letter-spacing property which is used to increase or decrease the space between characters in a text
---
---@param spacing number
function TextField:setLetterSpacing(spacing) end

---
---sets the sample string used for determining the text line height
---
---@param sample string
function TextField:setSample(sample) end

---
---sets the textfield text to be displayed
---
---@param text string
function TextField:setText(text) end

---
---sets the textfield text color in hexadecimal format
---
---@param color integer
function TextField:setTextColor(color) end