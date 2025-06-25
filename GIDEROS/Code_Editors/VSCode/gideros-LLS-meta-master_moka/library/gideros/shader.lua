---@meta
---@diagnostic disable: codestyle-check

---
---<p>Gideros internally uses five distinct shaders:
---</p>
---<ul><li>the ‘<b>Basic</b>’ shader handles shapes with a constant color</li>
---<li>the ‘<b>Color</b>’ shader handles shapes with per-vertex colors (mostly used by Mesh sprite)</li>
---<li>the ‘<b>Texture</b>’ shader handles textured shapes (Bitmaps)</li>
---<li>the ‘<b>TextureColor</b>’ shader handles textured and per-vertex colored shapes</li>
---<li>and the ‘<b>Particle</b>’ shader deals with Box2D particle systems</li></ul>
---<p>The shader API allows replacing the default shader used by Gideros with a custom one, on a sprite per sprite basis. As with most of Gideros API’s this one is <a href="/index.php/Writing_Shaders" title="Writing Shaders">straightforward</a>: you create a Shader object and assign it to one or several sprites.
---</p><p>That said, since Gideros will use your shader as if it was the standard one, you will have to make sure that your custom shader is compatible with the standard one, which essentially means that it takes the same input parameters.
---</p><p>You can also write your <b><a href="/index.php/Lua_Shaders" title="Lua Shaders">shader code in Lua</a></b>, it will then be automatically translated to the relevant shader language for the platform you are using, eg GLSL, HLSL or MTL. This is the recommended way.
---</p>
---
---@class Shader : Object
---@field CMATRIX integer
---@field CFLOAT integer
---@field CFLOAT2 integer
---@field CFLOAT4 integer
---@field CINT integer
---@field CTEXTURE integer
---@field DBYTE integer
---@field DFLOAT integer
---@field DINT integer
---@field DSHORT integer
---@field DUBYTE integer
---@field DUSHORT integer
---@field SYS_NOEN integer
---@field SYS_COLOR integer
---@field SYS_PARTICLE_SIZE integer # uniform of type CFLOAT that holds the particle size to use in a particle shader. 
---@field SYS_RTSCALE integer
---@field SYS_TEXTUREINFO integer # uniform of type CFLOAT4 that holds information about the texture used in a particle shader. 
---@field SYS_WIT integer # uniform of type CMATRIX that holds the World Inverse Transpose matrix 
---@field SYS_WORLD integer # uniform of type CMATRIX that holds the World transform matrix 
---@field SYS_WVP integer
---@field FLAG_NONE integer
---@field FLAG_NO_DEFAULT_HEADER integer 
---@field FLAG_FROM_CODE integer
Shader = {}

---
---Creates new Shader
---
---@param vertex_code_path string # full path with filename to vertex code
---@param frag_code_path string # full path to fragment shader
---@param opt number # a set of numerical flags or 0 if none
---@param uniforms ShaderUniform[]
---@param attrs ShaderAttribute[]
---@return Shader
function Shader.new(vertex_code_path, frag_code_path, opt, uniforms, attrs) end

---
---Returns string of shader language: glsl, msl or hlsl. 
---
---@return string
function Shader.getShaderLanguage() end

---@return string
function Shader.getEngineVersion() end

---
---Returns a table containing various characteristics of the graphics engine 
---
---@return table
function Shader.getProperties() end

---
---Check if this shader object was compiled successfully and is actually usable. 
---
---@return boolean
function Shader:isValid() end

---
---Changes the value of a uniform from Lua
---
---@param uniform_name string
---@param data_type integer # type of data to set
---|`CMATRIX`
---|`CFLOAT`
---|`CFLOAT2`
---|`CFLOAT4`
---|`CINT`
---|`CTEXTURE`
---@param mult integer
---@param data table
---@overload fun(uniform_name: string, data_type: integer, mult: integer, ...: any) : nil
function Shader:setConstant(uniform_name, data_type, mult, data) end


---@class ShaderUniform
---@field name string
---|"vAmount" # CFLOAT2
---|"vDirection" # CFLOAT2
---|"vMatrix"
---|"vRtScale"
---|"fAmount"
---|"fColor"
---|"fDirection"
---|"fQuad"
---|"fTexture"
---|"fTexture2"
---|"fTextureInfo"
---@field type integer
---|`Shader.CMATRIX`
---|`Shader.CFLOAT`
---|`Shader.CFLOAT2`
---|`Shader.CFLOAT4`
---|`Shader.CINT`
---|`Shader.CTEXTURE`
---@field sys integer
---|`Shader.SYS_WVP`
---|`Shader.SYS_COLOR`
---|`Shader.SYS_RTSCALE`
---|`Shader.SYS_TEXTUREINFO`
---|`Shader.SYS_WORLD`
---@field vertex boolean

---@class ShaderAttribute
---@field name string
---|"vVertex"
---|"vColor"
---|"vTexCoord"
---@field type integer
---|`Shader.DBYTE`
---|`Shader.DFLOAT`
---|`Shader.DINT`
---|`Shader.DSHORT`
---|`Shader.DUBYTE`
---|`Shader.DUSHORT`
---@field mult integer
---@field slot integer
---@field offset integer

---@class ShaderVarying
---@field name string

