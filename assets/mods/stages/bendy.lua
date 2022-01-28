function onCreate()
	-- background shit

	makeLuaSprite('BACKBACKgROUND', 'BACKBACKgROUND', -1100, -700);
	setLuaSpriteScrollFactor('BACKBACKgROUND', 1, 1);
	scaleObject('BACKBACKgROUND', 1.1, 1.1);
	
	makeLuaSprite('bendymachine', 'bendymachine', -1000, -700);
	setLuaSpriteScrollFactor('bendymachine', 1, 1);
	scaleObject('bendymachine', 1.1, 1.1);

	makeLuaSprite('bendyground', 'bendyground', -1000, -950);
	setLuaSpriteScrollFactor('bendyground', 1, 1);
	scaleObject('bendyground', 1.1, 1.1);

	addLuaSprite('BACKBACKgROUND', false);
	addLuaSprite('bendymachine', false);
	addLuaSprite('bendyground', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end