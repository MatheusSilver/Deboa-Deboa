

function onEvent(n,v1,v2)
	if n == "GifPopup" and gifPermitido == true then
		os.execute("speed.gif") -- Isso fará com que el manito possa escolher entre jogar com esse troço chato ou não.
		setPropertyFromClass('flixel.FlxG.autoPause', false) -- lelrelelrelrler
	end
end
