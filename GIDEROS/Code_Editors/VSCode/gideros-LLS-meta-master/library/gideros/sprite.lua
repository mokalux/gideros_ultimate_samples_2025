---@meta
---@diagnostic disable: codestyle-check

---
---The Sprite class is the base class for all objects that can be placed on the scene tree. It is the 
---basic scene tree building block.
---
---A sprite can contain child sprites which makes the scene tree hierarchy. Transformations such as 
---translation, rotation, scaling, and color transforms, propagate its effect to all of its children.
---
---The drawing order is defined by the order of children. The first child is drawn first and the last 
---child is drawn last. It is possible to change the drawing order by modifying the order of child list.
---
---A Sprite instance can exist without attaching the scene tree.
---
---An unattached sprite can receive Event.ENTER_FRAME event but it will only receive mouse and touch 
---events when it is attached to the scene tree. 
---
---@class Sprite : EventDispatcher
Sprite = {}
stage = Sprite

---
---creates a new Sprite object
---
---@return Sprite # a new Sprite object
function Sprite.new() end

---
---Adds a sprite as a child to this sprite. The child is added as a last child of this Sprite instance.
---
---Sprites can have only one parent. Therefore if you add a child object that already has a different sprite as a
---parent, the sprite is removed from the child list of the other sprite and then added to this sprite. 
---
---@param child Sprite # the child sprite to add.
function Sprite:addChild(child) end

---
---Adds a sprite as a child to this sprite. The child is added at the index position specified. Indices start from 1.
---
---Sprites can have only one parent. Therefore if you add a child object that already has a different sprite as a 
---parent, the sprite is removed from the child list of the other sprite and then added to this sprite. 
---
---@param child Sprite # the child sprite to add
---@param idx number # the index position to which the child is added
function Sprite:addChildAt(child, idx) end

---
---Clears the blending mode
---
function Sprite:clearBlendMode() end

---
---Returns a new copy of a sprite. All settings are retained in the copy, and all children are recursively cloned. All
---lua fields of the original sprite are also copied to the new sprite. The new sprite is, however, not inserted in
---the original sprite's parent, and listeners are not kept. During sprite cloning, the lua method 'newClone' is called
---on the Sprite, if it exists.
---
---@return Sprite
function Sprite:clone() end

---
---Determines whether the specified sprite is contained in the subtree of this Sprite instance. 
---
---@param child Sprite # the object to test
---@return boolean iscontained # true if the child object is contained in the subtree of this Sprite instance, otherwise false
function Sprite:contains(child) end

---
---Returns the specified property of this sprite instance by its name.
---
---@param parameter string # the name of the parameter
---@return number value # the value of the parameter
function Sprite:get(parameter) end

---
---Returns the alpha transparency of this sprite. 0 means fully transparent and 1 means fully opaque.
---
---@return number alpha # The alpha of the sprite (value between 0-1)
function Sprite:getAlpha() end

---
---Returns the x and y coordinates of the anchor point.
---
---@return number x_coord, number y_coord
function Sprite:getAnchorPoint() end

---
---Sets the anchor point of a Sprite object.
---
---Each Sprite object has an anchor point that affects the positioning of the sprite displayed. By modifying the anchor point, you change the origin of the sprite. For example, setting the anchor point to (0.5, 0.5) moves the center of the sprite to the origin. If you set the anchor point to (1, 1) instead, the bottom-right corner of the sprite will be the origin. The default value of anchor point is (0, 0) which means top-left of the sprite is the origin by default.
---
---@param x number # x coordinate of anchor point, usually between [0, 1]
---@param y number # y coordinate of anchor point, usually between [0, 1]
function Sprite:setAnchorPoint(x, y) end

---
---Returns x,y,z anchor position of the Sprite in its relative coordinates.
---
---@return number xpos, number ypos, number zpos
function Sprite:getAnchorPosition() end

