function onCreate()
    --makeAnimatedLuaSprite('stat', 'daSTAT', 0, 0);
	--addAnimationByPrefix('stat', 'staticFLASH', 'staticFLASH', 24, true);
    --setObjectCamera('stat', 'other');
    --scaleObject('stat', 5, 5);
    --addLuaSprite('stat', true);
    --setProperty('stat.alpha', 0);
	--setScrollFactor('stat', 1, 1);

    --[[makeAnimatedLuaSprite('cutscene', 'cutscenechasing', 0, 0);
	addAnimationByPrefix('cutscene', 'video', 'chasingcutscene', 12, false);
    setObjectCamera('cutscene', 'hud2');
    setGraphicSize('cutscene', screenWidth, screenHeight)
    screenCenter('cutscene', 'xy')
    addLuaSprite('cutscene', true);
    setProperty('cutscene.visible', false);]]--

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

    --setGameover('sonic', 'gameOverEndSonic', 'breakfast')
    setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onStepHit()
    if curStep == 394 then
        --playSound('hitStatic2');
        --setProperty('stat.alpha', 1);
        setProperty('fundo.alpha', 0);
        --objectPlayAnimation('stat', 'staticFLASH', true);
    end
    if curStep == 490 then
        --removeLuaSprite('stat', true);
    end

    if curStep == 125 then
        setProperty('fundo.alpha', opacidadeLegendas);
    end

end 

function onEvent(eventName, value1, value2)
    if eventName=='playchasing' then
        if value1=='true' then
            cameraFlash('hud2', '0xffffff', 0.5, true)
            setProperty('cutscene.visible', true)
            playAnim('cutscene', 'video', true)
        elseif value1=='flash' then
            cameraFlash('hud2', '0x000000', 0.05, true)
        else
            cameraFlash('hud2', '0xff0000', 5, true)
            setProperty('bgSkychasing.visible', true)
            triggerEvent('noteskinchangeOPPT', 'NOTE_assets', '');
            triggerEvent('noteskinchangeBF', 'NOTE_assets', 'blood');
            --setProperty('cutscene.visible', false)
            --removeLuaSprite('cutscene', true)
        end
    end             
end