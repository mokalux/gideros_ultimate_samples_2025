-- This class reads the sprites and box2D bodies created in RUBE
-- And adds them to the screen
	
Rube = Core.class(Sprite)

function Rube:init(scene,levelData)

	-- show texture filled bodies?
	self.showTextureFills = true

	--self.showImageName = true -- print each image name for debugging
	
	self.scene = scene
	self.scene.path = {} -- This stores any path data we need (vertices of bodies that have a pathNum)
	self.scene.idList = {} -- This stores any ids so that we can associate sprites / bodies with each other

	
	-- Create a table to hold jump-through platforms
	
	self.scene.jumpThroughPlatforms = {}
	
	-- Set scale
	-- 1 square on rube = x pixels
	
	local worldScale = 100

	-- Bring in the level data file
	
	local test = dofile(levelData)

	-- Open json file

	-------------------------------------------------------
	-- Add sprites
	-------------------------------------------------------

	for index = 1, #i do
	
		self.sprite = nil
		self.ignoreAtlas = nil -- any classes such as Worm Wraith will need this (stops error showing when no atlas added in Rube)
	
		-- Set the default
		self.isImage = false
		
		-- Get position
		
		self.x = math.floor(i[index].center.x * worldScale)
		self.y = math.floor((i[index].center.y * worldScale)*-1)
		
		-- decide if this is an atlas number or texture

		if(i[index].atlas) then	
			if(string.len(i[index].atlas)<=3) then
				i[index].atlas = tonumber(i[index].atlas)
			end
		end

		
		-- get angle

		self.angle = i[index].angle
		
		self.angleR = (self.angle)*-1
		
		-- Print image name
		--print(i[index].file,i[index].atlas)
		

		-- Loop through each object in level data and add it!
		-- Image names must match what's in RUBE exactly
		
		--print(i[index].file)
		
		if(i[index].file=="hero body.png") then
		
			-- Hero

			local hero = Hero.new(self.scene,self.x,self.y)
			self.isHero = true
			self.scene.physicsLayer:addChild(hero)
			self.scene.hero = hero
			table.insert(self.scene.spritesOnScreen, hero)

		-- swap fruit
		
		elseif(i[index].file=="swap fruit 01.png") then

			self.sprite = SwapFruit.new(self.scene,self.x,self.y,i[index].speed)
			
			
		-- plain fruit
		
		elseif(i[index].file=="plain fruit.png") then

			self.sprite = Fruit.new(self.scene,self.x,self.y)
			
		-- exploding fruit
		
		elseif(i[index].file=="exploding fruit.png") then

			self.sprite = ExplodingFruit.new(self.scene,self.x,self.y)

			
		elseif(i[index].file=="health pickup.png") then
			-- coin
			self.sprite = HealthPickup.new(self.scene,self.x,self.y)
			print(self.x,self.y)

		elseif(i[index].file=="coin 1.png") then
			-- coin
			self.sprite = Coin.new(self.scene,self.x,self.y,i[index].hasGravity)
			table.insert(self.scene.coins, self.sprite)
			
		elseif(i[index].file=="treasure heap.png") then

			self.sprite = TreasureHeap.new(self.scene,self.x,self.y,i[index].atlas)
			--table.insert(self.scene.coins, self.sprite)
			
		elseif(i[index].file=="skull1.png") then
			-- skull
			self.sprite = Loot.new(self.scene,"GREEN_SKULL",50, "green skull",self.x,self.y)
				
		elseif(i[index].file=="spider1.png") then
			-- spider
			self.sprite = Loot.new(self.scene,"GREEN_SPIDER",80, "green spider",self.x,self.y)

		-- big door 1
		
		elseif(i[index].file=="big door 01.png") then

			self.sprite = ClosingDoorUpDown.new(self.scene,self.x,self.y,i[index].atlas,i[index].linearVelocity)
			
						
		-- small door, closes slowly
		
		elseif(i[index].file=="small door closes slowly.png") then

			self.sprite = ClosingDoorSmall.new(self.scene,self.x,self.y,i[index].atlas,i[index].linearVelocity,i[index].flip)

		elseif(i[index].file=="door frame.png") then
			-- Exit door

			self.sprite = Door.new(self.scene, self.x, self.y)
			--self.sprite.emitter:start()
			
		elseif(i[index].file=="gold 1.png") then
			self.sprite = Loot.new(self.scene,"gold 1.png",10, "gold",self.x,self.y)

		elseif(i[index].file=="gold 2.png") then
			self.sprite = Loot.new(self.scene,"gold 2.png",20, "gold",self.x,self.y)
		elseif(i[index].file=="gold 3.png") then
			self.sprite = Loot.new(self.scene,"gold 3.png",30, "gold",self.x,self.y)
		elseif(i[index].file=="gold 4.png") then
			self.sprite = Loot.new(self.scene,"gold 4.png",40, "gold",self.x,self.y)
			
		elseif(i[index].file=="pearl.png") then
			self.sprite = Loot.new(self.scene,"pearl.png",200, "pearl",self.x,self.y)
			
		-- Key Door
		
		elseif(i[index].file=="keydoor.png") then
		
			self.sprite = KeyDoor.new(self.scene,self.x,self.y,i[index].id)
			
		-- Tongue Door
		
		elseif(i[index].file=="tongue.png") then
		
			self.sprite = TongueDoor.new(self.scene,self.x,self.y,i[index].id)

		-- Trap items
		
		elseif(i[index].file=="gold owl.png") then
		
			self.sprite = Loot.new(self.scene,"gold owl.png",50, "trap",self.x,self.y,"no",i[index].id,i[index].startDelay)
			
		-- Drop Spider
		
		elseif(i[index].file=="rube spider.png") then
		
			self.sprite = DropSpider.new(self.scene,self.x,self.y,i[index].id)
			self.ignoreAtlas = true -- so it doesn't show error
			
		-- His thread
			
		elseif(i[index].file=="thread.png") then
		
			self.sprite = DropSpiderThread.new(self.scene,self.x,self.y)
			self.ignoreAtlas = true -- so it doesn't show error
			
			
			
			-- create trap here
				
		-- Crystals
			
		elseif(i[index].file=="red1.png") then
			self.sprite = Crystal.new(self.scene,"red",self.x,self.y)

		elseif(i[index].file=="purple1.png") then

			self.sprite = Crystal.new(self.scene,"purple",self.x,self.y)
				
		-- Claw objects
			
		elseif(i[index].file=="pumpkin.png") then
			self.sprite = ClawObject.new(self.scene,self.x,self.y,"pumpkin.png")
		elseif(i[index].file=="skull.png") then
			self.sprite = ClawObject.new(self.scene,self.x,self.y,"skull.png")
		elseif(i[index].file=="rock.png") then
			self.sprite = ClawObject.new(self.scene,self.x,self.y,"rock.png")
		elseif(i[index].file=="key.png") then
			self.sprite = ClawObject.new(self.scene,self.x,self.y,"key.png",i[index].id)
		elseif(i[index].file=="apple.png") then
			self.sprite = ClawObject.new(self.scene,self.x,self.y,"apple.png")

		-- Signs
			
		elseif(i[index].file=="sign.png") then
			
			self.sprite = Sign.new(self.scene,i[index].signText,i[index].atlas)
			self.ignoreAtlas = true -- so it doesn't show error
			
		-- Up and down spikes (these block movement until a claw object is thrown at them)
			
		-- Spike
			
		elseif(i[index].file=="spike.png") then
			
			self.sprite = Spike.new(self.scene,self.x,self.y,self.angle,i[index].atlas)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="thin spike hole.png") then
			
			self.sprite = ThinSpike.new(self.scene,self.x,self.y,self.angle,i[index].flip,i[index].atlas)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="multi spike.png") then
			
			self.sprite = MultiSpike.new(self.scene,self.x,self.y,i[index].atlas,tonumber(i[index].id))
			self.ignoreAtlas = true
			
		-- Pluckable eye
	
		elseif(i[index].file=="pluck eye.png") then
		
			self.sprite = PluckEye.new(self.scene,self.x,self.y,tonumber(i[index].id),i[index].atlas)
			self.ignoreAtlas = true
			
	
			
		-- Green bug anim
	
		elseif(i[index].file=="green bug.png") then
			
			self.sprite = GreenBug.new(self.scene,self.x,self.y,i[index].atlas)
			self.ignoreAtlas = true

			
		-- Drop switch
		
		elseif(i[index].file=="pluck eye.png") then
		
			self.sprite = PluckEye.new(self.scene,self.x,self.y,tonumber(i[index].id),i[index].atlas)
			self.ignoreAtlas = true
	
		elseif(i[index].file=="drop switch.png") then
		
			self.sprite = DropSwitch.new(self.scene,self.x,self.y,i[index].id,i[index].atlas)
			self.ignoreAtlas = true
				
		-- If this was drag block door
	
		elseif(i[index].file=="drag block door.png") then
	
			if(i[index].id) then
			
				self.sprite = DragBlockDoor.new(self.scene,self.x,self.y,i[index].atlas)
				local id = tonumber(i[index].id)
				self.scene.doors[id] = self.sprite
				self.ignoreAtlas = true

			else
				print("Error = a door does not have an id number Rube")
			end
			
		-- Drag Block Button
	
		elseif(i[index].file=="drag block button.png") then

	
			if(i[index].id) then
			
				self.sprite = DragBlockButton.new(self.scene,self.x,self.y,i[index].id)
				self.ignoreAtlas = true
				
			else
				print("Error = drag block button does not have an id number")
			end
			
			
			
		-- Drop Door

		elseif(i[index].file=="drop door.png") then
			
			self.sprite = DropDoor.new(self.scene,self.x,self.y)
			self.ignoreAtlas = true

		-- Saw
		
		elseif(i[index].file=="saw move 001.png") then

			self.sprite = Saw.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"outQuadratic")
			self.ignoreAtlas = true
			
		elseif(i[index].file=="flying saw body.png") then
			
			self.sprite = FlyingSaw.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"none",i[index].followHero,i[index].speed,i[index].followConstantly,i[index].atlas)
			self.ignoreAtlas = true
			
		-- JellyFish
		
		elseif(i[index].file=="jellyfish1.png") then
			
			self.sprite = JellyFish.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"outQuadratic",i[index].atlas)
			self.ignoreAtlas = true
			
		-- Mashers
		
		elseif(i[index].file=="masher left right.png") then
			
			self.sprite = MasherWithSpring.new(self.scene,self.x,self.y,i[index].masherSpeed,i[index].xMove,i[index].yMove,i[index].flip,i[index].angle*-1,i[index].atlas)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="masher up down.png") then
			
			self.sprite = MasherUpDown.new(self.scene,self.x,self.y,i[index].masherSpeed,i[index].masherYMove,i[index].atlas)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="masher up down 2.png") then
			
			self.sprite = MasherUpDown2.new(self.scene,self.x,self.y,i[index].speed,i[index].atlas,i[index].flip)
			self.ignoreAtlas = true
			
		-- Thwomper
		
		elseif(i[index].file=="thwomper.png" or i[index].file=="thwomper 2.png") then
			
			self.sprite = Thwomper.new(self.scene,self.x,self.y,i[index].startDelay,i[index].upSpeed,i[index].downSpeed,i[index].delayBetween,i[index].file)
			self.ignoreAtlas = true
			

			
		-- Acid Surfaces
		
		elseif(i[index].file=="acid 442 0001.png") then
			
			self.sprite = Acid.new(self.scene,self.x,self.y,"ACID_442")
			self.ignoreAtlas = true
			
		-- Spinners
		
		elseif(i[index].file=="spinner1.png") then

			self.sprite = Spinner.new(self.scene,self.x,self.y,i[index].rotationSpeed,i[index].direction,i[index].atlas)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="giant spinner.png") then

			self.sprite = GiantSpinner.new(self.scene,self.x,self.y,i[index].rotationSpeed,i[index].atlas)
			self.ignoreAtlas = true
			
		-- Turner
		
		elseif(i[index].file=="turner.png") then
			
			self.sprite = Turner.new(self.scene,self.x,self.y)
			self.ignoreAtlas = true
			
		-- Catflap
		
		elseif(i[index].file=="catflap door.png") then
			
			self.sprite = CatFlap.new(self.scene,self.x,self.y,i[index].flip,i[index].atlas)
			self.ignoreAtlas = true
			
		-- Hatch
		
		elseif(i[index].file=="hatch.png") then
			
			self.sprite = Hatch.new(self.scene,self.x,self.y,i[index].flip)
			self.ignoreAtlas = true
			
			print("hatch")
	
		-- Turret
		
		elseif(i[index].file=="turret rube image.png") then

			self.sprite = Turret.new(self.scene,self.x,self.y,i[index].angle,i[index].atlas)
			self.ignoreAtlas = true
			
				
		-- Enemies
			
		elseif(i[index].file=="rounder head.png") then
			
			-- Rounder

			self.sprite = RounderMonster.new(self.scene,self.x,self.y,i[index].radius,i[index].rotationSpeed)
			self.ignoreAtlas = true -- so it doesn't show error
			
		-- Germ
		
		elseif(i[index].file=="germ-rube.png") then

			self.sprite = Germ.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"none",i[index].followHero,i[index].speed)
			self.ignoreAtlas = true
			
		-- Worm Wraith
		
		elseif(i[index].file=="worm wraith walking 0001.png") then
			
			self.sprite = WormWraith.new(self.scene,self.x,self.y,i[index].xSpeed,i[index].id)
			self.ignoreAtlas = true
			
		-- Flying shooter
		
		elseif(i[index].file=="flying shooter body.png") then
	
			self.sprite = FlyingShooter.new(self.scene,self.x,self.y,i[index].speed,i[index].id,i[index].flip)
			self.ignoreAtlas = true
			
			
		-- Shy Worm
		
		elseif(i[index].file=="shy worm.png") then
	
			self.sprite = ShyWorm.new(self.scene,self.x,self.y,i[index].id,i[index].atlas)
			self.ignoreAtlas = true
			
		-- Shy Worm Bush
		
		elseif(i[index].file=="shy bush.png") then
	
			self.sprite = ShyWormBush.new(self.scene,self.x,self.y,i[index].id,i[index].atlas)
			self.ignoreAtlas = true
			
		-- Follow Bug
		
		elseif(i[index].file=="follow bug flying 0001.png") then
	
			self.sprite = FollowBug.new(self.scene,self.x,self.y,i[index].speed,i[index].followConstantly)
			self.ignoreAtlas = true
			
		-- Carry Bugs
		
		elseif(i[index].file=="carry gold 1.png") then

	
			self.sprite = CarryBug.new(self.scene,self.x,self.y,"gold 1.png",i[index].id,i[index].timeBetweenPoints,i[index].delayBetween)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="carry gold 3.png") then
	
			self.sprite = CarryBug.new(self.scene,self.x,self.y,"gold 3.png",i[index].id,i[index].timeBetweenPoints,i[index].delayBetween)
			self.ignoreAtlas = true
			
		elseif(i[index].file=="carry gold 4.png") then
	
			self.sprite = CarryBug.new(self.scene,self.x,self.y,"gold 4.png",i[index].id,i[index].timeBetweenPoints,i[index].delayBetween)
			self.ignoreAtlas = true
			
		-- Creeper Bug
		
		elseif(i[index].file=="creeper bug walk 001.png") then
	
			self.sprite = CreeperBug.new(self.scene,self.x,self.y,i[index].speed,i[index].id)
			self.ignoreAtlas = true
			
		-- Treasure Mite
			
		elseif(i[index].file=="treasure mite 0001.png") then
				
			self.sprite = TreasureMite.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"outQuadratic")
			self.ignoreAtlas = true
			
		-- Flying Wraith
			
		elseif(i[index].file=="flying wraith 01.png") then
					
			self.sprite = FlyingWraith.new(self.scene,self.x,self.y,i[index].id,i[index].timeBetweenPoints,i[index].delayBetween,"none",i[index].followHero,i[index].speed,i[index].followConstantly,i[index].radius)
			self.ignoreAtlas = true
		
		-- Acid Fish
		
		elseif(i[index].file=="acid fish flying 0001.png") then
			
			self.sprite = AcidFish.new(self.scene,self.x,self.y,i[index].yDist,i[index].startDelay,i[index].delayBetween)
			self.ignoreAtlas = true
			
			
		-- Walking Chest
		
		elseif(i[index].file=="walking chest sitting0001.png") then
			
			self.sprite = WalkingChest.new(self.scene,self.x,self.y)
			self.ignoreAtlas = true
			
		-- Falling ball
		
		elseif(i[index].file=="ball spawner.png") then
			
			self.sprite = BallSpawner.new(self.scene,self.x,self.y,i[index].spawnEveryXSecs,i[index].id,i[index].hurtHero,i[index].linearDamping,i[index].restitution,i[index].angle,i[index].atlas,i[index].lifeSpan)
			
			self.ignoreAtlas = true
			
		-- Ball Pressure Plate
		
		elseif(i[index].file=="pressure plate.png") then
		
			if(not(i[index].atlas)) then
				print("error - ball pressure plate needs Atlas (atlas the ball is in)")
			end
			
			self.sprite = BallPressurePlate.new(self.scene,self.x,self.y,i[index].spawnEveryXSecs,i[index].id,i[index].hurtHero,i[index].linearDamping,i[index].restitution,i[index].angle,i[index].atlas,i[index].lifeSpan)
			
			self.ignoreAtlas = true
			
		-- Drag block - dragged around with claw
		
		elseif(i[index].file=="drag block.png") then
		
			self.sprite = DragBlock.new(self.scene,self.x,self.y,i[index].atlas)
			self.ignoreAtlas = true
			
		-- Butt Block
		
		elseif(i[index].file=="butt block.png") then
						
			self.sprite = ButtBlock.new(self.scene,self.x,self.y)

		
		-- Smashable pots
		
		elseif(i[index].file=="pot 001.png") then
						
			self.sprite = Pot.new(self.scene,self.x,self.y,i[index].layer)
		
		else
					
			-- This is just an image
			-- Need to make it choose atlas...
					
			--self.atlasNum = nil
			


			if(i[index].atlas) then
						
		
				if(self.scene.showImages) then
				
					--local atlasNum = i[index].atlas

				self.imageProblem = nil
				
					if(self.scene.atlas) then
					
						if(self.scene.atlas[i[index].atlas]) then
							if(i[index].file) then
							
								if(self.showImageName) then
									print(i[index].file, i[index].center.x, i[index].center.y)
								end
					
								self.sprite = Bitmap.new(self.scene.atlas[i[index].atlas]:getTextureRegion(i[index].file))
								
							else
								self.imageProblem = true
							end
								
						else
							self.imageProblem = true
						end
					else
						self.imageProblem = true
					end
					
					if(self.imageProblem) then
					
						print("Problem with: ",i[index].file, i[index].atlas)
					
					end
					
				end
				self.isImage = true

			else
				if(not(self.ignoreAtlas)) then
					print("ERROR! Image", i[index].file, i[index].center.x, i[index].center.y , "is missing Atlas# property")
				end
			end

		end

		-- Set the scale

		if(self.sprite) then

			-- get the size
			local imageHeight = self.sprite:getHeight()
			--print("imageHeight", imageHeight)
			
			-- get scale
			local scale = 100 / imageHeight

			
			-- Flip?
				
			if(i[index].flip) then
				self.flipValue = -1
			else
				self.flipValue = 1
			end
				
			if(self.isImage) then
				
				self.sprite:setAnchorPoint(.5,.5) -- Set anchor point
				
				-- If scale is has been altered
				
					self.xScale = (scale*i[index].scale)*self.flipValue
					self.yScale = (scale*i[index].scale)
					
					--print("image:",i[index].file,self.xScale,self.yScale)
					
					if(self.xScale == 1) then
					--print("DO NOTHING with", i[index].file)
					

					else
						self.sprite:setScale(self.xScale,self.yScale)
						--print("SCALE", i[index].file)

					end

				
					


			else
					
				if(self.flipValue==-1) then
					self.sprite:setScaleX(self.flipValue)
				end
				
			end
				
			-- set position

			self.sprite:setPosition(self.x,self.y)
			
			-- Set angle
			self.sprite:setRotation(math.deg(self.angle)*-1)
			
			-- Color Tint

			if(i[index].colorTint) then
			
				self.sprite:setColorTransform(i[index].colorTint.r,i[index].colorTint.g,i[index].colorTint.b,1)
				
			end
		
			-- Decide which layer the image should go on
			-- renderOrder 0-100 = behind player
			-- 101 upwards = in front of player

	
			if(self.isImage) then
			
			--print(i[index].file)
		
			

				if(i[index].renderOrder<-999) then
				
					self.scene.behindRube:addChild(self.sprite)
		
				elseif(i[index].renderOrder > -999 and i[index].renderOrder<101) then
				
					self.scene.rube1:addChild(self.sprite)
					
				elseif(i[index].renderOrder > 201 and i[index].renderOrder<300) then
				
					self.scene.rube3:addChild(self.sprite)
					
				elseif(i[index].renderOrder == 2000) then
				
					self.scene.frontLayer:addChild(self.sprite)
					
				else					
					self.scene.rube2:addChild(self.sprite)
					
				end
				
				end
				
				
			--	end

				-- If this image had an id, add it to the table
				
				if(i[index].id) then
				
					i[index].id = tonumber(i[index].id)

					-- Create a table if it doesn't exist
					
					if(not(self.scene.idList[i[index].id])) then
						self.scene.idList[i[index].id] = {}

					end
					
					-- add to very front layer - may need to do better system later
					--self.scene.frontLayer:addChild(self.sprite)
					table.insert(self.scene.idList[i[index].id], self.sprite)
					
					--print("added",i[index].id,"to",self.scene.idList[i[index].id])


			end
			-- for off screen culling
			
			
			if(not(self.sprite.ignoreCull)) then
				table.insert(self.scene.sprites, self.sprite)
			end
				
		-- end if there is a sprite
		
		end
		
	
	--end for each image
	end
	

	
	-- delete table from memory
	i = nil
	
	
	
	-------------------------------------------------------
	-- Get the physics bodies
	-------------------------------------------------------

	for index,theBody in pairs(b) do
	
		-- Get x,y
		
		self.bodyX = math.floor(theBody.position.x * worldScale)
		self.bodyY = math.floor((theBody.position.y * worldScale)*-1)
		
		--create box2d physical object
		
		local body = self.scene.world:createBody{type = b2.STATIC_BODY}
		
		-- If this was a path
		
		if(theBody.id) then
			
			local id = theBody.id
			
			-- Make the path 
			
			if(not(self.scene.path[id])) then
			
	
			
				self.scene.path[id] = {}
				self.scene.path[id].vertices = {}
				self.scene.path[id].vertices.x = {}
				self.scene.path[id].vertices.y = {}
				

			end

			-- Add read the vertices into this table
			
			-- support for older method
			
			if(tonumber(theBody.pathOrder)) then
			
				local bodyX = math.floor(theBody.position.x * worldScale)

				local bodyY = math.floor((theBody.position.y * worldScale)*-1)
				
				self.scene.path[id].vertices.x[tonumber(theBody.pathOrder)] = bodyX
				self.scene.path[id].vertices.y[tonumber(theBody.pathOrder)] = bodyY

			else

			
			-- new method, doesn't require path order

			
			local bodyX = math.floor(theBody.position.x * worldScale)
			local bodyY = math.floor((theBody.position.y * worldScale)*-1)

			self.scene.path[id].vertices.x[#self.scene.path[id].vertices.x+1] = bodyX
			self.scene.path[id].vertices.y[#self.scene.path[id].vertices.y+1] = bodyY
			
			end

		end
		
		
		
		
		
		-- for each fixture (poly shape)
			
		for fixtureIndex, theFixture in pairs(theBody.fixture) do
		
			self.wayPoint = false
		
			if(theBody.id) then
				self.wayPoint = true
			end
			
			-- put any body names here that use id but arent waypoints
			
			if(theBody.name=="dropSpider" or theBody.name=="fadeArt" or theBody.name=="fadeArtBody" or theBody.name=="closeDoor" or theBody.name=="changeDirection" or theBody.name=="windSafeZone") then
				self.wayPoint = false
			end
			
			-- don't add if a way point
			if(not(self.wayPoint)) then

				if(theFixture.type == "polygon") then
				
					local poly = b2.PolygonShape.new()
							
					local coords = {}
					local num = #theFixture.vertices.x
					
					-- If fillWithTexture set, start the shape
						
					if(theBody.fillWithTexture) then
					
		-- Fill this body with a shape texture
		
		-- First create a table to store textures, as we don't want to create them each timeBetweenPoints
		
		if(not(self.scene.shapeTextures)) then
		
			self.scene.shapeTextures = {}

		end
		
		-- Fix for older levels

		if(theBody.fillWithTexture=="true") then
			theBody.fillWithTexture = "mud1.png"
		elseif(levelNum==5) then
			theBody.fillWithTexture = "brick 1.png"
		end
		
		if(not(self.scene.shapeTextures[theBody.fillWithTexture])) then
		
		--print(theBody.fillWithTexture)
	
			self.scene.shapeTextures[theBody.fillWithTexture] = Texture.new("Shape Textures/"..theBody.fillWithTexture, true, {wrap = Texture.REPEAT})

		end
		
		
	--self.shapeTexture = 
					
						self.shape = Shape.new()
						
						if(self.showTextureFills) then
							self.shape:setFillStyle(Shape.TEXTURE, self.scene.shapeTextures[theBody.fillWithTexture])
						end
						self.shape:beginPath()
						
					end
							
					for i=1,#theFixture.vertices.x do

						local x = theFixture.vertices.x[num] * 100
						table.insert(coords,x)
										
						local y = theFixture.vertices.y[num] * 100 *-1
						table.insert(coords,y)
								
						num = num - 1
						
						-- Draw the shape if a fillWithTexture is set
						
						if(theBody.fillWithTexture) then
							self.shape:lineTo(x,y)
						end

					end
						
					-- If a fillWithTexture has been set, end the shape
						
					if(theBody.fillWithTexture) then
					
						self.shape:closePath()
						self.shape:endPath()
						
						if(theBody.name=="fadeArtBody" or theBody.name=="closeDoor" or theBody.name=="changeDirection") then
						
							self.scene.physicsLayer:addChild(self.shape)

							-- Create a table if it doesn't exist
					
							if(not(self.scene.idList[theBody.id])) then
								self.scene.idList[theBody.id] = {}
							end
					
							table.insert(self.scene.idList[theBody.id], self.shape)
							
						else
						
							-- for every other shape texture
							
							-- If a layer has been specified
							
								
							if(theBody.shapeTextureLayer=="rube2") then
							
								self.scene.rube2:addChild(self.shape)
	
							elseif(theBody.shapeTextureLayer=="layer0") then
							
								self.scene.layer0:addChild(self.shape)
								
							elseif(theBody.shapeTextureLayer=="behindRube") then
							
								self.scene.behindRube:addChild(self.shape)
								
							elseif(theBody.shapeTextureLayer=="rube3") then
							
								self.scene.rube3:addChild(self.shape)
								
							elseif(theBody.shapeTextureLayer=="frontLayer") then
							
								self.scene.frontLayer:addChild(self.shape)
								
							else
				
								self.scene.behindRube:addChild(self.shape)
								
							end
							
						end
						
						
						self.shape:setPosition(self.bodyX,self.bodyY)
						self.shape:setRotation(-math.deg(theBody.angle))
						
					end
						
					
					--print(theBody.name,unpack(coords))
					
					poly:set(unpack(coords))
					
					-- This if stops the body being created if it's just a filled shape
					
	
	
					
					if(theBody.name ~= "fadeArtBody" and theBody.name ~= "water") then
						
						-- Put any non-waypoint body names here, that have ids
						
						if(theBody.name=="followHero" or theBody.name=="dropDoor" or theBody.name=="fadeArt" or theBody.name=="dropSpider" or theBody.name=="closeDoor" or theBody.name=="windSafeZone" or theBody.name=="changeDirection") then

							isSensor=true
						else
							isSensor=false
						end
						
						local fixture = body:createFixture{shape = poly, density = 1.0, friction = .2, restitution = .1, isSensor=isSensor}
						body.fixture = fixture
		
						
						if(theBody.name=="removeInstance") then
						
							self.filterData = {categoryBits = 2, maskBits = 128}
							
						elseif(theBody.name=="Jump Through") then
						
							self.filterData = {categoryBits = 16384, maskBits = 32768}
							
						elseif(theBody.name=="Enemy Platform") then
						
							self.filterData = {categoryBits = 16, maskBits = 128}
							
						elseif(theBody.name=="danger") then
						
							self.filterData = {categoryBits = 128, maskBits = 8}
							
						else
							-- ground
							self.filterData = {categoryBits = 2, maskBits = 1+4+128+256+4096+8192}

						end
						
						fixture:setFilterData(self.filterData)
						
					end
					
				
				-- end if polygon
				end
			
			
				
				
				-- Now lets get the body name
				-- Used to tell if ground etc...
				
				if(string.len(theBody.name)==0 or theBody.name=="ground"  or string.sub(theBody.name, 1,4) == "body") then
				
					body.name = "Ground"
				
				else
					
					body.name = theBody.name
				
				end
			
		
				if(theBody.name=="Jump Through") then
					
					table.insert(self.scene.jumpThroughPlatforms, body)
					
				elseif(theBody.name=="danger") then
				
					-- eg spikes
					--body.actAsGround = true
					--body.name = "spikes1"

				elseif(theBody.name=="fadeArt") then
				
					body.id = theBody.id
					
					-- setup sound
					
						-- set up claw sounds
	
					if(not(self.scene.secretAreaSound)) then
					
						self.scene.secretAreaSound = Sound.new("Sounds/find secret area.wav")

					end

					
					
				elseif(theBody.name=="closeDoor") then
				
					body.id = theBody.id
					
				elseif(theBody.name=="dropSpider") then
				
					body.id = theBody.id
					self.scene.dropSpiderYs[theBody.id] = self.bodyY
					
				end
			
			-- end don't add if a waypoint
			end

		-- End for each fixture
		end
				
		-- Position
		
		body:setPosition(self.bodyX,self.bodyY)
	
		
		-- Angle

		local angle = theBody.angle
		body:setAngle(angle*-1)
		
	
	-- end for each body
	end


	-- delete table from memory
	b = nil
	collectgarbage()
	collectgarbage()
	collectgarbage()

-- end init
end
