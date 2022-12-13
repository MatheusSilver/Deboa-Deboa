	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
    makeLuaSprite('sponge', 'SpingeBinge', 79.5, 467);
	setProperty('sponge.visible', false)
	addLuaSprite('sponge', true);

    makeLuaSprite('blackFuck', 'black', 0, 0);
	scaleObject('blackFuck', 6.0, 6.0);
	setObjectCamera('blackFuck', 'other');
	addLuaSprite('blackFuck', true);

	makeLuaSprite('startCircle', 'StartScreens/Sunky', 50, 0);
	scaleObject('startCircle', 0, 0);
	setObjectCamera('startCircle', 'other');
	addLuaSprite('startCircle', true);

	setProperty('gf.visible', false)

    makeAnimatedLuaSprite('inicio', 'milkcomeco', 0, 0);
	addAnimationByPrefix('inicio', 'milkcomeco init', 'milkcomeco init', 30, false)
    setObjectCamera('inicio', 'other');
	setScrollFactor('inicio', 1, 1);
	setProperty('inicio.antialiasing', true)
	
end

function onStartCountdown()
	runTimer('textmove', 0.6)
	runTimer('textfade', 1.9)
end

function onTimerCompleted(tag)
    if tag == 'textmove' then
		doTweenX('circleTween', 'startCircle', 1, 0.2, 'elasticOut');
		scaleObject('startCircle', 1, 1);
		playSound('flatBONK')
	end
	
    if tag == 'textfade' then
		doTweenAlpha('graphicAlpha', 'blackFuck', 0, 1, 'linear');
		doTweenAlpha('circleAlpha', 'startCircle', 0, 1, 'linear');
	end
	
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
        objectPlayAnimation('inicio', 'milkcomeco init', false)
    end

    if curStep == 98 then
        removeLuaSprite('inicio', false);
    end
end