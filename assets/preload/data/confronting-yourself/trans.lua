local dadYPosOriginal = 0;
local bfYPosOriginal = 0;
local dadXPosOriginal = 0;

local animaisdegrandeporte = {'vilaophase3-sarah', 'vilaophase3-lordx', 'vilaophase3-speed'}
--beta-alanina vai dar o efeito da coceira
--sobe, sobe, mais uma
--Vamo que não pode parar
--Corre pra paralela, mas volta pra ajudar
--Se não bateu no peito, pode fazer mais uma
--se errou, faz de novo
--se doeu, se acostuma
--equipe tá formada, só viciado no esporte
--SUPLEMENTAÇÃO PRA ANIMAL DE GRANDE PORTE
--no pós-treino minha shakeira tá como?
--sempre lotada
--é whey, malto, gluta
--e outras paradaaaaaaaaaaaaaaaaaaaa

--Esse code foi revisto enquanto eu estava na temporada de Cirno Marombeira supremacy

function onCreate()

    setProperty('camHUD.alpha', 0)

    bfYPosOriginal = getCharacterY('bf')
    dadYPosOriginal = getCharacterY('dad')
    dadXPosOriginal = getCharacterX('dad') -- usado no ato 7
	
    --makeLuaSprite('modBoaLogo','logodeboa',-1000,-1000)
	--setProperty('modBoaLogo.scale.x', 1.5)
	--setProperty('modBoaLogo.scale.y', 1.5)
    --screenCenter('modBoaLogo', 'x')
    --setObjectCamera('modBoaLogo', 'legenda')
	--addLuaSprite('modBoaLogo',false)
	--Deixando apenas como comentário pois vai que né?
	
    makeLuaSprite('modBoaLogoExe','LogoModBoaEXE',-1000,-1000)
    setProperty('modBoaLogoExe.scale.x', 0.77)
	setProperty('modBoaLogoExe.scale.y', 0.77)
    setObjectCamera('modBoaLogoExe', 'legenda')
    screenCenter('modBoaLogoExe', 'xy')
    setProperty('modBoaLogoExe.y', getProperty('modBoaLogoExe.y')+50)
    setProperty('modBoaLogoExe.visible', false)
	addLuaSprite('modBoaLogoExe', false)

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
	playSound('stat', 0.3, 'stat')
end

function onCountdownTick(value0)
    if value0 == 3 then
        doTweenY('textoTween1', 'introText1', 50, 1, 'cubeinout')
		doTweenY('textoTween2', 'introText2', 125, 2, 'cubeinout')
    end
end

