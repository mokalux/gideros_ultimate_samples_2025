---@meta

---@class Shader

---
---Creates new Shader from Lua code (need to include the Lua Shader library code in project)
---
---@param vertex_func fun() : number # Lua function for vertex shader
---@param frag_func fun() : number # Lua function for fragment shader
---@param opt number # a set of numerical flags or 0 if none
---@param uniforms ShaderUniform[]
---@param attrs ShaderAttribute[]
---@param varying? table|nil
---@param funcs? LuaShaderFunc[]|nil
---@param const? table|nil
---@param debug? boolean|nil
---@return Shader
function Shader.lua(vertex_func, frag_func, opt, uniforms, attrs, varying, funcs, const, debug) end

---@class LuaShaderFuncArg
---@field name string
---@field type string

---@class LuaShaderFuncExtraArg
---@field decl string
---@field use string

---@class LuaShaderFunc
---@field name string
---@field rtype string
---@field args LuaShaderFuncArg[]
---@field extra_args LuaShaderFuncExtraArg[]


-- these classes only exist globally as fields in the ShaderEffect class/table, so we don't want
-- to define them globally here either, but we have to define them at file scope or LLS doesn't
-- recognise the definitions
---@class Bloom : ShaderEffect
local Bloom = {}
---@class BlurEffect : ShaderEffect
local BlurEffect = {}
---@class ShadowEffect : ShaderEffect
local ShadowEffect = {}

---@class ShaderEffect
---@field Bloom Bloom
---@field BlurEffect BlurEffect
---@field ShadowEffect ShadowEffect 
ShaderEffect = {}
ShaderEffect.Bloom = Bloom
ShaderEffect.BlurEffect = BlurEffect
ShaderEffect.ShadowEffect = ShadowEffect

---@param sprite Sprite
function ShaderEffect:apply(sprite) end

---@param w number
---@param h number
---@return Bloom
function Bloom.new(w, h) end

---
---@param radius number
---@param glow number
function Bloom:setRadiusAndGlow(radius, glow) end

---@param w number
---@param h number
---@param resolution number
---@return BlurEffect
function BlurEffect.new(w, h, resolution) end

---@param params? table
---@return ShadowEffect
function ShadowEffect.new(params) end