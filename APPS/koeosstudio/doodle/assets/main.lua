-- https://forum.gideros.rocks/discussion/8709/i-made-a-simple-canvas-class-with-undo-and-redo-function-that-can-be-used-for-simple-doodling#latest
-- @koeosstudio

local w, h = 1080, 2160
application:setLogicalDimensions(w, h)
--application:setScaleMode(Application.LETTERBOX)
application:setBackgroundColor(0x413a3a)


local canvas = Canvas.new(w, h-150)
canvas:setPenSize(16)
canvas:setColor(0x9d9d9d)
canvas:setPenColor(0x5a6aff)
canvas.paper:setPosition(0, 150, 1)
stage:addChild(canvas)

local undoBtn = Button.new({Pixel.new(0xffff7f, 1, 100, 100), Pixel.new(0x00ff7f, 1, 100, 100)})
undoBtn:setPosition(75, 75, 0)
stage:addChild(undoBtn)
undoBtn:addEventListener('start', function() canvas:undo() end)

local redoBtn = Button.new({Pixel.new(0xffff7f, 1, 100, 100), Pixel.new(0x00ff7f, 1, 100, 100)})
redoBtn:setPosition(200, 75, 0)
stage:addChild(redoBtn)
redoBtn:addEventListener('start', function() canvas:redo() end)

local clearBtn = Button.new({Pixel.new(0xffff7f, 1, 100, 100), Pixel.new(0x00ff7f, 1, 100, 100)})
clearBtn:setPosition(325, 75, 0)
stage:addChild(clearBtn)
clearBtn:addEventListener('start', function() canvas:clear() end)
