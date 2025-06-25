Interface = Core.class(Sprite)

function Interface:init(scene)

self.scene = scene;

-- create a table to keep track of touches
self.scene.upButtonTouches = {}
self.scene.leftButtonTouches = {}
self.scene.rightButtonTouches = {}

-- Setup LR buttons

local leftButton = Buttons.new(scene,"lr-button.png", "lr-button-pressed.png")
leftButton.type = "leftButton"
self:addChild(leftButton)
leftButton:setPosition(10,235);
self.scene.leftButton = leftButton

local rightButton = Buttons.new(scene,"lr-button.png", "lr-button-pressed.png")
rightButton.type = "rightButton"
self:addChild(rightButton)
rightButton:setPosition(160,235);
rightButton:setScaleX(-1)
self.scene.rightButton = rightButton

local upButton = Buttons.new(scene,"up.png", "up pressed.png")
upButton.type = "upButton"
self:addChild(upButton)
upButton:setPosition(390,235);
self.scene.upButton = upButton

end

