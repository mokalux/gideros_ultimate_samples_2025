--!NEEDS:MainBall.lua
--!NEEDS:Sounds.lua
--!NEEDS:TouchBall.lua
--!NEEDS:classes/scenemanager.lua

LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	self.bg = Bitmap.new(Texture.new("images/bg_shroom.png", true))
	self.bg:setAnchorPoint(0.5, 0.5)
	self.bg:setPosition(conf.width/2, conf.height/2)
	self:addChild(self.bg)
	
	self.ScoreText = TextField.new(conf.fonthard, ""..conf.score)
	self.ScoreText:setTextColor(0xFFCC00)
	self.ScoreText:setPosition(conf.width/2-20, 200)
	self.ScoreText:setScale(2)
	
	self:addChild(self.ScoreText)
	
	--chech
	if conf.score == conf.highscore + 1 then
		sounds:play("highscore")
	end
	--create world instance
	self.world = b2.World.new(0, 0, true)
	--set up de
	
	
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(0, 0)
	local chain = b2.ChainShape.new()
	chain:createLoop(
		-conf.dx,-conf.dy,
		conf.dx+conf.width, -conf.dy,
		conf.dx+conf.width, conf.dy+conf.height,
		-conf.dx, conf.dy+conf.height
	)
	chain.body = body
	
	chain.body.type = "not"
	local fixture = body:createFixture{shape = chain, density = 1.0, 
	friction = 1, restitution = 0.3}
	
	
	--store all bodies sprites here
	self.bodies = {}
	table.insert(chain,chain)
	self.ballsLeft = 0
	self.mainBall = MainBall.new(self, conf.width/2, (conf.height/2)+200)
	self:addChild(self.mainBall)
	local x = math.random(40,conf.width-40)
	local y = math.random(241,500)
	local randomEnemy = math.random(1,10)
	self.touch = TouchBall.new(self,x,y,randomEnemy)
	self:addChild(self.touch)


	--add collision event listener
	self.world:addEventListener(Event.END_CONTACT, function(e)
		--getting contact bodies
		local fixtureA = e.fixtureA
		local fixtureB = e.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		--check if this collision interests use
		if bodyA.type and bodyB.type then
			if bodyA.type == "touch" and bodyB.type =="main" then
				if randomEnemy == 10 then
					sounds:play("ghost")
					self.bardown:stop()
					if conf.score > conf.highscore then
						dataSaver.saveValue("prehighscore",conf.score)
						conf.highscore = conf.score
					end
					conf.yscore = conf.score
					
					sceneManager:changeScene("end", 0, conf.transition, conf.easing)
					conf.score = 0
				else
					self.bardown:stop()
					conf.score = conf.score+1
					sounds:play("hit")
					sceneManager:changeScene("level", 0, conf.transition, conf.easing)
				end
			else
				sounds:play("lost")
				self.bardown:stop()
				if conf.score > conf.highscore then
					dataSaver.saveValue("prehighscore",conf.score)
					conf.highscore = conf.score
				end
				conf.yscore = conf.score
				sceneManager:changeScene("end", 0, conf.transition, conf.easing)
				conf.score = 0
			end
		end
	end)
	
	self.timebar = DT_HealthBar.new({
		width = 500,
		height = 50,
		front_color = 0xFFD944,
		back_color = 0xFF0000,
		max_value = 200
	})
	
	if conf.score<47 then
	self.down = function()
		self.timebar:subtract(20+(conf.score*2.75)*0.1)
	end
	self.bardown = Timer.new(200-(2.75*conf.score),10)
	else 
		self.down = function()
			self.timebar:subtract(32.925)
		end
		self.bardown = Timer.new(70.75,10)
	end
	self.bardown:addEventListener(Event.TIMER, self.down)
	self.bardown:addEventListener(Event.TIMER_COMPLETE, function()
		if randomEnemy == 10 then
			sceneManager:changeScene("level", 0, conf.transition, conf.easing)
		else
			if conf.score > conf.highscore then
				dataSaver.saveValue("prehighscore",conf.score)
				conf.highscore = conf.score
			end
			sounds:play("lost")
			conf.yscore = conf.score
			conf.score = 0
			sceneManager:changeScene("end", 0, conf.transition, conf.easing)
		end
	end)
	self.timebar: setPosition(10,70)
	self:addChild(self.timebar)
	self.bardown:start()
	
	
	
	self:addEventListener(Event.ENTER_FRAME, function() 
		self.world:step(1/60, 8, 3)
		--iterate through all child sprites
		local body
		for i = 1, #self.bodies do
			--get specific body
			body = self.bodies[i]
			--update object's position to match box2d world object's position
			--apply coordinates to sprite
			body.object:setPosition(body:getPosition())
			--apply rotation to sprite
			body.object:setRotation(math.deg(body:getAngle()))
		end
	end)
end

