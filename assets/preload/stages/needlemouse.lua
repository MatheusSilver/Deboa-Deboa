function onCreate()

	makeLuaSprite('hexback', 'stages/needlemouse/sky', -600, -300);
	setLuaSpriteScrollFactor('hexback', 0.9, 0.9);

	makeLuaSprite('sus', 'stages/needlemouse/mountains', -500, 0);
	setLuaSpriteScrollFactor('sus', 1.1, 1.1);
	scaleObject('sus', 1.0, 1.0);

	makeLuaSprite('rus', 'stages/needlemouse/ruins', -500, -300);
	setLuaSpriteScrollFactor('rus', 1.0, 1.0);
	scaleObject('rus', 1.1, 1.1);

	makeLuaSprite('wus', 'stages/needlemouse/buildings', -400, 0);
	setLuaSpriteScrollFactor('wus', 1.0, 1.0);
	scaleObject('wus', 1.1, 1.1);
	
	makeLuaSprite('hexfront', 'stages/needlemouse/CONK_CREET', -500, -300);
	setLuaSpriteScrollFactor('hexfront', 1, 1);
	scaleObject('hexfront', 1.1, 1.1);

	makeLuaSprite('stagecurtains', 'stages/needlemouse/fg', -500, 0);
	setLuaSpriteScrollFactor('stagecurtains', 1.1, 1.1);
	scaleObject('stagecurtains', 1.0, 1.0);

	addLuaSprite('hexback', false);
	addLuaSprite('sus', false);
	addLuaSprite('rus', false);
	addLuaSprite('wus', false);
	addLuaSprite('hexfront', false);
	addLuaSprite('stagecurtains', true);
end