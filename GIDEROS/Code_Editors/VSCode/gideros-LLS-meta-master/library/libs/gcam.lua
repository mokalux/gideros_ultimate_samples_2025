---@meta

---@class GCam : Sprite
---@field SHAKE_DELAY number
GCam = {}

---@param sprite Sprite
---@return GCam
---@nodiscard
function GCam.new(sprite) end

---
---set camera to keep to size of window
---
---@param set boolean
function GCam:setAutoSize(set) end

---
---resize to size of wimdow
---
function GCam:appResize() end

---
---sets limits/bounds for camera view
---
---@param min_x number
---@param min_y number
---@param max_x number
---@param max_y number
function GCam:setBounds(min_x, min_y, max_x, max_y) end

---
---Sets a sprite for the camera to follow
---
---@param sprite Sprite
function GCam:setFollow(sprite) end

---
---sets horizontal offset
---
---@param offset number
function GCam:setFollowOffsetX(offset) end

---
---sets vertical offset
---
---@param offset number
function GCam:setFollowOffsetY(offset) end

---
---update function, usually called per frame
---
---@param delta_time number # in seconds
function GCam:update(delta_time) end