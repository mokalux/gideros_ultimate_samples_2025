---@meta
---@diagnostic disable: codestyle-check

---
---The Matrix class specifies transformation from one coordinate space to another.
---
---These transformations include translation, rotation, scaling and skewing.
---
---A 2D transformation matrix is a 3 x 3 matrix in homogeneous coordinate system: 
---
---<pre>| m11 m12 tx |
---| m21 m22 ty |
---|  0   0   1 |</pre>
---
---You can get and set the values of all six of the properties in a Matrix object: m11, m12, m21, m22, tx, and ty. 
---Matrix can also hold 3D (4x4) matrices. 
---
---@class Matrix : Object
Matrix = {}

---
---Creates a new Matrix object with the specified parameters. 
---
---@param m11? number # (default = 1)
---@param m12? number # (default = 0)
---@param m21? number # (default = 0)
---@param m22? number # (default = 1)
---@param tx? number # (default = 0)
---@param ty? number # (default = 0)
---@return Matrix
function Matrix.new(m11, m12, m21, m22, tx, ty) end

function Matrix:duplicate() end

---
---Builds a matrix from scale/rotation/translation components. 
---
---The scale/rotate/translate specification is given by a table, which can have the following fields:
---
--- - **s** or **scale**: the matrix scale component
--- - **r** or **rotation**: the matrix rotation component (a quaternion)
--- - **t** or **translate** or position: the matrix translation component
---
---@param str table # scale, rotation, translate 
---@param reverse boolean # build a matrix where component application is reverted
---@return Matrix
function Matrix.fromSRT(str, reverse) end

---
--- gets anchor position from matrix transformation
---
---@return number x, number y, number? z
function Matrix:getAnchorPosition() end

---
--- returns the elements of this matrix instance
---
---<pre>  | m11 m12 tx |
---  | m21 m22 ty |
---  |  0   0   1 |</pre>
---
---@nodiscard
---@return number m11, number m12, number m21, number m22, number tx, number ty
function Matrix:getElements() end

---
--- returns the value of the m11 component
---
---@return number
function Matrix:getM11() end

---
--- returns the value of the m12 component
---
---@return number
function Matrix:getM12() end

---
--- returns the value of the m21 component
---
---@return number
function Matrix:getM21() end

---
--- returns the value of the m22 component
---
---@return number
function Matrix:getM22() end

---
--- gets all 16 elements of 4x4 matrix
---
---@return number m11, number m12, number m13, number m14, number m21, number m22, number m23, number m24, number m31, number m32, number m33, number m34, number m41, number m42, number m43, number m44
function Matrix:getMatrix() end

---
--- gets position from matrix transformation
---
---@return number x, number y, number? z
function Matrix:getPosition() end

---
--- gets rotation on x axis
---
---@return number
function Matrix:getRotationX() end

---
--- gets rotation on y axis
---
---@return number
function Matrix:getRotationY() end

---
--- get rotation on z axis
---
---@return number
function Matrix:getRotationZ() end

---
--- gets scale from matrix transformation
---
---@return number x, number y, number? z
function Matrix:getScale() end

---
--- gets scale on x axis
---
---@return number
function Matrix:getScaleX() end

---
--- gets scale on y axis
---
---@return number
function Matrix:getScaleY() end

---
--- gets scale on z axis
---
---@return number
function Matrix:getScaleZ() end

---
--- returns the value of the tx component
---
---@return number
function Matrix:getTx() end

---
--- returns the value of the ty component
---
---@return number
function Matrix:getTy() end

---
--- returns the value of the tz component
---
---@return number
function Matrix:getTz() end

---
--- gets x position
---
---@return number
function Matrix:getX() end

---
--- gets y position
---
---@return number
function Matrix:getY() end

---
--- gets z position
---
---@return number
function Matrix:getZ() end

---
--- inverts the matrix
---
function Matrix:invert() end

---
---Multiplies the current matrix with another
---
---@param matrix Matrix
function Matrix:multiply(matrix) end

---
---Replaces this matrix by an orthographic projection. Suitable for the current 3D engine. 
---
---@param left number # left plane distance
---@param right number
---@param bottom number
---@param top number
---@param near number
---@param far number
function Matrix:orthographicProjection(left, right, bottom, top, near, far) end

---
--- replaces this matrix by a perspective projection
---
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param near number
---@param far number
function Matrix:perspectiveProjection(left, right, bottom, top, near, far) end 

---
--- combines existing rotation with provided rotation
---
---@param angle number
---@param x_vector number
---@param y_vector number
---@param z_vector number
function Matrix:rotate(angle, x_vector, y_vector, z_vector) end

---
--- combines existing scale with provided scale
---
---@param x_scale number
---@param y_scale number
---@param z_scale number
function Matrix:scale(x_scale, y_scale, z_scale) end

---
--- transform matrix for setting anchor position
---
---@param x number
---@param y number
---@param z number
function Matrix:setAnchorPosition(x, y, z) end

---
--- sets all 6 elements of this matrix instance
---
---@param m11 number
---@param m12 number
---@param m21 number
---@param m22 number
---@param tx number
---@param ty number
function Matrix:setElements(m11, m12, m21, m22, tx, ty) end

---
--- sets the value of the m11 component
---
---@param m11 number
function Matrix:setM11(m11) end

---
--- sets the value of the m12 component
---
---@param m12 number
function Matrix:setM12(m12) end

---
--- sets the value of the m21 component
---
---@param m21 number
function Matrix:setM21(m21) end

---
--- sets the value of the m22 component
---
---@param m22 number
function Matrix:setM22(m22) end

---
--- set all 16 elements of 4x4 matrix
---
---@param m11 number
---@param m12 number
---@param m13 number
---@param m14 number
---@param m21 number
---@param m22 number
---@param m23 number
---@param m24 number
---@param m31 number
---@param m32 number
---@param m33 number
---@param m34 number
---@param m41 number
---@param m42 number
---@param m43 number
---@param m44 number
function Matrix:setMatrix(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44) end

---
--- transform matrix for setting position
---
---@param x number
---@param y number
---@param z number
function Matrix:setPosition(x, y, z) end

---
--- sets rotation on x axis
---
---@param val number
function Matrix:setRotationX(val) end

---
--- sets rotation on y axis
---
---@param val number
function Matrix:setRotationY(val) end

---
--- sets rotation on z axis
---
---@param val number
function Matrix:setRotationZ(val) end

---
--- transform matrix for setting scale
---
---@param x number
---@param y? number
---@param z? number
function Matrix:setScale(x, y, z) end

---
--- sets scale on x axis
---
---@param val number
function Matrix:setScaleX(val) end

---
--- sets scale on y axis
---
---@param val number
function Matrix:setScaleY(val) end

---
--- sets scale on z axis
---
---@param val number
function Matrix:setScaleZ(val) end

---
--- sets the value of the tx component
---
---@param val number
function Matrix:setTx(val) end

---
--- sets the value of the ty component
---
---@param val number
function Matrix:setTy(val) end

---
--- sets the value of the tz component
---
---@param val number
function Matrix:setTz(val) end

---
--- sets x position
---
---@param val number
function Matrix:setX(val) end

---
--- sets y position
---
---@param val number
function Matrix:setY(val) end

---
--- sets z position
---
---@param val number
function Matrix:setZ(val) end

---
--- transforms the matrix
---
---@param x number
---@param y number
---@param z number
function Matrix:transformPoint(x, y, z) end

---
--- combines existing translation with provided translation
---
---@param x number
---@param y number
---@param z number
function Matrix:translate(x, y, z) end
