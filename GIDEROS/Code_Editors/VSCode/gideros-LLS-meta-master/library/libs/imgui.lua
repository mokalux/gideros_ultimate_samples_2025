---@meta

---@class ImGui
ImGui = {}

---
---initializes ImGui
---
---@param opts table
---@return ImGui
function ImGui.new(opts) end

---
---displays an ImGui arrow button
---
---direction possible value:
---
--- - 0 = arrow left
--- - 1 = arrow right
--- - 2 = arrow up
--- - 3 = arrow down
---
---@param id string
---@param direction number
function ImGui:arrowButton(id, direction) end

---
---pushes window to the stack and starts appending to it
---
---if open is nil (window with no X button) then only the second boolean is returned. The boolean will then return whether the window is expanded or colapsed. 
---
---@param name string # window title
---@param open boolean|nil # the status of the window, true=opened, false=closed, nil=no close button on window
---@param flags string # any of the ImGui Window flags, see ImGui Constants - Window Flags
---|`WindowFlags_AlwaysAutoResize`
---|`WindowFlags_AlwaysHorizontalScrollbar`
---|`WindowFlags_AlwaysUseWindowPadding`
---|`WindowFlags_AlwaysVerticalScrollbar`
---|`WindowFlags_HorizontalScrollbar`
---|`WindowFlags_MenuBar`
---|`WindowFlags_NoBackground`
---|`WindowFlags_NoBringToFrontOnFocus`
---|`WindowFlags_NoCollapse`
---|`WindowFlags_NoDecoration`
---|`WindowFlags_NoFocusOnAppearing`
---|`WindowFlags_NoInputs`
---|`WindowFlags_NoMouseInputs`
---|`WindowFlags_NoMove`
---|`WindowFlags_NoNav`
---|`WindowFlags_NoNavFocus`
---|`WindowFlags_NoNavInputs`
---|`WindowFlags_None`
---|`WindowFlags_NoResize`
---|`WindowFlags_NoSavedSettings`
---|`WindowFlags_NoScrollbar`
---|`WindowFlags_NoScrollWithMouse`
---|`WindowFlags_NoTitleBar`
---|`WindowFlags_UnsavedDocument`
---@return boolean # if second argument (open) is nil, returns only the second boolean below, otherwise it returns the status of the window, true=opened, false=closed
---@return boolean # whether the window is collapsed or expanded
function ImGui:beginWindow(name, open, flags) end

---
---displays an ImGui bullet
---
---@param ... any
---@return any?
function ImGui:bullet(...) end

---
---displays an ImGui bulleted text
---
---@param ... any
---@return any?
function ImGui:bulletText(...) end

---
---displays an ImGui button
---
---@param ... any
---@return any?
function ImGui:button(...) end

---
---displays an ImGui checkbox
---
---@param ... any
---@return any?
function ImGui:checkbox(...) end

---
---displays an ImGui color button
---
---@param ... any
---@return any?
function ImGui:colorButton(...) end

---
---displays an ImGui RGB color edit widget
---
---@param ... any
---@return any?
function ImGui:colorEdit3(...) end

---
---displays an ImGui RGBA color edit widget
---
---@param ... any
---@return any?
function ImGui:colorEdit4(...) end

---
---displays an ImGui RGB color picker widget
---
---@param ... any
---@return any?
function ImGui:colorPicker3(...) end

---
---displays an ImGui RGBA color picker widget
---
---@param ... any
---@return any?
function ImGui:colorPicker4(...) end

---
---displays a ImGui combo box
---
---@param ... any
---@return any?
function ImGui:combo(...) end

---
---displays an ImGui drag float slider
---
---@param ... any
---@return any?
function ImGui:dragFloat(...) end

---
---displays 2 ImGui drag float sliders
---
---@param ... any
---@return any?
function ImGui:dragFloat2(...) end

---
---displays 3 ImGui drag float sliders
---
---@param ... any
---@return any?
function ImGui:dragFloat3(...) end

---
---displays 4 ImGui drag float sliders
---
---@param ... any
---@return any?
function ImGui:dragFloat4(...) end

---
---displays 2 ImGui drag float range sliders
---
---@param ... any
---@return any?
function ImGui:dragFloatRange2(...) end

---
---displays an ImGui drag int slider
---
---@param ... any
---@return any?
function ImGui:dragInt(...) end

---
---displays 2 ImGui drag int sliders
---
---@param ... any
---@return any?
function ImGui:dragInt2(...) end

---
---displays 3 ImGui drag int sliders
---
---@param ... any
---@return any?
function ImGui:dragInt3(...) end

---
---displays 4 ImGui drag int sliders
---
---@param ... any
---@return any?
function ImGui:dragInt4(...) end

---
---displays 2 ImGui drag int range sliders
---
---@param ... any
---@return any?
function ImGui:dragIntRange2(...) end

