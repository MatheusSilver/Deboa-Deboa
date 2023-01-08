function onCreate()

	makeAnimationList();

        makeAnimatedLuaSprite('tail', 'XNEW', 5100 - 800, 915 + 40); -- tails
	addAnimationByPrefix('tail', 'idle', 'lordxidle', 24, false)
	addAnimationByPrefix('tail', 'singLEFT', 'XLeft', 24, false) -- no meio é o nome do movimento in code e a direita é o nome da anim no xml
	addAnimationByPrefix('tail', 'singDOWN', 'xidle', 24, false)
	addAnimationByPrefix('tail', 'singUP', 'xup', 24, false)
	addAnimationByPrefix('tail', 'singRIGHT', 'xright', 24, false)
	setScrollFactor('tail', 1, 1);

        -- Mesmo code da CCC sodasse

        makeLuaSprite('run', 'run',3689, 673);
 
	addLuaSprite('run', false);
        setProperty('run.visible', true);
        addLuaSprite('tail', false);
        setProperty('tail.visible', true);

end

--tails shit
--script by Shadow Mario, Kevin Kuntz and other dudos
animationsList = {}
holdTimers = {tail = -1.0};
noteDatas = {tail = 0};
function makeAnimationList()
	animationsList[0] = 'singLEFT';
	animationsList[1] = 'singDOWN';
	animationsList[2] = 'singUP';
	animationsList[3] = 'singRIGHT';
end

function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('tail', 'idle', true);
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Special Sing' then
		if not isSustainNote then
			noteDatas.tail = direction;
		end	
		characterToPlay = 'tail'
		animToPlay = noteDatas.tail;
			
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function playAnimation(character, animId, forced)
	animName = animationsList[animId];
	if character == 'tail' then
		objectPlayAnimation('tail', animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	end
end
--tails shit ends