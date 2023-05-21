function onCreate()
	-- background shit
	makeLuaSprite('backwall', 'bestofriendo/wall', -200, -200);
	setScrollFactor('backwall', 0.9, 0.9);
	scaleObject('backwall', 0.8, 0.8);
	
	makeLuaSprite('desk', 'bestofriendo/desk', -170, -100);
	setScrollFactor('desk', 0.9, 0.9);
	scaleObject('desk', 0.7, 0.7);

	makeLuaSprite('robot', 'bestofriendo/robo', -170, -100);
	setScrollFactor('robot', 0.9, 0.9);
	scaleObject('robot', 0.7, 0.7);

	makeLuaSprite('box', 'bestofriendo/box', -170, -100);
	setScrollFactor('box', 0.9, 0.9);
	scaleObject('box', 0.7, 0.7);

	makeLuaSprite('crate', 'bestofriendo/crate', -170, -100);
	setScrollFactor('crate', 0.9, 0.9);
	scaleObject('crate', 0.7, 0.7);

	addLuaSprite('backwall', false);
	addLuaSprite('box', false);
	addLuaSprite('robot', false);
	addLuaSprite('desk', false);
	addLuaSprite('crate', false);
	
	--setGameover() -- Para casos em que é só o BF, basta colocar essa linha de code.
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end