---
---Returns a rectangle (as x, y, width and height) that encloses the sprite as it appears in another sprite coordinate
---system.
---
---@param targetsprite Sprite # the sprite that defines the other coordinate system to transform
---@return number xcoord, number ycoord, number width, number height
function Sprite:getBounds(targetsprite) end

---
---Returns the child Sprite instance that exists at the specified index. First child is at index 1.
---
---@param index number # The index position of the child object.
---@return number index # The child sprite at the specified index position.
function Sprite:getChildAt(index) end

---
---Returns the index of the specified child sprite.
---
---@param child Sprite # The child to identify.
---@return number child # The index of the specified sprite.
function Sprite:getChildIndex(child) end

---
---Returns the children Sprites that correspond to the given screen coordinates.
---
---@param x number # x coordinate in global space
---@param y number # y coordinate in global space
---@param visible boolean # only report visible sprites
---@param nosubs boolean # don't report children of this sprite's children
---@return table # a list of sprites that were found at this screen location
function Sprite:getChildrenAtPoint(x, y, visible, nosubs) end

---
---Returns the coordinates of the Sprite clip range if set with setClip. 
---
---@return number x_coordinate, number y_coordinate, number width, number height # values of clip region
function Sprite:getClip() end

---
---Returns the red, green, blue and alpha channel multipliers.
---
---@return number red_multiplier, number green_multiplier, number blue_multiplier, number alpha_multiplier
function Sprite:getColorTransform() end

---
---Returns the width and the height of the Sprite in pixels. The dimensions are calculated based on the bounds of the
---content of the Sprite. 
---
---@return number width, number height # sprite dimensions
function Sprite:getDimensions() end

---
---Returns the number of Sprites actually drawn each frame on this subtree.
---
---@return number number_sprites_drawn
function Sprite:getDrawCount() end

---
---Returns the height of the sprite in pixels. The height is calculated based on the bounds of the content of the sprite.
---
---If withoutTransform is set to true, the original height is returned without accounting for transformations.
---@param without_transform number # return value without transform?
---@return number height # height of the sprite
function Sprite:getHeight(without_transform) end

---
---See Sprite:setLayoutConstraints for a description of the fields.
---
---@return table constraints # table of layout constraints
function Sprite:getLayoutConstraints() end

---@class SpriteLayoutInfo
---@field startx number
---@field starty number
---@field width number
---@field height number
---@field weightx number
---@field weighty number
---@field minWidth number
---@field minHeight number

-- ... continue ...
---@class Sprite

---
---Returns computed placement value according to Gideros layout system. The returned table can contain the following fields: 
---
---<ul><li><b>startx</b>: The 0-based index of the column the child was placed into<br /></li>
---<li><b>starty</b>: The 0-based index of the row the child was placed into<br /></li>
---<li><b>width</b>: The width of the child<br /></li>
---<li><b>height</b>: The height of the child<br /></li>
---<li><b>weightx</b>: The horizontal weight of the child<br /></li>
---<li><b>weighty</b>: The vertical weight of the child<br /></li>
---<li><b>minWidth</b> (table): Minimum width<br /></li>
---<li><b>minHeight</b> (table): Minimum height<br /></li></ul>
---@return SpriteLayoutInfo # layout information
function Sprite:getLayoutInfo() end


---@class SpriteLayoutParameters
---@field columnWidths number[] # an array of minimum width for each column
---@field rowHeights number[] # an array of minimum height for each row
---@field columnWeights number[] # an array of relative weights for each column
---@field rowWeights number[] # an array of relative weights for each row
---@field insetTop number # the top margin
---@field insetLeft number # the left margin
---@field insetBottom number # the bottom margin
---@field insertRight number # the right margin
---@field insets number[] # sets the above four margins to the same value at once

-- ... continue ...
---@class Sprite

