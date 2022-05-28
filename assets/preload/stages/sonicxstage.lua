function onCreate()
	-- background shit
	
	makeLuaSprite('xfloor', 'xfloor', -330, -84);
	setLuaSpriteScrollFactor('xfloor', 1, 1);
	
	if not lowQuality then

	makeAnimatedLuaSprite('xhands', 'xhands', 200, -62);
	luaSpriteAddAnimationByPrefix('xhands', 'Notknuckles', 'Notknuckles'); 
	setLuaSpriteScrollFactor('xhands', 1, 1);
	scaleObject('xhands', 0.45, 0.45);
		
	makeAnimatedLuaSprite('xeye', 'xeye', -100, 300);
	luaSpriteAddAnimationByPrefix('xeye', 'flower', 'flower'); 
	setLuaSpriteScrollFactor('xeye', 1, 1);
	scaleObject('xeye', 1.5, 1.5);
		
	end

	addLuaSprite('xfloor', false);
	addLuaSprite('xhands', false);
	addLuaSprite('xeye', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end