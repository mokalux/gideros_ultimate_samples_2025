---@meta
---@diagnostic disable: codestyle-check

-- version: 1.0

---
---Main Object class from which all Gideros classes inherit.
---
---@class Object
Object = {}

---
---Called by `.new` function of inheriting objects
---To be overriden in inheriting class, if required.
---
---@param ... any # parameters defined in inheriting class
function Object:init(...) end

---
---Called after `.new` function of inheriting class calls `:init`
---To be overriden in inheriting class, if required.
---
---@param ... any # parameters defined in inheriting class
function Object:postInit(...) end

---
---Returns the class name which object directly inherits from. 
---
---@return string class_name # returns base class name
function Object:getBaseClass() end

---
---Returns the class name of the instance as string. 
---
---@return string class_name # returns class name
function Object:getClass() end

---
---Returns true if instance is of provided class name or if it inherits from provided class name. 
---
---@param classname string # the name of the class to check relation to
---@return boolean res # true if instance belongs or inherits from class, false otherwise
function Object:isInstanceOf(classname) end

---
--- Gideros Core functions.
---
---@class Core
Core = {}

---
---Creates and returns new Gideros class type. 
---
---@generic T
---@param type T Object Gideros class from which to inherit
---@param constructor? function Function that should return the args to be supplied to the base class during construction
---@param destructor? function Function called when the object is garbage collected 
---@return T object
function Core.class(type, constructor, destructor) end

---
---Launches a function on a separate thread as a background task.
---Background threads are only executed when the main thread is not running. 
---@param task function # function to be run in background
---@param ...? any # parameter(s) to pass to function
function Core.asyncCall(task, ...) end

---
---Generates and returns a pseudo random number. The random number sequence is guaranteed to be consistent across devices for a given seed.
---If bounds aren't specified, the function will return a floating point number between 0 and 1. If one bound is specified, the function will return an integer number between 1 and that bound (inclusive). If both bounds are specified, the function will return an integer between bound1 and bound2. bound2 must be greater than bound1. 
--- 
---@param generator? number # PRNG algorithm to use, use 0 for default engine (MT19937)
---@param bound1? number # first bound of the range returned number must be in 
---@param bound2? number # second bound of the range returned number must be in 
---@return number|integer random_number # see description of function
function Core.random(generator, bound1, bound2) end

---
---Set the current seed of the specified random number generator. 
---@param generator? number # PRNG algorithm to use, use 0 for default engine (MT19937)
---@param seed? number # seed for that generator
function Core.randomSeed(generator, seed) end

---@class vector
---@field x number
---@field y number
---@field z? number
vector = {}

-- etc
