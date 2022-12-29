	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()
    makeAnimatedLuaSprite('fakertransform', 'Faker_Transformation', -72.65, -249.2)
    addAnimationByPrefix('fakertransform', '1', 'TransformationRIGHT instance 1', 24, true)
    addAnimationByPrefix('fakertransform', '2', 'TransformationLEFT instance 1', 24, true)
    addAnimationByPrefix('fakertransform', '3', 'TransformationUP instance 1', 24, true)
    addAnimationByPrefix('fakertransform', '4', 'TransformationDOWN instance 1', 24, true)

    setProperty('fakertransform.alpha', 0)
    addLuaSprite('fakertransform', true)
    objectPlayAnimation('fakertransform', '1', true)

    makeLuaSprite('blackFuck', '', 0, 0);
	makeGraphic('blackFuck',screenWidth,screenHeight,'000000')
	scaleObject('blackFuck', 6.0, 6.0);
	setObjectCamera('blackFuck', 'hud2');
	addLuaSprite('blackFuck', true);
        removeLuaSprite('blackFuck', true);

    setScrollFactor('gf', 1.24, 1);
    setScrollFactor('dad', 1.25, 1);
    setScrollFactor('boyfriend', 1.25, 1);
end

function onStartCountdown()
	runTimer('textmove', 0.6)
	runTimer('textfade', 1.9)
end

function onStepHit()
	if curStep == 768 then
		doTweenAlpha('HudAlpha', 'camHUD', 0, 1, 'linear')
	end

	if curStep == 801 then
		setProperty('fakertransform.x', -72.65+20)
		setProperty('fakertransform.y', -249.2+128)
		setProperty('fakertransform.alpha', 1)
		setProperty('dad.visible', false)
	end

	if curStep == 824 then
		setProperty('fakertransform.x', -72.65+-19)
		setProperty('fakertransform.y', -249.2+138)
		objectPlayAnimation('fakertransform', '2', true)
	end

	if curStep == 836 then
		setProperty('fakertransform.x', -72.65+76)
		setProperty('fakertransform.y', -249.2-110)
		objectPlayAnimation('fakertransform', '3', true)
	end

	if curStep == 848 then
		setProperty('fakertransform.x', -72.65+-110)
		setProperty('fakertransform.y', -249.2+318)
		objectPlayAnimation('fakertransform', '4', true)
	end

	if curStep == 884 then
		setProperty('blackFuck.alpha', 1)
	end
end
