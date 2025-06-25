---@meta

---@class Sound : Object
Sound = {}

---@return Sound
function Sound.new(filename) end

---
---Sets the position of the listener in a 3D environment.
---
---Note: please notice the dot instead of the column Sound.setListenerPosition(...)
---
---@param x number # x coordinate of the listener
---@param y number # y coordinate of the listener
---@param z number # z coordinate of the listener
---@param vx number # x component of the listener's velocity (optional)
---@param vy number # y component of the listener's velocity (optional)
---@param vz number # z component of the listener's velocity (optional)
---@param dx number # x component of the direction the listener is facing (optional)
---@param dy number # y component of the direction the listener is facing (optional)
---@param dz number # z component of the direction the listener is facing (optional)
---@param ux number # x component of up direction relative to the listener (optional)
---@param uy number # y component of up direction relative to the listener (optional)
---@param uz number # z component of up direction relative to the listener (optional)
function Sound.setListenerPosition(x, y, z, vx, vy, vz, dx, dy, dz, ux, uy, uz) end

---
---Returns the duration of the sound in milliseconds.
---
---@return number snd_length_ms
function Sound:getLength() end

---
---Creates a new SoundChannel Object to play the sound.
---
---@param start_time? number # milliseconds
---@param looping? boolean # (default = false)
---@param paused? boolean # (default = false)
---@return SoundChannel
function Sound:play(start_time, looping, paused) end
