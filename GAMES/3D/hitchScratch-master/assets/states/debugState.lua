--!NEEDS:../services/gameState.lua

-- state for gameState.lua

-- debug
debugScene = Mesh.new(true)
game.State.DEBUG = {
	name = "debug",
	enter = function()
		game:setScene(debugScene)
	end
}
