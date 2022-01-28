function onCreate()
	-- background shit
	
	makeLuaSprite('basedetudo', 'base', -600, -1150);
	setScrollFactor('basedetudo', 1, 1);
    scaleObject('basedetudo', 1.4, 1.4);
    addLuaSprite('basedetudo', false);

	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end