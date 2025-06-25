local player1 = Player.new("player1", "gfx/player/64_player.png", 8, 6, 64, 64, 8, 14)
stage:addChild(player1)

-- GAME LOOP
function onEnterFrame(e)
	-- anim state
	if player1.vx == 0 then
		player1.currentanim = "idle"
	elseif player1.vx ~= 0 then
		player1.currentanim = "walk"
	end

	-- keyboard handling
	if player1.iskeyright then
		player1.vx += player1.accel * e.deltaTime
		if player1.vx > player1.maxspeed then player1.vx = player1.maxspeed end
		player1.flip = 1
	elseif player1.iskeyleft then
		player1.vx -= player1.accel * e.deltaTime
		if player1.vx < -player1.maxspeed then player1.vx = -player1.maxspeed end
		player1.flip = -1
	else
		player1.vx = 0
	end

	-- anim loop
	if player1.currentanim ~= "" then
		player1.animtimer = player1.animtimer - e.deltaTime
		if player1.animtimer <= 0 then
			player1.frame += 1
			player1.animtimer = player1.animspeed
			if player1.frame > #player1.anims[player1.currentanim] then
				player1.frame = 1
			end
			player1.bmp:setTextureRegion(player1.anims[player1.currentanim][player1.frame])
		end
	end

	-- move & flip
	player1.x += player1.vx -- * e.deltaTime
	player1:setPosition(player1.x, player1.y)
	player1.bmp:setScale(player1.flip, 1)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
