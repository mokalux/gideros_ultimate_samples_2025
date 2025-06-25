---@meta

---@class Sound : Object
Sound = {}

---@return Sound
function Sound.new(filename) end

---@param start_time? number # milliseconds
---@param looping? boolean # (default = false)
---@param paused? boolean # (default = false)
---@return SoundChannel
function Sound:play(start_time, looping, paused) end

