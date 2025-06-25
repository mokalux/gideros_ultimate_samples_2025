function fadeFromBlack()

-- Fade the overlay

	local tween = GTween.new(blackOverlay, .5, {alpha=0})

end

function fadeToBlack()

	local tween = GTween.new(blackOverlay, .5, {alpha=1})

end