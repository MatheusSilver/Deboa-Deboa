local dadYPosOriginal = 0;
local bfYPosOriginal = 0;
local dadXPosOriginal = 0;

function onCreate()

    setProperty('camHUD.alpha', 0)

    bfYPosOriginal = getCharacterY('bf')
    dadYPosOriginal = getCharacterY('dad')
    dadXPosOriginal = getCharacterX('dad') -- usado no ato 7

    makeLuaText('comunicador', '0', 1, 0, 0)
    setProperty('comunicador.visible', false) -- yeah, comunicação de variaveis entre luas omagawd
    addLuaText('comunicador', false)
	
    makeLuaSprite('modBoaLogo','logodeboa',-1000,-1000)
	setProperty('modBoaLogo.scale.x', 1.5)
	setProperty('modBoaLogo.scale.y', 1.5)
    screenCenter('modBoaLogo', 'x')
    setObjectCamera('modBoaLogo', 'legenda')
	addLuaSprite('modBoaLogo',false)

    makeLuaSprite('modBoaLogoExe','LogoModBoaEXE',-1000,-1000)
    setProperty('modBoaLogoExe.scale.x', 0.77)
	setProperty('modBoaLogoExe.scale.y', 0.77)
    setObjectCamera('modBoaLogoExe', 'legenda')
    screenCenter('modBoaLogoExe', 'xy')
    setProperty('modBoaLogoExe.visible', false)
	addLuaSprite('modBoaLogoExe', false)

    makeLuaSprite('knuxerabos','tailsknuckles',0,0)
    setProperty("knuxerabos.x", getCharacterX('boyfriend'))
    setProperty("knuxerabos.y", getCharacterY('boyfriend'))
    setProperty('knuxerabos.visible', false)
	addLuaSprite('knuxerabos',false)

    makeLuaSprite('paredefogo','firewall',0,screenHeight+300)
    setObjectCamera('paredefogo', 'legenda')
    setGraphicSize('paredefogo', screenWidth, screenHeight*3)
    screenCenter('paredefogo', 'x')
    setProperty('paredefogo.visible', false)
	addLuaSprite('paredefogo',false)

    makeAnimatedLuaSprite('fx', 'vintage', 0, 0)
	addAnimationByPrefix('fx', 'idle', 'idle', 16, true)
	scaleObject('fx', 3, 3)
	setObjectCamera('fx', 'hud2')
	objectPlayAnimation('fx', 'idle', true)
	setProperty('fx.alpha', 0)
    addLuaSprite('fx', true)

end

function transVermelha()
    setProperty('fx.alpha', 0.8)
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
	playSound('stat', 0.3)
end

function onCountdownTick(value0)
    if value0 == 3 then
        doTweenY('tweenlogodeboa', 'modBoaLogo', (screenHeight - getProperty('modBoaLogo.height'))/2, 1, 'cubeinout')
    end
end

function onEvent(evento, valor1, valor2)
    if evento == 'trans CY' then
        if valor1 == '2' then
            cameraFlash('legenda', '0xffffff', 1, true)
        end
        if valor1 == '3' then
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            end
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
            transVermelha()
        end
        if valor1 == '4' then
            cameraFlash('legenda', '0x0000ff', 1, true)
        end
        if valor1 == '4-5' then
            transVermelha()
            triggerEvent("Change Character", 'bf', 'Sonicphase3vilao', 'nada', 'nada')
            triggerEvent("trocar stage", '5', 'nada', 'nada', 'nada')
        end
        if valor1 == '4-10' then
            cameraFlash('legenda', '0x0000ff', 1, true)
            triggerEvent("Change Character", 'bf', 'Sonicphase3heroi', 'nada', 'nada')
            triggerEvent("trocar stage", '4', 'nada', 'nada', 'nada')
        end
        if valor1 == '5' then
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            end
            cameraFlash('legenda', '0xff0000', 3, true)
            triggerEvent("Set Cam Zoom", '0.8', 'nada', 'nada', 'nada')
            setProperty('dad.alpha', 1)
            setProperty('iconP2.alpha', 1)
            triggerEvent("Change Character", 'dad', 'Sonic Exe Pixel Flying', 'nada', 'nada')
            triggerEvent("Change Character", 'bf', 'Sonic Pixel Running', 'nada', 'nada')
        end
        if valor1 == '5-5' then
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            end
            setCamMove(false);
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
            cameraFlash('legenda', '0xff0000', 3, true)
            triggerEvent("Change Character", 'bf', 'Sonic Exe AM', 'nada', 'nada')
        end
        if valor1 == '5-6' then
            cameraFlash('legenda', '0x0000ff', 3, true)
            triggerEvent("Change Character", 'bf', 'Sonic AM', 'nada', 'nada')
        end
        if valor1 == '5-7' then
            triggerEvent("Change Character", 'bf', 'Sonic Exe AM', 'nada', 'nada')
            triggerEvent("Play Animation", 'laugh', 'bf', 'nada', 'nada')
        end
        if valor1 == '6' then
            setProperty('paredefogo.visible', true)
            doTweenY('fogosobe1', 'paredefogo', 0-screenHeight*3.5, 1, 'linear')
        end
        if valor1 == '6-5' then
            setProperty('dad.alpha', 1)
            setProperty('iconP2.alpha', 1)
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            end
            setCamMove(true);
            triggerEvent("Change Character", 'bf', 'Sonic Pixel Running flip', 'nada', 'nada')
            triggerEvent("Change Character", 'dad', 'Sonic Exe Pixel Flying flip', 'nada', 'nada')
        end
        if valor1 == '7' then
            doTweenX('tweendadGroup2', 'dadGroup', getProperty('dadGroup.x')-300, 7, 'linear')  
            runTimer('desacelera1', 2)
        end

        if valor1 == '8' then
            cameraFlash('legenda', '0x0000ff', 1, true)
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            end
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
        end

        if valor1 == '9' then
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            end
            setProperty('dad.alpha', 1)
            setProperty('boyfriend.alpha', 1)
            setProperty('iconP2.alpha', 1)
            cameraFlash('legenda', '0xffff00', 2, true)
        end

        if valor1 == '10' then
            cameraFlash('legenda', '0xffff00', 3, true)
        end


    end
