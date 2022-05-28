function onCreate()
	-- background shit
	makeLuaSprite('funsky', 'funsky', -300, -60);
	setLuaSpriteScrollFactor('funsky', 0.1, 0.1);
	
	makeAnimatedLuaSprite('funpillars3', 'funpillars3', 369, 12);
	luaSpriteAddAnimationByPrefix('funpillars3', 'MajinBop1 instance ', 'MajinBop1 instance '); 
	setLuaSpriteScrollFactor('funpillars3', 1, 1);
	scaleObject('funpillars3', 1.5, 1.5);
	
	makeLuaSprite('funfog', 'funfog', -300, -50);
	setLuaSpriteScrollFactor('funfog', 1.1, 1);
	scaleObject('funfog', 0.8, 0.7);
	
	addLuaSprite('funsky', false);
	addLuaSprite('funpillars3', false);
	addLuaSprite('funfog', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end