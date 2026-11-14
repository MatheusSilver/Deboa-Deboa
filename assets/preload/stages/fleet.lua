finishedGameover = false;
startedPlaying = false;
camMoving = false

function onCreate()
	precacheSound("SUPERBF")
    precacheSound("beam")
	
	-- background shit
	makeLuaSprite('Wall', 'fleet/Wall', -3800, -1000);
	setScrollFactor('Wall', 0.7, 0.7);
	
	makeLuaSprite('Floor', 'fleet/Floor', -3850, 300); --Fix para o movimento de camera
	scaleObject('Floor', 1.05, 1.05);

	makeLuaSprite('FleetwayBGshit', 'fleet/FleetwayBGshit', -3857, -1595);
	setScrollFactor('FleetwayBGshit', 1, 1);
	scaleObject('FleetwayBGshit', 1, 1);
	
	makeAnimatedLuaSprite('Emerald Beam Charged', 'fleet/Emerald Beam Charged', -1470, -1800);
	addAnimationByPrefix('Emerald Beam Charged', 'start', 'Emerald Beam Charged instance', 24, true);
	
	makeAnimatedLuaSprite('Emeralds', 'fleet/Emeralds', -860,-600);
	addAnimationByPrefix('Emeralds', 'start', 'TheEmeralds instance', 24, true);
	
	makeAnimatedLuaSprite('porkerbop', 'fleet/Porker Lewis', 1200, -900);
	addAnimationByPrefix('porkerbop', 'first', 'Porker FG', 24, false);
	setScrollFactor('porkerbop', 1.1, 1.1);

	--makeAnimatedLuaSprite('The Chamber', 'fleet/The Chamber', -1470, 200);
	--addAnimationByPrefix('The Chamber', 'fall', 'Chamber Sonic Fall', 24, false);
	--setScrollFactor('The Chamber', 1, 1);
	makeLuaSprite('The Chamber', 'fleet/The_Chamber_simples', -1450, 580);
	scaleObject('The Chamber', 1, 0.9);

	-- Se quiser voltar com a anim do sonico caindo é só comentar a linha de cima e descomentar as outras 3 em cima dela.
	makeLuaSprite('pebles', 'fleet/pebles', -1900, 820);
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

	if cameraZoomOnBeat then
		pushScriptData('camFollowEspecifico')
	end

end

function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('porkerbop', 'first', true);
	end
end

function onUpdate(elapsed)
	if curBeat < 20 and not mustHitSection and camMoving then
		updateCamPos('dad')
		triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
	end
end

-- Game over voiceline
function onGameOver()
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

function onEvent(name, value1,value2)
	if name == "Change Character" and value2 == "fleetway-bf" then
		triggerEvent("Add Camera Zoom", "0.25", "0.25")
		playSound("SUPERBF")
	end
	if name == "fast event chaos" then
		if value1 == "beat3" then -- Meio que já disse isso antes, não curto muito eventos associados a curBeat ou curStep exatos 
			setCamMove(true)
			camMoving = true
		elseif value1 == "step7" then
			doTweenZoom('zoom', 'camGame', 0.67, 0.5, 'sineOut');
			triggerEvent('Camera Follow Pos','','')
		elseif value1 == "step8" then
			setProperty('dad.alpha', 1);
			setProperty("dad.y", 500)
			doTweenY('dady', 'dad', -300, 0.7, 'sineOut');
			setProperty('defaultCamZoom',0.67)
		elseif value1 == "step20" then
			doTweenX('dadx', 'dad', -1100, 1.8, 'circInOut');
		elseif value1 == "step64" then
			setProperty('camHUD.alpha', 0)
			setProperty('camHUD.visible', true)
			doTweenAlpha('hudalphatween', 'camHUD', 1, 0.25, 'cubeInOut')
		end
	end
end

--[[function onSoundFinished(tag)
	if tag == 'voiceJeff' and not finishedGameover then
		soundFadeIn(nil, 4, 0.2, 1);
	end
end
]] --Não entendi k