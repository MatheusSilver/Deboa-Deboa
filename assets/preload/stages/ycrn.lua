function onCreate()
	-- background shit
	makeLuaSprite('sky', 'sky1', -435, -75);
	setLuaSpriteScrollFactor('sky', 1, 1);
	makeLuaSprite('ground (2)', 'ground (2)', -435, -75);
	setLuaSpriteScrollFactor('ground (2)', 1, 1);
	makeLuaSprite('trees', 'trees', -435, -75);
	setLuaSpriteScrollFactor('trees', 1, 1);
	makeLuaSprite('backtrees', 'backtrees', -435, -75);
	setLuaSpriteScrollFactor('backtrees', 1, 1);
	
	addLuaSprite('sky', false);
	addLuaSprite('backtrees', false);
	addLuaSprite('ground (2)', false);
	addluaSprite('trees', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end