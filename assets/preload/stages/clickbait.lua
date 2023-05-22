function onCreate()
	makeLuaSprite('blck', '', 0, 0);
	makeGraphic('blck', 1280, 720, '000000');
	setProperty('blck.alpha', 0.5)
    setObjectCamera('blck', 'camHUD');
	addLuaSprite('blck', true);

	makeLuaSprite('bg', 'cenarios/hulkbr/bg', -570, 335);
	scaleObject('bg', 1.1,1.1)
	addLuaSprite('bg', false);

	makeLuaSprite('cama', 'cenarios/hulkbr/cama', -300, 750);
	addLuaSprite('cama', false);

	addLuaScript('custom_scripts/ytb_player');

	setPropertyFromClass('GameOverSubstate', 'bgType', 'fleeplay'); --Character json file for the death animation
	--setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'risadamenes'); --put in mods/sounds/

end

function onUpdate()
	if not inGameOver then
	if mustHitSection == false then
		setProperty("defaultCamZoom", 0.8);
	else
		setProperty("defaultCamZoom", 0.75);
	end	
end
end