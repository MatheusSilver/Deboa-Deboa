function onCreate()
	

        -- sprites that only load if low Quality is turned off
        if not lowQuality then
	makeLuaSprite('SoullessBG', 'SoullessBG', -290, -50);
	setLuaSpriteScrollFactor('SoullessBG', 1.0, 1.0);
	end

	addLuaSprite('SoullessBG', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end