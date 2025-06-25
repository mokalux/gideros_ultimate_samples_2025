---@meta

---@class SceneManager : Sprite
SceneManager = {}

---@param scenes table
---@return SceneManager
function SceneManager.new(scenes) end

---
---change to specified scene
---
---@param scene string
---@param transition_time? number
function SceneManager:changeScene(scene, transition_time) end

---@param event Event
function SceneManager:filterTransitionEvents(event) end

function SceneManager:onTransitionBegin() end

function SceneManager:onTransitionEnd() end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromRight(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromLeft(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromBottom(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromTop(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromRightWithFade(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromLeftWithFade(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromBottomWithFade(scene1, scene2, t) end

---@param scene1 Sprite
---@param scene2 Sprite
---@param t number
function SceneManager.moveFromTopWithFade(scene1, scene2, t) end