---
---Returns table of layout parameters (SpriteLayoutParameters object)
---
---<ul><li><b>columnWidths</b>: an array of minimum width for each column</li>
---<li><b>rowHeights</b>: an array of minimum height for each row</li>
---<li><b>columnWeights</b>: an array of relative weights for each column</li>
---<li><b>rowWeights</b>: an array of relative weights for each row</li>
---<li><b>insetTop</b>: the top margin</li>
---<li><b>insetLeft</b>: the left margin</li>
---<li><b>insetBottom</b>: the bottom margin</li>
---<li><b>insetRight</b>: the right margin</li>
---<li><b>insets</b>: sets the above four margins to the same value at once. <b>since 2020.7</b></li>
---<li><b>equalizeCells</b>: distribute extra spaces so that cells have a size proportional to their weights. <b>since 2020.7</b></li>
---<li><b>resizeContainer</b>: allow the parent sprite to be resized if children content is too large. <b>since 2020.5</b></li>
---<li><b>cellSpacingX</b>: horizontal margin between cells. <b>since 2020.7</b></li>
---<li><b>cellSpacingY</b>: vertical margin between cells. <b>since 2020.7</b></li></ul>
---@return SpriteLayoutParameters
function Sprite:getLayoutParameters() end

---@return Matrix
function Sprite:getMatrix() end

---
---@return number
function Sprite:getNumChildren() end

---@return Sprite
function Sprite:getParent() end

---
---Returns the x, y and z coordinates of the sprite.
---
---@return number x, number y, number? z
function Sprite:getPosition() end

---
---Returns the rotation of the sprite in degrees.
---
---@return number rotation # rotation of sprite in degrees
function Sprite:getRotation() end

---@return number rotation_x # rotation around x-axis
function Sprite:getRotationX() end

---@return number rotation_y # rotation around y-axis
function Sprite:getRotationY() end

---
---Returns the horizontal, vertical and z axis scales of the sprite.
---
---@returun number x_scale, number y_scale, number z_scale
function Sprite:getScale() end

---
---Returns the horizontal scale of the sprite
---
---@return number x_scale
function Sprite:getScaleX() end

---
---Returns the vertical scale of the sprite
---
---@return number y_scale
function Sprite:getScaleY() end

---
---Returns the scale on the z-axis of the sprite
---
---@return number z_scale
function Sprite:getScaleZ() end

---
---Returns the x and y skew parameters of the Sprite. 
---
---@return number x_skew, number y_skew
function Sprite:getSkew() end

---
---Returns the x skew parameter of the Sprite. 
---
---@return number x_skew
function Sprite:getSkewX() end

---
---Returns the y skew parameter of the Sprite. 
---
---@return number y_skew
function Sprite:getSkewY() end

---
---Returns the height of the sprite in pixels. The height is calculated based on the bounds of the content of the sprite.
---
---@param without_transform? boolean # if true, returns the height of the Sprite without transformations else returns the transformed height
---@return number height
function Sprite:getHeight(without_transform) end

---
---Returns the width of the sprite in pixels. The width is calculated based on the bounds of the content of the sprite. 
---
---@param without_transform? boolean # if true, returns the width of the Sprite without transformations else returns the transformed width
---@return number width
function Sprite:getWidth(without_transform) end

---@return number x_coord
function Sprite:getX() end

---@return number y_coord
function Sprite:getY() end

---@return number z_coord
function Sprite:getZ() end

---
---Converts the x,y coordinates from the global to the sprite's (local) coordinates.
---
---@param x number
---@param y number
---@return number x, number y # coordinates relative to the display object.
function Sprite:globalToLocal(x, y) end

---@param child Sprite
---@return boolean has_child
function Sprite:hasChild(child) end

---
---Checks whether the given coordinates (in global coordinate system) is in bounds of the sprite. 
---@param x number
---@param y number
---@param shape_flag boolean # is hidden, clipping/masking, taken into consideration when testing hit point?
---@return boolean is_hit # true if the given global coordinates are in bounds of the sprite, false otherwise
function Sprite:hitTestPoint(x, y, shape_flag) end

---
---Returns whether or not the sprite is visible. Child sprites that are not visible are also taken into consideration while calculating bounds. 
---
---@param check_parent? boolean # flag to check parent visibility (default = false)
---@return boolean is_visible
function Sprite:isVisible(check_parent) end

