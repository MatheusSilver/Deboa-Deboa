function onCreatePost()
	setProperty('scoreTxt.visible', false);
	setProperty('judgementCounter.visible', false);
	setProperty('timeBarBG.visible', false);
	setProperty('timeBar.visible', true);
	setTextFont('timeTxt', 'Arial.ttf');

	makeLuaSprite('ytb', 'youtube', 0, 0);
	setObjectCamera('ytb', 'camHUD2');
	screenCenter('ytb')
	setProperty('ytb.y', screenHeight - 25);
	addLuaSprite('ytb', false);

--	setProperty('timeBar.y', 695);
	scaleObject('timeBar', 3.2, 0.6)
	setObjectCamera('timeBar','camHUD2')
	screenCenter('timeBar')
	setProperty('timeBar.y', 680);

	
	setProperty('timeTxt.y', 695);
	setProperty('timeTxt.x', 54);
	scaleObject('timeTxt', 0.5, 0.5);
	setObjectCamera('timeTxt','camHUD2')
	setTextColor('timeTxt', 'D0D0D0')
end