---
---displays an ImGui drag scalar slider
---
---@param ... any
---@return any?
function ImGui:dragScalar(...) end

---
---ends the ImGui frame
---
---It is automatically called by render(). If you don't need to render data (skipping rendering) you may call endFrame() without render()... but you'll have wasted CPU already! If you don't need to render, better to not create any windows and not call newFrame() at all! 
function ImGui:endFrame(...) end

---
---pops window from the stack
---
---@param ... any
---@return any?
function ImGui:endWindow(...) end

---
---displays an ImGui regular filled angle slider
---
---@param ... any
---@return any?
function ImGui:filledSliderAngle(...) end

---
---displays an ImGui regular filled float slider
---
---@param ... any
---@return any?
function ImGui:filledSliderFloat(...) end

---
---displays two ImGui regular filled float sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderFloat2(...) end

---
---displays three ImGui regular filled float sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderFloat3(...) end

---
---displays four ImGui regular filled float sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderFloat4(...) end

---
---displays an ImGui regular filled int slider
---
---@param ... any
---@return any?
function ImGui:filledSliderInt(...) end

---
---displays two ImGui regular filled int sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderInt2(...) end

---
---displays three ImGui regular filled int sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderInt3(...) end

---
---displays four ImGui regular filled int sliders
---
---@param ... any
---@return any?
function ImGui:filledSliderInt4(...) end

---
---accesses the IO structure (mouse/keyboard/gamepad inputs...)
---
---@param ... any
---@return any?
function ImGui:getIO(...) end

---
---accesses the Style structure (colors, sizes)
---
---@param ... any
---@return any?
function ImGui:getStyle(...) end

---
---an ImGui image
---
---@param ... any
---@return any?
function ImGui:image(...) end

---
---displays an ImGui image button
---
---@param ... any
---@return any?
function ImGui:imageButton(...) end

---
---displays an ImGui image button with some text
---
---@param ... any
---@return any?
function ImGui:imageButtonWithText(...) end

---
---an ImGui filled image
---
---@param ... any
---@return any?
function ImGui:imageFilled(...) end

---
---an ImGui input double field
---
---@param ... any
---@return any?
function ImGui:inputDouble(...) end

---
---an ImGui input float field
---
---@param ... any
---@return any?
function ImGui:inputFloat(...) end

---
---two ImGui input float fields
---
---@param ... any
---@return any?
function ImGui:inputFloat2(...) end

---
---three ImGui input float fields
---
---@param ... any
---@return any?
function ImGui:inputFloat3(...) end

---
---four ImGui input float fields
---
---@param ... any
---@return any?
function ImGui:inputFloat4(...) end

---
---an ImGui input int field
---
---@param ... any
---@return any?
function ImGui:inputInt(...) end

---
---two ImGui input int fields
---
---@param ... any
---@return any?
function ImGui:inputInt2(...) end

---
---three ImGui input int fields
---
---@param ... any
---@return any?
function ImGui:inputInt3(...) end

---
---four ImGui input int fields
---
---@param ... any
---@return any?
function ImGui:inputInt4(...) end

---
---an ImGui input scalar field
---
---@param ... any
---@return any?
function ImGui:inputScalar(...) end

---
---an ImGui input text field
---
---@param ... any
---@return any?
function ImGui:inputText(...) end

---
---an ImGui multiline input text
---
---@param ... any
---@return any?
function ImGui:inputTextMultiline(...) end

---
---an ImGui input text field with hint
---
---@param ... any
---@return any?
function ImGui:inputTextWithHint(...) end

---
---an ImGui invisible button
---
---@param ... any
---@return any?
function ImGui:invisibleButton(...) end

---
---displays an ImGui labelled text
---
---@param ... any
---@return any?
function ImGui:labelText(...) end

---
---starts a new ImGui frame
---
---@param dt number # delta time in seconds
function ImGui:newFrame(dt) end

---
---an ImGui progress bar
---
---@param ... any
---@return any?
function ImGui:progressBar(...) end

---
---ImGui radio button
---
---@param ... any
---@return any?
function ImGui:radioButton(...) end

---
---ends the ImGui frame, finalizes the draw data
---
---@param ... any
---@return any?
function ImGui:render(...) end

---
---an ImGui scaled image
---
---@param ... any
---@return any?
function ImGui:scaledImage(...) end

---
---an ImGui scaled image and filled
---
---@param ... any
---@return any?
function ImGui:scaledImageFilled(...) end

---
---an ImGui scaled image button
---
---@param ... any
---@return any?
function ImGui:scaledImageButton(...) end

---
---an ImGui scaled image button and some text
---
---@param ... any
---@return any?
function ImGui:scaledImageButtonWithText(...) end

---
---sets a classic color style
---
---@param ... any
---@return any?
function ImGui:setClassicStyle(...) end

---
---sets the color edit options flag
---
---@param ... any
---@return any?
function ImGui:setColorEditOptions(...) end