---
---Converts the x, y coordinates from the sprite's (local) coordinates to the global coordinates.
---
---@param local_x number
---@param local_y number
---@return number global_x, number global_y
function Sprite:localToGlobal(local_x, local_y) end

---
---Tell Gideros effects should be updated for this sprite. This is relevant if effect mode was set to something else 
---than `Sprite.EFFECT_MODE_CONTINUOUS` in `Sprite:setEffectStack`. 
---
function Sprite:redrawEffects() end

---
---Removes the specified child Sprite instance from the child list of this Sprite instance.
---
---@param child Sprite # sprite to remove
function Sprite:removeChild(child) end

---
---Removes the child Sprite instance at the specifed index. Index of the first child is 1 and index of the last child
---can be get from Sprite:getNumChildren function.
---
---@param index number # index of child to remove
function Sprite:removeChildAt(index) end

---
---If the sprite has a parent, removes the sprite from the child list of its parent sprite.
---
function Sprite:removeFromParent() end

---
---Sets the values of a sprite instance by name. The possible names for `param` are:
---<ul><li><i>"x"</i></li>
---<li><i>"y"</i></li>
---<li><i>"z"</i></li>
---<li><i>"rotation"</i></li>
---<li><i>"rotationX"</i></li>
---<li><i>"rotationY"</i></li>
---<li><i>"scaleX"</i></li>
---<li><i>"scaleY"</i></li>
---<li><i>"scaleZ"</i></li>
---<li><i>"alpha"</i></li>
---<li><i>"redMultiplier"</i></li>
---<li><i>"greenMultiplier"</i></li>
---<li><i>"blueMultiplier"</i></li>
---<li><i>"alphaMultiplier"</i></li>
---<li><i>"anchorX"</i></li>
---<li><i>"anchorY"</i></li>
---<li><i>"anchorZ"</i></li></ul>
---@param param string # name of parameter
---@param value number # new value
function Sprite:set(param, value) end

---
---Sets the alpha transparency of this sprite. 0 means fully transparent and 1 means fully opaque.
---
---@param alpha number # new value of alpha
function Sprite:setAlpha(alpha) end

---
---Sets x, y, z anchor position of Sprite in its relative (internal) coordinates. 
---
---@param anchor_x number
---@param anchor_y number
---@param anchor_z? number
function Sprite:setAnchorPosition(anchor_x, anchor_y, anchor_z) end

---
---Sets the blend mode of the sprite.
---`blend_mode` is one of the following values:
---<ul><li>Sprite.ALPHA = "alpha"</li>
---<li>Sprite.NO_ALPHA = "noAlpha"</li>
---<li>Sprite.ADD = "add"</li>
---<li>Sprite.MULTIPLY = "multiply"</li>
---<li>Sprite.SCREEN = "screen"</li></ul>
---If a Sprite object doesn't set any blending mode, it takes the blending mode from its parent sprite. 
---
---@param blend_mode string
function Sprite:setBlendMode(blend_mode) end

---
---Sets the blend mode of the sprite.
---`src` and `dst` must be chosen from the following values:
---<ul><li>Sprite.ZERO = "zero"</li>
---<li>Sprite.ONE = "one"</li>
---<li>Sprite.SRC_COLOR = "srcColor"</li>
---<li>Sprite.ONE_MINUS_SRC_COLOR = "oneMinusSrcColor"</li>
---<li>Sprite.DST_COLOR = "dstColor"</li>
---<li>Sprite.ONE_MINUS_DST_COLOR = "oneMinusDstColor"</li>
---<li>Sprite.SRC_ALPHA = "srcAlpha"</li>
---<li>Sprite.ONE_MINUS_SRC_ALPHA = "oneMinusSrcAlpha"</li>
---<li>Sprite.DST_ALPHA = "dstAlpha"</li>
---<li>Sprite.ONE_MINUS_DST_ALPHA = "oneMinusDstAlpha"</li>
---<li>Sprite.SRC_ALPHA_SATURATE = "srcAlphaSaturate"</li></ul>
---@param src string # source blend mode
---@param dst string # destination blend mode
function Sprite:setBlendMode(src, dst) end

