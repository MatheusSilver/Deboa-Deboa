	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
    makeLuaSprite('sponge', 'SpingeBinge', 79.5, 467);
	setProperty('sponge.visible', false)
	addLuaSprite('sponge', true);

    makeAnimatedLuaSprite('inicio', 'luanzitoanim', 0, 0);
	addAnimationByPrefix('inicio', 'luanzitoanim play', 'luanzitoanim play', 30, false)
    setObjectCamera('inicio', 'other');
	setScrollFactor('inicio', 1, 1);
	setProperty('inicio.antialiasing', true)
	
end

function onTimerCompleted(tag)	
    if tag == 'FatherReturn' then
		setProperty('sponge.visible', false)
		setProperty('dad.visible', true)
	end
end

function onStepHit()
	if curStep == 538 or curStep == 2273 then
		setProperty('sponge.visible', true)
		setProperty('dad.visible', false)
		runTimer('FatherReturn', 0.7)
	end

	if curStep == 69 then
        doTweenZoom('bruh', 'camGame', 2.2, 4, 'linear')
	end

	if curStep == 96 then
        doTweenZoom('bruh', 'camGame', 0.9, 0.001, 'linear')
	end

    if curStep == 53 then
        addLuaSprite('inicio', false);
        objectPlayAnimation('inicio', 'luanzitoanim play', false)
    end

    if curStep == 96 then
        removeLuaSprite('inicio', false);
    end
end