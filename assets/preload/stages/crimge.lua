function onCreate()
	makeLuaSprite('sky','cenarios/crimge/sky', -850,-400)
	setGraphicSize("sky", getProperty("sky.width"), getProperty("sky.height")*120)
	addLuaSprite('sky', false)

	makeLuaSprite('mountain','cenarios/crimge/mountain', -900, 50)
	addLuaSprite('mountain', false)

	makeLuaSprite('grass', 'cenarios/crimge/grass', -1150,600)
	addLuaSprite('grass', false)

	makeAnimatedLuaSprite('killer2', 'cenarios/crimge/tree2', 700,-550)
	addAnimationByPrefix('killer2', 'boopp', 'trebacckk', 24, false)
	addLuaSprite('killer2', false)

	makeAnimatedLuaSprite('kill', 'cenarios/crimge/kill', 1000,-600)
	addAnimationByPrefix('kill', 'bop', 'kill', 24, false)
	addLuaSprite('kill', false)

	makeAnimatedLuaSprite('knux', 'cenarios/crimge/knux', -700, -500);
	addAnimationByPrefix('knux', 'first', 'knuckles', 24, true);
	setGraphicSize("knux", getProperty("knux.width")*2)
	objectPlayAnimation('knux', 'first');
	addLuaSprite('knux', false);

	makeLuaSprite ('flowey', 'cenarios/crimge/flowey', 100, 500)
	addLuaSprite('flowey')
	setScrollFactor('mountain', 0.8,0.8)
	setScrollFactor('sky', 0.4,0.4)

	--setGameover('sonic', 'gameOverEndSonic', 'breakfast')
	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/

	close()
end