---
---Clips Sprite content from provided x, y position to provided width and height. 
---Setting width or height to -1 will disable clipping. 
---
---@param x number # x position from where to clip
---@param y number # y position from where to clip
---@param width number # width of how much to display before clipping
---@param height number # height of how much to display before clipping
function Sprite:setClip(x, y, width, height) end

---
---Sets the red, green, blue and alpha channel multipliers (values between 0 and 1). This function lets you adjust the 
---color multipliers of a display object. 
---This adjustment also applies to the children of this sprite instance.
---@param red_multiplier number # (default = 1)
---@param green_multiplier number # (default = 1) 
---@param blue_multiplier number # (default = 1) 
---@param alpha_multiplier number # (default = 1) 
function Sprite:setColorTransform(red_multiplier, green_multiplier, blue_multiplier, alpha_multiplier) end

---
---Sets both width and height of the Sprite. 
---
---@param width number
---@param height number
function Sprite:setDimensions(width, height) end

---
---change the value of an effect constant from lua 
---
---@param effect_index integer # The effect index in the effect stack 
---@param uniform_name string # The uniform name to change 
---@param data_type integer # The type if data to set (one of the Shader.Cxxx constants) 
---@param mult number # number of elements of the given type to set 
---@param data table # the actual data to set, either as a table or as multiple arguments 
---@overload fun(effect_index: integer, uniform_name: string, data_type: integer, mult: number, ...: any): nil
function Sprite:setEffectConstant(effect_index, uniform_name, data_type, mult, data) end

---
---Sets or removes post processing effects for this sprite. 
---The effect stack is an array of tables, each one describing a post processing stage. Each table can have the following fields: 
---<ul><li><b>buffer</b>: a <a href="/index.php/RenderTarget" title="RenderTarget">RenderTarget</a> that will hold the input of this post processing stage</li>
---<li><b>shader</b>: a <a href="/index.php/Shader" title="Shader">Shader</a> that will be used to draw the buffer above onto the next stage, or on screen <b>optional</b></li>
---<li><b>transform</b>: a <a href="/index.php/Matrix" title="Matrix">Matrix</a> to transform the input buffer before processing <b>optional</b></li>
---<li><b>postTransform</b>: a <a href="/index.php/Matrix" title="Matrix">Matrix</a> to transform the final stage output before displaying <b>optional</b></li>
---<li><b>textures</b>: an array of <a href="/index.php/TextureBase" title="TextureBase">TextureBase</a> to be used by the shader. By default the buffer is used. <b>optional</b></li>
---<li><b>clear</b>: a boolean indicating to clear the buffer before rendering. True by default for the first effect of the stack, false otherwise. <b>optional</b></li>
---<li><b>autoBuffer</b>: a boolean to tell Gideros to resize the buffer to match the Sprite size automatically. False by default. <b>optional</b></li>
---<li><b>autoTransform</b>: a <a href="/index.php/Matrix" title="Matrix">Matrix</a> used in computing the Sprite size when autoBuffer is enabled. <b>optional</b></li></ul>
---@param effect_stack table[] # a table describing the post processing phases to be applied
---@param mode? number # one of the `Sprite.EFFECT_MODE_\*` constants
function Sprite:setEffectStack(effect_stack, mode) end

