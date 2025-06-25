---@meta
---@diagnostic disable: codestyle-check

---@class Particles : Sprite
Particles = {}

---
--- creates new particles group
---
---@param is_3d? boolean # whether this particle set should be rendered in 3D
---@param auto_sort? boolean # whether this particle set should be sorted back to front for 3D rendering
---@return Particles
function Particles.new(is_3d, auto_sort) end

---
--- adds particles
---
---<ul><li><b>x</b>,<b>y</b>: particle position</li>
---<li><b>size</b>: particle size</li>
---<li><b>angle</b>: particle orientation</li>
---<li><b>color</b>: particle color</li>
---<li><b>alpha</b>: particle alpha</li>
---<li><b>ttl</b>: time to live, number of frames this particle will stay on screen</li>
---<li><b>tag</b>: tag associated with this particle</li>
---<li><b>speedX</b>, <b>speedY</b>, <b>speedAngular</b>, <b>speedGrowth</b>: amount added to x, y, angle and size at the beginning of each frame</li>
---<li><b>decay</b>, <b>decayAngular</b>, <b>decayGrowth</b>, <b>decayAlpha</b>: factor applied to speedX and speedY, speedAngular, speedGrowth and alpha at the beginning of each frame. A value below 1 will substract and a value above 1 will add to the current value.</li>
---<li><b>z</b>, <b>speedZ</b>: z particle position and associated speed (since Gideros 2022.5)</li>
---<li><b>acceleration", </b>accelerationAngular<b>, </b>accelerationGrowth', <b>accelerationAlpha</b>: amount added each frame to associated speed values (since Gideros 2022.5)</li>
---<li><b>extra</b>: additional float value available in the shader (since Gideros 2022.5)</li></ul>
---
---@param particles_tables table[] # table for multiple particles or arguments for single particle 
---@return number|table # index or table with indexes of added particles
---@overload fun(x: number, y: number, size: number, angle: number, time_to_live: number) : number|table
function Particles:addParticles(particles_tables) end

---
--- clears texture for all particles
---
---@param slot integer # the texture slot that should be cleared. Leave empty or set to 0 for main texture, or if you don't use a specific shader optional (Since Gideros 2022.5)
function Particles:clearTexture(slot) end

---
--- gets dead particles
---
---@return table # list of expired particles
function Particles:getDeadParticles() end

---
--- gets the index of the nearest particle to the given point
---
---@param x number
---@param y number
---@return integer|nil # index of nearest particle, or nil if no particles
function Particles:getNearestParticle(x, y) end 

---
--- gets particle acceleration
---
---@param idx integer # particle index
---@return vector
function Particles:getParticleAcceleration(idx) end

---
--- gets particle angle
---
---@param idx integer # particle index
---@return number angle
function Particles:getParticleAngle(idx) end

---
--- gets particle color and alpha value
---
---@param idx integer # particle index
---@return number colour, number alpha
function Particles:getParticleColor(idx) end

---
--- gets particle decay factors
---
---@param idx integer # particle index
---@return number speed_decay, number alpha_decay, number growth_speed, number angular_speed, number? speed_decay_vector 
function Particles:getParticleDecay(idx) end

---
--- gets particle extra value
---
---@param idx number # particle index
---@return number
function Particles:getParticleExtra(idx) end

---
--- gets particle position
---
---@param idx number # particle index
---@return number x, number y, number? z
function Particles:getParticlePosition(idx) end

---
--- gets particle size in pixels
---
---@param idx number # particle index
---@return number
function Particles:getParticleSize(idx) end

---
--- gets particle speed
---
---@param idx number # particle index
---@return number x, number y, number? z, number angular_vel, number growth_speed
function Particles:getParticleSpeed(idx) end

---
--- gets particle associated tag
---
---@param idx number # particle index
---@return string tag
function Particles:getParticleTag(idx) end

---
--- gets particle initial time to live
---
---@param idx number # particle index
---@return number
function Particles:getParticleTtl(idx) end

---
--- gets particles
---
---@param set? table # optional set of particle indices to query 
---@param tag? string # only return particles matching this tag
---@return table # table containing the state of each particle in the system matching tag if any
function Particles:getParticles(set, tag) end

---
--- tells if the Particle system is paused
---
---@return boolean is_paused
function Particles:isPaused() end

---
--- Removes particles by index in table or as arguments.
--- Pass `nil` to remove them all.
---
---@param idxs nil|number|table # particle(s) to remove
---@overload fun(...: number) : nil
function Particles:removeParticles(idxs) end

---
--- scales or resizes all particles in this sprite
---
---@param scale number
---@param absolute? boolean # if true, scale is an absolute size
function Particles:scaleParticles(scale, absolute) end

---
--- sets particle acceleration
---
---@param idx integer
---@param accel vector
---@param accel_alpha number
---@param accel_growth number
---@param accel_angular number
function Particles:setParticleAcceleration(idx, accel, accel_alpha, accel_growth, accel_angular) end

---
--- sets particle angle
---
---@param idx integer
---@param angle number
function Particles:setParticleAngle(idx, angle) end

---
--- sets particle color
---
---@param idx integer
---@param colour integer
---@param alpha number
function Particles:setParticleColor(idx, colour, alpha) end

---
--- sets particle decay factor
---
---@param idx integer
---@param decay_speed number
---@param decay_alpha number
---@param decay_growth number
---@param decay_angular number
function Particles:setParticleDecay(idx, decay_speed, decay_alpha, decay_growth, decay_angular) end

---
--- sets particle extra value to be sent to the shader
---
---@param idx integer
---@param val number
function Particles:setParticleExtra(idx, val) end 

---
--- sets particle position
---
---@param idx integer
---@param x number
---@param y number
---@param z? number
function Particles:setParticlePosition(idx, x, y, z) end

---
--- sets particle size
---
---@param idx integer
---@param size number
function Particles:setParticleSize(idx, size) end

---
--- sets particle speed
---
---@param idx integer
---@param x? number
---@param y? number
---@param z? number
---@param angular_vel? number
---@param growth_speed? number
function Particles:setParticleSpeed(idx, x, y, z, angular_vel, growth_speed) end

---
--- sets particle tag
---
---@param idx integer
---@param tag number
function Particles:setParticleTag(idx, tag) end

---
--- sets particle time to live
---
---@param idx integer
---@param ttl number # time to live, in seconds
function Particles:setParticleTtl(idx, ttl) end

---
--- pauses or resumes the Particle set
---
---@param paused boolean
function Particles:setPaused(paused) end

---
--- sets texture to all particles
---
---@param texture Texture|TextureRegion
---@param slot integer # the texture slot that the texture should be associated to. Leave empty or set to 0 for main texture, or if you don't use a specific shader
function Particles:setTexture(texture, slot) end
