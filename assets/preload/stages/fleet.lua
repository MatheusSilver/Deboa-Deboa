finishedGameover = false;
startedPlaying = false;
camMoving = false

function onCreate()
	-- background shit
	makeLuaSprite('Wall', 'fleet/Wall', -3800, -1000);
	setScrollFactor('Wall', 0.7, 0.7);
	
	makeLuaSprite('Floor', 'fleet/Floor', -3850, 250);
	scaleObject('Floor', 1.05, 1.05);

	makeLuaSprite('FleetwayBGshit', 'fleet/FleetwayBGshit', -3857, -1595);
	setScrollFactor('FleetwayBGshit', 1, 1);
	scaleObject('FleetwayBGshit', 1, 1);
	
	makeAnimatedLuaSprite('Emerald Beam Charged', 'fleet/Emerald Beam Charged', -1470, -1800);
	addAnimationByPrefix('Emerald Beam Charged', 'start', 'Emerald Beam Charged instance', 24, true);
	
	makeAnimatedLuaSprite('Emeralds', 'fleet/Emeralds', -880,-600);
	addAnimationByPrefix('Emeralds', 'start', 'TheEmeralds instance', 30, true);
	
	makeAnimatedLuaSprite('porkerbop', 'fleet/Porker Lewis', 1200, -900);
	addAnimationByPrefix('porkerbop', 'first', 'Porker FG', 24, false);
	setScrollFactor('porkerbop', 1.1, 1.1);

	makeAnimatedLuaSprite('The Chamber', 'fleet/The Chamber', -1470, 200);
	addAnimationByPrefix('The Chamber', 'fall', 'Chamber Sonic Fall', 24, false);
	setScrollFactor('The Chamber', 1, 1);

	makeLuaSprite('pebles', 'fleet/pebles', -1980, 820);
	scaleObject('pebles', 1.05, 1.05);


	addLuaSprite('Wall', false);
	addLuaSprite('Floor', false);
	addLuaSprite('FleetwayBGshit', false);
	addLuaSprite('Emerald Beam Charged', false);
	addLuaSprite('Emeralds', false);
	addLuaSprite('The Chamber', true);
	addLuaSprite('pebles', true);
	addLuaSprite('porkerbop', true); -- false = add behind characters, true = add over characters

	setCamMove(false)

end

function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('porkerbop', 'first', true);
	end
end

function onUpdate(elapsed)
	if curBeat == 3 then
		setCamMove(true)
		camMoving = true
	end
	if curBeat < 20 and mustHitSection and camMoving then
		updateCamPos('dad')
		triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
	end
end

-- Game over voiceline
function onGameOver()
	runTimer('playFleetLine', 2.7);
	return Function_Continue;
end

function onGameOverConfirm(reset)
	finishedGameover = true;
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A tween you called has been completed, value "tag" is it's tag
	if not finishedGameover and tag == 'playFleetLine' then
		math.randomseed(os.time());
		soundName = string.format('%i', math.random(1, 12));
		playSound(soundName, 1, 'voiceJeff');
		startedPlaying = true;
	end
end

function onSoundFinished(tag)
	if tag == 'voiceJeff' and not finishedGameover then
		soundFadeIn(nil, 4, 0.2, 1);
	end
	
	close(true);
end