---
---This function specifies the child placement rules within the grid defined on its parent by Sprite:setLayoutParameters.
---Gideros layout system is heavily based on Java GridBagLayout principle. See here for more explanation: https://www.math.uni-hamburg.de/doc/java/tutorial/uiswing/layout/gridbag.html
---
---The constraint table can contain the following fields: 
---</p>
---<ul><li><b>gridx</b>: the 0-based index of the column the child must be placed into</li>
---<li><b>gridy</b>: the 0-based index of the row the child must be placed into</li>
---<li><b>gridwidth</b>: the number of column this child will take</li>
---<li><b>gridheight</b>: the number of row this child will take</li>
---<li><b>weightx</b>: the horizontal weight of the child. Used to distribute extra space among children</li>
---<li><b>weighty</b>: the vertical weight of the child. Used to distribute extra space among children</li>
---<li><b>anchor</b>: defines where the child should be placed inside its grid space. Can be:</li></ul>
---<p><a href="/index.php/Sprite.LAYOUT_ANCHOR_NORTHWEST" title="Sprite.LAYOUT ANCHOR NORTHWEST">Sprite.LAYOUT_ANCHOR_NORTHWEST</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_NORTH" title="Sprite.LAYOUT ANCHOR NORTH">Sprite.LAYOUT_ANCHOR_NORTH</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_NORTHEAST" title="Sprite.LAYOUT ANCHOR NORTHEAST">Sprite.LAYOUT_ANCHOR_NORTHEAST</a>, 
---<a href="/index.php/Sprite.LAYOUT_ANCHOR_WEST" title="Sprite.LAYOUT ANCHOR WEST">Sprite.LAYOUT_ANCHOR_WEST</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_CENTER" title="Sprite.LAYOUT ANCHOR CENTER">Sprite.LAYOUT_ANCHOR_CENTER</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_EAST" title="Sprite.LAYOUT ANCHOR EAST">Sprite.LAYOUT_ANCHOR_EAST</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_SOUTHWEST" title="Sprite.LAYOUT ANCHOR SOUTHWEST">Sprite.LAYOUT_ANCHOR_SOUTHWEST</a>, <a href="/index.php/Sprite.LAYOUT_ANCHOR_SOUTH" title="Sprite.LAYOUT ANCHOR SOUTH">Sprite.LAYOUT_ANCHOR_SOUTH</a> or <a href="/index.php/Sprite.LAYOUT_ANCHOR_SOUTHEAST" title="Sprite.LAYOUT ANCHOR SOUTHEAST">Sprite.LAYOUT_ANCHOR_SOUTHEAST</a>
---</p>
---<ul><li><b>anchorx</b>: specifies relative placement of the child on X axis. anchor mustn't be set <b>since 2020.7</b></li>
---<li><b>anchory</b>: specifies relative placement of the child on Y axis. anchor mustn't be set <b>since 2020.7</b></li>
---<li><b>fill</b>: in which directions the child should be expanded to fit the grid space. Can be:</li></ul>
---<p><a href="/index.php/Sprite.LAYOUT_FILL_NONE" title="Sprite.LAYOUT FILL NONE">Sprite.LAYOUT_FILL_NONE</a>, <a href="/index.php/Sprite.LAYOUT_FILL_HORIZONTAL" title="Sprite.LAYOUT FILL HORIZONTAL">Sprite.LAYOUT_FILL_HORIZONTAL</a>, <a href="/index.php/Sprite.LAYOUT_FILL_VERTICAL" title="Sprite.LAYOUT FILL VERTICAL">Sprite.LAYOUT_FILL_VERTICAL</a> or <a href="/index.php/Sprite.LAYOUT_FILL_BOTH" title="Sprite.LAYOUT FILL BOTH">Sprite.LAYOUT_FILL_BOTH</a>
---</p>
---<ul><li><b>ipadx</b>: internal horizontal padding</li>
---<li><b>ipady</b>: internal vertical padding</li>
---<li><b>offsetx</b>: final offset applied to the child on X axis, in logical units. <b>since 2020.7</b></li>
---<li><b>offsety</b>: final offset applied to the child on Y axis, in logical units. <b>since 2020.7</b></li>
---<li><b>originx</b>: final offset applied to the child on X axis, as a fraction of the child width. <b>since 2020.7</b></li>
---<li><b>originy</b>: final offset applied to the child on Y axis, as a fraction of the child height. <b>since 2020.7</b></li>
---<li><b>minWidth</b>: minimum width</li>
---<li><b>minHeight</b>: minimum height</li>
---<li><b>prefWidth</b>: preferred width</li>
---<li><b>prefHeight</b>: preferred height</li>
---<li><b>insetTop</b>: the top margin</li>
---<li><b>insetLeft</b>: the left margin</li>
---<li><b>insetBottom</b>: the bottom margin</li>
---<li><b>insetRight</b>: the right margin</li>
---<li><b>insets</b>: sets the above four margins to the same value at once. <b>since 2020.7</b></li></ul>
---<p>Specifying a <b>nil</b> table will clear layout constraints.
---</p><p>When a Sprite is resized by the layout system, an <i>Event.LAYOUT_RESIZED</i> is triggered.
---
---@param constraints table
function Sprite:setLayoutConstraints(constraints) end