function onEvent(evento, valor1, valor2)
    if evento == 'trans CY' then
        if valor1 == '500' then
            mudarRPCdetalhes('Ato 8 - Intervalo')
        end
        if valor1 == '20' then
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
        end
        if valor1 == '2' then
            cameraFlash('legenda', '0xffffff', 1, true)
        end
        if valor1 == '3' then
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --    setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            --end
            -- O problema principal disso:
			--O sistema antigo foi feito com strum swap e os dois dão conflito entre si.
            
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
            transVermelha()
        end
        if valor1 == '4' then
            cameraFlash('legenda', '0xffffff', 1, true)
        end
        if valor1 == '4-5' then
            transVermelha()
            triggerEvent("Change Character", 'bf', 'Sonicphase3vilao', 'nada', 'nada')
            triggerEvent("trocar stage", '5', 'nada', 'nada', 'nada')
        end
        if valor1 == '4-10' then
            cameraFlash('legenda', '0xffffff', 1, true)
            triggerEvent("Change Character", 'bf', 'Sonicphase3heroi', 'nada', 'nada')
            triggerEvent("trocar stage", '4', 'nada', 'nada', 'nada')
        end
        if valor1 == '5' then
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --    setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            --end
            dueto(false)
            cameraFlash('legenda', '0xff0000', 3, true)
            triggerEvent("Set Cam Zoom", '0.8', 'nada', 'nada', 'nada')
            setProperty('dad.alpha', 1)
            setProperty('iconP2.alpha', 1)
            triggerEvent("Change Character", 'dad', 'Sonic Exe Pixel Flying', 'nada', 'nada')
            triggerEvent("Change Character", 'bf', 'Sonic Pixel Running', 'nada', 'nada')
            for i = 1,#animaisdegrandeporte do
                removeLuaSprite(animaisdegrandeporte[i], true)
            end
        end
        if valor1 == '5-5' then
            for i = 0, getProperty('opponentStrums.length')-1 do
              setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            end
            --triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
            setCamMove(false);
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
            cameraFlash('legenda', '0xff0000', 3, true)
            triggerEvent("Change Character", 'bf', 'Sonic Exe AM', 'nada', 'nada')
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
        end
        if valor1 == '5-6' then
            cameraFlash('legenda', '0xffffff', 3, true)
            triggerEvent("Change Character", 'bf', 'Sonic AM', 'nada', 'nada')
        end
        if valor1 == '5-7' then
            triggerEvent("Change Character", 'bf', 'Sonic Exe AM', 'nada', 'nada')
            triggerEvent("Play Animation", 'laugh', 'bf', 'nada', 'nada')
            setProperty('dad.specialAnim', true)
        end
        if valor1 == '6' then
            setProperty('paredefogo.visible', true)
            doTweenY('fogosobe1', 'paredefogo', 0-screenHeight*3.5, 1, 'linear')
            triggerEvent("strum swap2", 'nada', 'nada', 'nada', 'nada')
            for i = 0, getProperty('opponentStrums.length')-1 do
                setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            end
        end
        if valor1 == '6-5' then
            setProperty('dad.alpha', 1)
            setProperty('iconP2.alpha', 1)
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --  setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            --end
            setCamMove(true);
            triggerEvent("Change Character", 'bf', 'Sonic Pixel Running flip', 'nada', 'nada')
            triggerEvent("Change Character", 'dad', 'Sonic Exe Pixel Flying flip', 'nada', 'nada')
        end
        if valor1 == '7' then
			cyCut('blahblah');
            runTimer('triggerstatic', 3.5)
            setProperty('knuxerabos.y', getCharacterY('boyfriend')+425)
		    setProperty('knuxerabos.x', getProperty('boyfriend.x')+1150)
            doTweenX('knuxindo', 'knuxerabos', getCharacterX('bf')+575, 5.55, 'cubein')
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY+120)
            triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
        end

        if valor1 == '8' then
            cameraFlash('legenda', '0xffffff', 1, true)
            for i = 0, getProperty('opponentStrums.length')-1 do -- Não há muita mudança aqui
                setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            end
            setProperty('dad.alpha', 0)
            setProperty('iconP2.alpha', 0)
        end

        if valor1 == '9' then
            for i = 0, getProperty('opponentStrums.length')-1 do
                if not middlescroll then
                    setPropertyFromGroup('opponentStrums', i, 'visible', true);
				end
            end
            setProperty('dad.alpha', 1)
            setProperty('boyfriend.alpha', 1)
            setProperty('iconP2.alpha', 1)
            cameraFlash('legenda', '0xffff00', 2, true)
        end

        if valor1 == '10' then
            cameraFlash('legenda', '0xffff00', 3, true)
        end

        if valor1 == 'animaisdegrandeporte' then
            --cameraFlash('legenda', '0xff0000', 3, true)
            --triggerEvent("Add Camera Zoom", '0.25', '0.25', 'nada', 'nada')
            for i = 1,#animaisdegrandeporte do
                setProperty(animaisdegrandeporte[i]..'.visible', true)
                doTweenAlpha('tween'..animaisdegrandeporte[i], animaisdegrandeporte[i], 1, 3, 'linear')
            end
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'knuxindo' then
        cyCut('KEK');
        setCamMove(true);
        triggerEvent("trocar stage", '10', 'nada', 'nada', 'nada')
    end
    if tag == 'textoTween1' then
        runTimer('voltar1', 0.1)
        --setProperty('modBoaLogo.x', getProperty('modBoaLogo.x')+100)
    end
    if tag == 'tweendadGroup' then
        triggerEvent("hudfade", '1', '1', 'nada', 'nada')
        setCamMove(true);
    end
    if tag == 'tweenLogoModBoaEXEFinal' then
        cameraFlash('legenda', '0xffffff', 2, true)
        removeLuaSprite('modBoaLogoExe')
        --removeLuaSprite('modBoaLogo')
		removeLuaText('introText1')
		removeLuaText('introText2')
    end
    if tag == 'fogosobe1' then
        removeLuaSprite('paredefogo')
    end
end

function onTimerCompleted(tag)
    if tag == 'triggerstatic' then
        triggerEvent("eventos-tripletrouble", '1024', 'nada', 'nada', 'nada')
    end
    if tag == 'voltar1' then
        runTimer('voltar2',0.5)
        --screenCenter('modBoaLogo', 'x')
    end    
    if tag == 'voltar2' then
        runTimer('voltar5',2.5)
        transVermelha()
        playSound('exerisadinha', 0.8, 'risadinha')
        --setProperty('modBoaLogo.visible', false)
        setProperty('modBoaLogoExe.visible', true)
    end
    if tag == 'voltar5' then
        doTweenY('tweentrens', 'trens', getProperty('trens.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweenflores', 'flores', getProperty('flores.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweendad', 'montesverdes', getProperty('montesverdes.y')-1550, 1.5, 'cubeinout')
        doTweenY('tweenboyfriendGroup', 'boyfriendGroup', getProperty('boyfriendGroup.y')-1500, 1.5, 'cubeinout')
        doTweenY('tweendadGroup', 'dadGroup', getProperty('dadGroup.y')-1500, 1.5, 'cubeinout')  
        doTweenY('tweenLogoModBoaEXEFinal', 'modBoaLogoExe', -500, 0.25, 'cubeinout')
		doTweenY('tweenTexto1Final', 'introText1', -700, 0.25, 'cubeinout')
		doTweenY('tweenTexto2Final', 'introText2', -650, 0.25, 'cubeinout')
    end
end
