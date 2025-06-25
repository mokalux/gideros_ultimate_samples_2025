---@meta

---
---The Mesh class is used to create and display custom constructed set of triangles (triangle meshes). It basically consists of 4 arrays:
---
---   - vertex
---   - index
---   - color (optional)
---   - textureCoordinate (optional)
---
---and a texture (optional). The Mesh class provides more than one way to set/modify these arrays.
---
---The Mesh can be 2D or 3D, the latter expects an additional Z coordinate in its vertices. Additionally, 3D meshes and their children are rendered with depth testing enabled, which prevents far objects to be drawn above nearest ones, irrespective of actual drawing order.
---
---**the Mesh class doesn't do bounds check: if an element at index array points to an non-existent vertex, the application may crash
---
---@class Mesh : Sprite
Mesh = {}

---
---Creates a new Mesh object.
---
---@param is_3d? boolean # specifies that this mesh expects a Z coordinate in its vertex array and is thus a 3D mesh
---@return Mesh
function Mesh.new(is_3d) end

---
---creates a new Mesh instance
---
---@return Mesh
function Mesh.new() end

---
---clears the color array
---
function Mesh:clearColorArray() end

---
---clears the index array
---
function Mesh:clearIndexArray() end

---
---clears the Mesh texture
---
function Mesh:clearTexture() end

---
---clears the texture coordinate array
---
function Mesh:clearTextureCoordinateArray() end

---
---clears the vertex array
---
function Mesh:clearVertexArray() end

---
---returns color and alpha of the i-th element from color array
---
---@param idx integer # index
---@return number color
---@return number normalized_alpha
function Mesh:getColor(idx) end

---
---gets the size of the Color array
---
---@return number
function Mesh:getColorArraySize() end

---
---returns the i-th element from index array
---
---@param idx number
---@return number element 
function Mesh:getIndex(idx) end

---
---gets the size of the Index array
---
---@return number size 
function Mesh:getIndexArraySize() end

---
---returns u and v coordinate of the i-th element from texture coordinate array
---
---@param idx number 
---@return number u, number v
function Mesh:getTextureCoordinate(idx) end

---
---gets the size of the Texture Coordinate array
---
---@return number size
function Mesh:getTextureCoordinateArraySize() end

---
---returns x and y coordinate of the i-th element from vertex array
---
---@param idx number
---@return number x, number y # coords of vertex
function Mesh:getVertex(idx) end

---
---gets the size of the Vertices array
---
---@return number size
function Mesh:getVertexArraySize() end

---
---resizes the Color array
---
---If size is smaller than the current color array size, the content is reduced to its first size elements, the rest being dropped.
---
---If size is greater than the current color array size, the content is expanded by inserting at the end as many copies of 0s as needed to reach a size of size elements. 
---
---@param size number # new color array size
function Mesh:resizeColorArray(size) end

---
---resizes the Index array
---
---If size is smaller than the current index array size, the content is reduced to its first size elements, the rest being dropped.
---
---If size is greater than the current index array size, the content is expanded by inserting at the end as many copies of 0s as needed to reach a size of size elements.
---
---@param size number # new index array size
function Mesh:resizeIndexArray(size) end

---
---resizes the texture coordinates array
---
---If size is smaller than the current texture coordinate array size, the content is reduced to its first size elements, the rest being dropped.
---
---If size is greater than the current texture coordinate array size, the content is expanded by inserting at the end as many copies of 0s as needed to reach a size of size elements.
---@param size integer # new texture coordinate array size
function Mesh:resizeTextureCoordinateArray(size) end

---
---resizes the vertex array
---
---If size is smaller than the current vertex array size, the content is reduced to its first size elements, the rest being dropped.
---
---If size is greater than the current vertex array size, the content is expanded by inserting at the end as many copies of 0s as needed to reach a size of size elements.
---
---@param size integer # new vertex array size
function Mesh:resizeVertexArray(size) end