---
---<p>Gideros Layout arranges a sprite's children into cells of a grid. With this method, you tell the parent's sprite how the rows and columns of the layout grid should be sized.
---</p><p>If there is extra space available after applying minimum widths and heights, it is distributed according to relative weights of each row/column.
---</p><p>Gideros layout system is heavily based on Java GridBagLayout principle. See here for more explanation:
---<a rel="nofollow" class="external free" href="https://www.math.uni-hamburg.de/doc/java/tutorial/uiswing/layout/gridbag.html">https://www.math.uni-hamburg.de/doc/java/tutorial/uiswing/layout/gridbag.html</a>
---</p><p>The following parameters apply:
---</p>
---<ul><li><b>columnWidths</b>: an array of minimum width for each column</li>
---<li><b>rowHeights</b>: an array of minimum height for each row</li>
---<li><b>columnWeights</b>: an array of relative weights for each column</li>
---<li><b>rowWeights</b>: an array of relative weights for each row</li>
---<li><b>insetTop</b>: the top margin</li>
---<li><b>insetLeft</b>: the left margin</li>
---<li><b>insetBottom</b>: the bottom margin</li>
---<li><b>insetRight</b>: the right margin</li>
---<li><b>insets</b>: sets the above four margins to the same value at once. <b>since 2020.7</b></li>
---<li><b>equalizeCells</b>: distribute extra spaces so that cells have a size proportional to their weights. <b>since 2020.7</b></li>
---<li><b>resizeContainer</b>: allow the parent sprite to be resized if children content is too large. <b>since 2020.5</b></li>
---<li><b>cellSpacingX</b>: horizontal margin between cells. <b>since 2020.7</b></li>
---<li><b>cellSpacingY</b>: vertical margin between cells. <b>since 2020.7</b></li></ul>
---<p>Specifying a <b>nil</b> table will clear layout parameters.
---
---@param parameters SpriteLayoutParameters
function Sprite:setLayoutParameters(parameters) end

---
---Sets the transformation matrix of the sprite.
---
---@param matrix Matrix
function Sprite:setMatrix(matrix) end

---
---Sets the x, y and optional z coordinates of the sprite. 
---
---@param x number
---@param y number
---@param z? number
function Sprite:setPosition(x, y, z) end

---
---Sets the rotation of the sprite in degrees. 
---
---@param rotation number # rotation in degrees
function Sprite:setRotation(rotation) end

---
---sets the rotation of the sprite in degrees around x axis
---
---@param rotation number # degrees x-rotation
function Sprite:setRotationX(rotation) end

---
---sets the rotation of the sprite in degrees around y axis
---
---@param rotation number # degrees y-rotation
function Sprite:setRotationY(rotation) end

---
---sets the horizontal, vertical and z axis scales of the sprite
---
---@param scale_x number
---@param scale_y? number # (default = scaleX of object)
---@param scale_z? number # (default = scaleX of object)
function Sprite:setScale(scale_x, scale_y, scale_z) end

---
---sets x scale of sprite
---
---@param scale number
function Sprite:setScaleX(scale) end

---
---sets y scale of sprite
---
---@param scale number
function Sprite:setScaleY(scale) end

---
---sets z scale of sprite
---
---@param scale number
function Sprite:setScaleZ(scale) end

