goIdle = true

function onCreate()

	makeAnimationList();

    makeAnimatedLuaSprite('tail', 'XNEW', 5100 - 800, 915 + 40); -- tails
	addAnimationByPrefix('tail', 'idle', 'lordxidle', 24, true)
	addOffset('tail', 'idle', 0, 0)
	addAnimationByPrefix('tail', 'singLEFT', 'XLeft', 24, false) -- no meio é o nome do movimento in code e a direita é o nome da anim no xml
	addOffset('tail', 'singLEFT', 9, -70)
	addAnimationByPrefix('tail', 'singDOWN', 'xidle', 24, false)
	addOffset('tail', 'singDOWN', -49, -146)
	addAnimationByPrefix('tail', 'singUP', 'xup', 24, false)
	addOffset('tail', 'singUP', 24, 109)
	addAnimationByPrefix('tail', 'singRIGHT', 'xright', 24, false)
	addOffset('tail', 'singRIGHT', -77, -13)
	setScrollFactor('tail', 1, 1);

    -- Mesmo code da CCC sodasse

    makeLuaSprite('run', 'run',3689, 673);
 
	addLuaSprite('run', false);
    setProperty('run.visible', true);
    addLuaSprite('tail', false);
    setProperty('tail.visible', true);

	--setGameover('sonic', 'gameOverEndSonic', 'breakfast')

	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onCreatePost()
	playAnim('tail', 'idle', false);
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

function resetAnim()
	playAnim('tail', 'idle', true);
	goIdle = true
end

function onTimerCompleted(tag)
	if tag == "resetAnim" then
		resetAnim()
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Special Sing' then
		if not isSustainNote then
			noteDatas.tail = direction;
		end	
		cancelTimer("resetAnim")
		goIdle = false

		runTimer("resetAnim", 0.7)
		characterToPlay = 'tail'
		animToPlay = noteDatas.tail;
		
		playAnimation(characterToPlay, animToPlay, true);
	end
end

function playAnimation(character, animId, forced)
	animName = animationsList[animId];
	if character == 'tail' then
		playAnim('tail', animName, forced); -- this part is easily broke if you use objectPlayAnim (I have no idea why its like this)
	end
end
--tails shit ends