end

function onTweenCompleted(tag)
    if tag == 'tweenlogodeboa' then
        runTimer('voltar1', 0.1)
        setProperty('modBoaLogo.x', getProperty('modBoaLogo.x')+100)
    end
    if tag == 'tweendadGroup' then
        triggerEvent("hudfade", '1', '1', 'nada', 'nada')
        setCamMove(true);
    end
    if tag == 'tweenLogoModBoaEXEFinal' then
        cameraFlash('legenda', '0xffffff', 2, true)
    end
    if tag == 'fogosobe1' then
        removeLuaSprite('paredefogo')
    end
end

function onTimerCompleted(tag)
    if tag == 'desacelera1' then
        setTextString('comunicador', '3')
        runTimer('desacelera2', 0.5)
    end
    if tag == 'desacelera2' then
        setTextString('comunicador', '5')
        runTimer('desacelera3', 0.5)
    end
    if tag == 'desacelera3' then
        setTextString('comunicador', '7')
        runTimer('desacelera4', 3)
        doTweenX('knuxindo', 'knuxerabos', getCharacterX('bf')+50, 4, 'linear')
    end
    if tag == 'desacelera4' then
        setTextString('comunicador', '10')
        cameraFlash('legenda', '0xffffff', 2, true)
        runTimer('switch', 0.5)
    end

    if tag == 'switch' then
        setCharacterX('dad', dadXPosOriginal)
        cameraFlash('legenda', '0x0000ff', 1, true)
        triggerEvent("trocar stage", '10', 'nada', 'nada', 'nada')
        triggerEvent("eventos-tripletrouble", '144', 'nada', 'nada', 'nada')
        triggerEvent("Change Character", 'bf', 'Sonic Fear', 'nada', 'nada')
        triggerEvent("Change Character", 'dad', 'Soul Tails', 'nada', 'nada')
        triggerEvent("Change Character", 'gf', 'Soul Knuckles', 'nada', 'nada')
    end

    if tag == 'voltar1' then
        runTimer('voltar2',0.5)
        screenCenter('modBoaLogo', 'x')
    end    
    if tag == 'voltar2' then
        runTimer('voltar3',0.1)
        setProperty('modBoaLogo.x', getProperty('modBoaLogo.x')-100)
    end 
    if tag == 'voltar3' then
        runTimer('voltar4',0.3)
        screenCenter('modBoaLogo', 'x')
    end 
    if tag == 'voltar4' then
        runTimer('voltar5',1.5)
        transVermelha()
        playSound('exerisadinha', 0.8)
        setProperty('modBoaLogo.visible', false)
        setProperty('modBoaLogoExe.visible', true)
    end 
    if tag == 'voltar5' then
        doTweenY('tweentrens', 'trens', getProperty('trens.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweenflores', 'flores', getProperty('flores.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweendad', 'montesverdes', getProperty('montesverdes.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweenboyfriendGroup', 'boyfriendGroup', getProperty('boyfriendGroup.y')-1500, 1.5, 'cubeinout')
        doTweenY('tweendadGroup', 'dadGroup', getProperty('dadGroup.y')-1500, 1.5, 'cubeinout')  
        doTweenY('tweenLogoModBoaEXEFinal', 'modBoaLogoExe', -500, 0.25, 'cubeinout')
    end
end