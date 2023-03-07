function onCreate()
    makeAnimatedLuaSprite('stat', 'daSTAT', 0, 0);
	addAnimationByPrefix('stat', 'staticFLASH', 'staticFLASH', 24, true);
    setObjectCamera('stat', 'other');
    scaleObject('stat', 5, 5);
    addLuaSprite('stat', true);
    setProperty('stat.alpha', 0);
	setScrollFactor('stat', 1, 1);

    if legendas == true then
        if downscroll == true then
            if legendasporcima == true then
                makeLuaSprite('fundo', 'letras/chasing/chapixel', 0, -350)
                setScrollFactor('fundo', 0, 0);
                scaleObject('fundo', 1, 1);
                setLuaSpriteCamera('fundo', 'camlegenda');
                addLuaSprite('fundo', true);
                setProperty('fundo.alpha', 0);
            else
                makeLuaSprite('fundo', 'letras/chasing/chapixel', 0, -350)
                setScrollFactor('fundo', 0, 0);
                scaleObject('fundo', 1, 1);
                addLuaSprite('fundo', true);
                setProperty('fundo.alpha', 0);
            end
        else
            if legendasporcima == true then
                makeLuaSprite('fundo', 'letras/chasing/chapixel', 0, 0)
                setScrollFactor('fundo', 0, 0);
                scaleObject('fundo', 1, 1);
                setLuaSpriteCamera('fundo', 'camlegenda');
                addLuaSprite('fundo', true);
                setProperty('fundo.alpha', 0);
            else
                makeLuaSprite('fundo', 'letras/chasing/chapixel', 0, 0)
                setScrollFactor('fundo', 0, 0);
                scaleObject('fundo', 1, 1);
                addLuaSprite('fundo', true);
                setProperty('fundo.alpha', 0);
            end
        end
    end
end

function onStepHit()
    if curStep == 392 then
        --playSound('hitStatic2');
        --setProperty('stat.alpha', 1);
        setProperty('fundo.alpha', 0);
        --objectPlayAnimation('stat', 'staticFLASH', true);
    end
    if curStep == 490 then
        --removeLuaSprite('stat', true);
    end

    if curStep == 125 then
        setProperty('fundo.alpha', 1);
    end

end 