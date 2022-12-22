function onCreate()
    makeAnimatedLuaSprite('inicio', 'chasingvideo', 0, 0);
	addAnimationByPrefix('inicio', 'chasingvideo anim', 'chasingvideo anim', 30, false);
    setObjectCamera('inicio', 'other');
    scaleObject('inicio', 1, 1);
    addLuaSprite('inicio', true);
    setProperty('inicio.alpha', 0);
	setScrollFactor('inicio', 1, 1);

    makeAnimatedLuaSprite('stat', 'daSTAT', 0, 0);
	addAnimationByPrefix('stat', 'staticFLASH', 'staticFLASH', 24, true);
    setObjectCamera('stat', 'other');
    scaleObject('stat', 5, 5);
    addLuaSprite('stat', true);
    setProperty('stat.alpha', 0);
	setScrollFactor('stat', 1, 1);
end

function onStepHit()
    if curStep == 393 then
        playSound('hitStatic2');
        setProperty('stat.alpha', 1);
        objectPlayAnimation('stat', 'staticFLASH', true);
    end
    if curStep == 394 then
        setProperty('inicio.alpha', 1);
        objectPlayAnimation('inicio', 'chasingvideo anim', false);
        setProperty('stat.alpha', 0);
    end
    if curStep == 490 then
        removeLuaSprite('inicio', true);
        removeLuaSprite('stat', true);
    end
end 