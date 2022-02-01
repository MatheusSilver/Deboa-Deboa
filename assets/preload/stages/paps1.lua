function onCreate()
	-- background shit
	makeLuaSprite('backg', 'BGha', -400, -300);
	setLuaSpriteScrollFactor('backg', 1, 1);
	makeLuaSprite('front', 'front bg', -400, -325);
	setLuaSpriteScrollFactor('front', 0.9, 0.9);

	makeLuaSprite('gf', 'gfBlue', 1170, 400);
	scaleObject('gf', 1, 1);
	setScrollFactor('gf', 1, 1);
	makeAnimatedLuaSprite('gf', 'gfBlue', 1170, 400)
	luaSpriteAddAnimationByPrefix('gf', 'GFisBlue ', 'GFisBlue ', 24, true)

	addLuaSprite('gf', true);
	addLuaSprite('backg', false);
	addLuaSprite('front', true);
	
	--makeLuaSprite('funpillars2', 'funpillars2', -340, -50);
	--setLuaSpriteScrollFactor('funpillars2', 0.94, 0.94);
	--scaleObject('funpillars2', 0.77, 0.77);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end