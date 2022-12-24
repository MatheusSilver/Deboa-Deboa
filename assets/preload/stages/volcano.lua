function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'cenarios/WAD/back', -450, -300);
	setLuaSpriteScrollFactor('stageback', 0.9, 0.9);

	makeLuaSprite('mon', 'cenarios/WAD/mount', -250, 0);
	setLuaSpriteScrollFactor('mon', 0.9, 0.9);
	scaleObject('mon', 0.5, 0.5);

	makeLuaSprite('val', 'cenarios/WAD/volc', -440, -800);
	setLuaSpriteScrollFactor('val', 0.9, 0.9);
	scaleObject('val', 0.9, 0.9);
	
	makeLuaSprite('stagefront', 'cenarios/WAD/master', -395, -200);
	setLuaSpriteScrollFactor('stagefront', 0.9, 0.9);
	scaleObject('stagefront', 1.1, 1.1);

	addLuaSprite('stageback', false);
	addLuaSprite('mon', false);
	addLuaSprite('val', false);
	addLuaSprite('stagefront', false);	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end