---
---sets a dark color style
---
---@param ... any
---@return any?
function ImGui:setDarkStyle(...) end

---
---sets a light color style
---
---@param ... any
---@return any?
function ImGui:setLightStyle(...) end

---
---adds an ImGui About window
---
---@param ... any
---@return any?
function ImGui:showAboutWindow(...) end

---
---adds an ImGui demo window
---
---@param ... any
---@return any?
function ImGui:showDemoWindow(...) end

---
---adds a font selector block (not a window)
---
---@param ... any
---@return any?
function ImGui:showFontSelector(...) end

---
---adds an ImGui metrics window
---
---@param ... any
---@return any?
function ImGui:showMetricsWindow(...) end

---
---adds the style editor block (not a window)
---
---@param ... any
---@return any?
function ImGui:showStyleEditor(...) end

---
---adds a style selector block (not a window)
---
---@param ... any
---@return any?
function ImGui:showStyleSelector(...) end

---
---adds basic help/info block (not a window)
---
---@param ... any
---@return any?
function ImGui:showUserGuide(...) end

---
---displays an ImGui regular angle slider
---
---@param ... any
---@return any?
function ImGui:sliderAngle(...) end

---
---displays an ImGui regular float slider
---
---@param ... any
---@return any?
function ImGui:sliderFloat(...) end

---
---displays 2 ImGui regular float sliders
---
---@param ... any
---@return any?
function ImGui:sliderFloat2(...) end

---
---displays 3 ImGui regular float sliders
---
---@param ... any
---@return any?
function ImGui:sliderFloat3(...) end

---
---displays 4 ImGui regular float sliders
---
---@param ... any
---@return any?
function ImGui:sliderFloat4(...) end

---
---displays an ImGui regular int slider
---
---@param ... any
---@return any?
function ImGui:sliderInt(...) end

---
---displays 2 ImGui regular int sliders
---
---@param ... any
---@return any?
function ImGui:sliderInt2(...) end

---
---displays 3 ImGui regular int sliders
---
---@param ... any
---@return any?
function ImGui:sliderInt3(...) end

---
---displays 4 ImGui regular int sliders
---
---@param ... any
---@return any?
function ImGui:sliderInt4(...) end

---
---displays an ImGui small button
---
---@param ... any
---@return any?
function ImGui:smallButton(...) end

---
---displays a text field
---
---@param text string
function ImGui:text(text) end

---
---displays colored text
---
---@param text string
---@param color integer
---@param alpha number
function ImGui:textColored(text, color, alpha) end

---
---sets a text field to be disabled. text is indeed the contents of the text.
---
---@param text string
function ImGui:textDisabled(text) end

---
---displays wrapped text
---
---@param text string
function ImGui:textWrapped(text) end

---
---displays an ImGui regular vertical filled float slider
---
---@param ... any
---@return any?
function ImGui:vFilledSliderFloat(...) end

---
---displays an ImGui regular vertical filled int slider
---
---@param ... any
---@return any?
function ImGui:vFilledSliderInt(...) end

---
---displays an ImGui regular vertical float slider
---
---@param ... any
---@return any?
function ImGui:vSliderFloat(...) end

---
---displays an ImGui regular vertical int slider
---
---@param ... any
---@return any?
function ImGui:vSliderInt(...) end


--Constants
---@class ImGui
---@field WindowFlags_AlwaysAutoResize string
---@field WindowFlags_AlwaysHorizontalScrollbar string
---@field WindowFlags_AlwaysUseWindowPadding string
---@field WindowFlags_AlwaysVerticalScrollbar string
---@field WindowFlags_HorizontalScrollbar string
---@field WindowFlags_MenuBar string
---@field WindowFlags_NoBackground string
---@field WindowFlags_NoBringToFrontOnFocus string
---@field WindowFlags_NoCollapse string
---@field WindowFlags_NoDecoration string
---@field WindowFlags_NoFocusOnAppearing string
---@field WindowFlags_NoInputs string
---@field WindowFlags_NoMouseInputs string
---@field WindowFlags_NoMove string
---@field WindowFlags_NoNav string
---@field WindowFlags_NoNavFocus string
---@field WindowFlags_NoNavInputs string
---@field WindowFlags_None string
---@field WindowFlags_NoResize string
---@field WindowFlags_NoSavedSettings string
---@field WindowFlags_NoScrollbar string
---@field WindowFlags_NoScrollWithMouse string
---@field WindowFlags_NoTitleBar string
---@field WindowFlags_UnsavedDocument string
--Events
---@field KeyChar string
---@field KeyDown string
---@field KeyUp string
---@field MouseDown string
---@field MouseHover string
---@field MouseMove string
---@field MouseUp string
---@field MouseWheel string
---@field TouchBegin string
---@field TouchEnd string
---@field TouchCancel string
---@field TouchMove string
