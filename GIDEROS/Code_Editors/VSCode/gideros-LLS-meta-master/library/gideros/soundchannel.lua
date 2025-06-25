---@neta

---@class SoundChannel : Object
SoundChannel = {}

---
---returns the current pitch of the sound channel
---
---@return number # 1 is original pitch
function SoundChannel:getPitch() end

---
---returns the playback position in milliseconds
---
---@return number
function SoundChannel:getPosition() end

---
---returns the current volume of the sound channel
---
---@return number
function SoundChannel:getVolume() end

---
---returns the looping state of the channel
---
---@return boolean
function SoundChannel:isLooping() end

---
---returns the paused state of the channel
---
---@return boolean
function SoundChannel:isPaused() end

---
---returns the playing state for the sound channel
---
---@return boolean
function SoundChannel:isPlaying() end

---
---sets the looping state of the channel
---
---@param loop boolean
function SoundChannel:setLooping(loop) end

---
---sets the paused state of the channel
---
---@param pause boolean
function SoundChannel:setPaused(pause) end

---
---sets the pitch of the sound channel
---
---@param pitch number # relative pitch shift
function SoundChannel:setPitch(pitch) end

---
---sets the position of the current playback
---
---@param milliseconds number
function SoundChannel:setPosition(milliseconds) end

---
---sets the volume of the sound channel
---
---@param volume number
function SoundChannel:setVolume(volume) end

---
---Sets the position of this sound in a 3D world.
---
---@param x number # x coord
---@param y number # y coord
---@param z? number # z coord
---@param vx? number # x velocity
---@param vy? number # y velocity
---@param vz? number # z velocity
function SoundChannel:setWorldPosition(x, y, z, vx, vy, vz) end

---
---stops the sound playing in the channel
---
function SoundChannel:stop() end