---
---Sets a shader for this sprite. If nil is provided, sets default shader for the current object. 
---Pass `nil` for optional params.
---
---@param shader Shader
---@param program_type? integer # the type of program this shader should replace
---@param program_variant? integer # the variant of program this shader should replace
---@param inherit? boolean # this shader should be used for sub-sprite too
function Sprite:setShader(shader, program_type, program_variant, inherit) end

---
---change the value of a uniform from lua 
---
---@param uniform_name string # uniform name to change
---@param data_type integer # The type of data to set (one of the Shader.Cxxx constants) 
---@param mult number # number of elements of the given type to set 
---@param data table # the actual data to set
---@param program_type? integer # type of program this constant applies to
---@param program_variant? integer # variant of program this constant applies to
---@overload fun(self: any, uniform_name: string, data_type: integer, mult: number, ...: any)
function Sprite:setShaderConstant(uniform_name, data_type, mult, data, program_type, program_variant) end

---
---Set the skew (ie shear) of the Sprite
---@param kx number # Amount of skew in range -90... 90 degrees 
---@param ky number # Amount of skew in range -90... 90 degrees 
function Sprite:setSkew(kx, ky) end

---
---Set the x skew (ie shear) amoutn of the sprite
---
---@param kx number # Amount of skew in range -90... 90 degrees 
function Sprite:setSkewX(kx) end

---
---Set the y skew (ie shear) amoutn of the sprite
---
---@param ky number # Amount of skew in range -90... 90 degrees 
function Sprite:setSkewY(ky) end

---
---<p>Allows to set a stencil operation to be used when drawing this sprite.
---</p>
---The <b>op</b> table can contain the following fields:
---</p>
---<ul><li><b>stencilClear</b>: (boolean) whether the stencil should be cleared beforehand</li>
---<li><b>stencilMask</b>: (integer) the mask value used in stencil operations</li>
---<li><b>stencilWriteMask</b>: (integer) the mask value used when writing to stencil</li>
---<li><b>stencilRef</b>: (integer) the reference value used in stencil operations</li>
---<li><b>stencilFunc</b>: (integer) the stencil function to use</li>
---<li><b>stencilFail</b>: (integer) the stencil operation when stencil test failed</li>
---<li><b>depthFail</b>: (integer) the stencil operation when depth test failed</li>
---<li><b>depthPass</b>: (integer) the stencil operation when depth test has passed</li></ul>
---<p>Stencil function and operations code are defined in Sprite.STENCIL_xxx fields and correspond to the GL_xxx relevant values in OpenGL stencil documentation <a rel="nofollow" class="external free" href="https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glStencilFunc.xhtml">https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glStencilFunc.xhtml</a>.
---</p>
---
---@param op table|nil # nil to disable stencil
function Sprite:setStencilOperation(op) end

---
---Selects the sets of input events that will not be propagated to parent Sprite if this Sprite is visible.
---
---@param mask number|boolean # A combination of Sprite.EVENTMASK_MOUSE,Sprite.EVENTMASK_TOUCH or Sprite.EVENTMASK_KEY, or false/true for none/all event stopped 
function Sprite:setStopEventPropagation(mask) end

---
---Sets whether or not the sprite is visible. Sprites that are not visible are also taken into consideration while calculating bounds.
---
---@param visible boolean
function Sprite:setVisible(visible) end

---
---Sets the x coordinate of the sprite
---
---@param x number
function Sprite:setX(x) end

---
---Sets the y coordinate of the sprite
---
---@param y number
function Sprite:setY(y) end

---
---Sets the z coordinate of the sprite
---
---@param z number
function Sprite:setZ(z) end

---
---Swap two children index places 
---
---@param child1 Sprite
---@param child2 Sprite
function Sprite:swapChildren(child1, child2) end

---
---Swaps two child sprites at specifed indexes. Each index must be between 1 and the index number of the last child. Can be used to sort sprites into a specific order much faster than adding and removing sprites.
---
---@param index1 integer
---@param index2 integer
function Sprite:swapChildrenAt(index1, index2) end