---
---Sets a color at color array. Indices are start from 1. If the color array is not large enough, it's expanded automatically.
---
---@param idx integer
---@param color integer
---@param alpha number
function Mesh:setColor(idx, color, alpha) end

---
---Assigns a new content to the color array, dropping all the elements contained in the color array before the call and replacing them by those specified by the parameters. It accepts multiple values or a Lua array. 
---
---@param colors table # table of colors and alphas
---@overload fun(self: any, ...: any) # a pair or sequence of pairs colors and alphas
function Mesh:setColorArray(colors) end

---
---Sets zero or more colors to a mesh with a single function call.
---
---@param colors table # table of colors and alphas
---@overload fun(self: any, ...: any) # a pair or sequence of pairs colors and alphas
function Mesh:setColors(colors) end

---
---set the face culling mode (undocumented)
---
---@param mode any
function Mesh:setCullMode(mode) end

---
---Assigns a new content to a generic additional array to be used by a shader.
---
---@param idx integer
---@param type integer
---|`Shader.DBYTE`
---|`Shader.DFLOAT`
---|`Shader.DINT`
---|`Shader.DSHORT`
---|`Shader.DUBYTE`
---|`Shader.DUSHORT`
---@param mult number # the vector dimension (1 for simple values, 2 for a vec2/float2, etc) 
---@param count integer # number of elements in the array
---@param data table # actual values
---@overload fun(self: any, idx: number, type: integer, mult: number, count: integer, ...: any)
function Mesh:setGenericArray(idx, type, mult, count, data) end

---
---set an index in the index array. Indices start from 1. If the index array is not large enough, it's expanded automatically.
---
---@param idx integer
---@param index number
function Mesh:setIndex(idx, index) end

---
---Assigns new content to the index array, dropping all the elements contained in the index array before the call and replacing them by those specified by the parameters. It accepts multiple values or a Lua array.
---
---@param indices number[]
---@overload fun(self: Mesh, ...: number)
function Mesh:setIndexArray(indices) end

---
---Sets zero or more indices at index array with a single function call. It accepts multiple values or a Lua array.
---
---```lua 
--- -- set indices 1, 2 and 3 with one function call
--- mesh:setIndices(1, 10, 2, 11, 3, 12)
---
--- -- same as above
--- mesh:setIndices({1, 10, 2, 11, 3, 12})
---
---@param indices number[] # table of sequence of idx/index pairs 
---@overload fun(self: Mesh, ...: number)
function Mesh:setIndices(indices) end

---
---(undocumented) enable instanced rendering and sets the number of instances to draw
---
---@param ... any
function Mesh:setInstanceCount(...) end

---
---(undocumented) set the type of primitives to render
---
---@param ... any
function Mesh:setPrimitiveType(...) end

---
---attach a texture to the Mesh
---
---@param texture TextureBase
---@param slot? number # the slot number which we are adding the Texture to (Meshes can have multiple Textures, one per slot). If omitted, slot=0 is assumed.
function Mesh:setTexture(texture, slot) end

---
---set a texture coordinate in the texture coordinates array
---
---@param idx integer
---@param u number # u coordinate
---@param v any # v coordinate
function Mesh:setTextureCoordinate(idx, u, v) end

---
---Assigns new content to the texture coordinate array, dropping all the elements contained in the texture coordinate array before the call and replacing them by those specified by the parameters. It accepts multiple values or a Lua array.
---
---@param texture_coords integer[]
---@overload fun(self: Mesh, ...: integer)
function Mesh:setTextureCoordinateArray(texture_coords) end

---
---sets several texture coordinates at once
---
function Mesh:setTextureCoordinates() end

---
---set a vertex in the vertex array
---
function Mesh:setVertex() end

---
---sets or replace the whole vertex array
---
function Mesh:setVertexArray() end

---
---sets several vertices at once
---
function Mesh:setVertices() end

