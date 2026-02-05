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
    

    -- Usado exclusivamente no fim do ato 7 durante a risada do sonico executável.
    makeLuaSprite("redOverlay", "RedVG", 0,0)
    setObjectCamera('redOverlay', 'legenda')
    setGraphicSize('redOverlay', screenWidth, screenHeight)
    screenCenter('redOverlay', "xy")
    setProperty("redOverlay.alpha", 0)
    setProperty("redOverlay.visible", false)
    addLuaSprite("redOverlay", false)

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
    --soundFadeCancel('statica')
    setProperty('fx.alpha', 0.8)
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
    --playSound('stat', 0.4, 'statica')
    --soundFadeOut('statica', 1.5)
end

function onSongStart()
    doTweenY('textoTween1', 'introText1', 50, 1, 'cubeinout')
	doTweenY('textoTween2', 'introText2', 125, 2, 'cubeinout')
end

function onEvent(evento, valor1, valor2)
    if evento == 'trans CY' then
        if valor1 == '500' then
            mudarRPCdetalhes('cy_ato_8_half')
        end
        if valor1== "preTransAto9" then
            setCamMove(false)
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
            setCharacterX("bf", getCharacterX("bf")-1500)
            setCharacterX("dad", getCharacterX("dad")-1500)
        end
        if valor1 == '20' then
            triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
        end
        if valor1 == '2' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 1, true)
            end
        end
        if valor1 == '3' then
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --    setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
            --end
            -- O problema principal disso:
			--O sistema antigo foi feito com strum swap e os dois dão conflito entre si.
            
            fastChar('invisibruphase3heroi', 'Sonicphase3vilao')
            setProperty('HUD.iconP2.alpha', 0)
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY, true)
            transVermelha()
        end
        if valor1 == '4' then
            fastChar('Sonicphase3heroi', 'invisibruphase3vilao')
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY, true)
            if flashing then
            cameraFlash('legenda', '0xffffff', 1, true)
            end
        end
        if valor1 == '4-5' then
            transVermelha()
            fastChar('invisibruphase3heroi', 'Sonicphase3vilao')
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY, true)
            triggerEvent("trocar stage", '5', 'nada', 'nada', 'nada')
        end
        if valor1 == '4-10' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 1, true)
            end
            fastChar('Sonicphase3heroi', 'invisibruphase3vilao')
            triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY, true)
            triggerEvent("trocar stage", '4', 'nada', 'nada', 'nada')
        end
        if valor1 == '5' then
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --    setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            --end
            dueto(false)
            if flashing then
            cameraFlash('legenda', '0xff0000', 3, true)
            end
            triggerEvent("Set Cam Zoom", '0.8', 'nada', 'nada', 'nada')
            setProperty('HUD.iconP2.alpha', 1)
            fastChar('Sonic Pixel Running ato4', 'Sonic Exe Pixel Flying ato4')
            for i = 1,#animaisdegrandeporte do
                removeLuaSprite(animaisdegrandeporte[i], true)
            end
        end
        if valor1 == "reactivateCamera" then
            setCamMove(true)
        end
        if valor1 == '5-5' then
            if not middlescroll then
                for i = 0, getProperty('opponentStrums.length')-1 do
                    setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
                end
            end
            --triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
            setCamMove(false);
            setProperty('HUD.iconP2.alpha', 0)
            if flashing then
            cameraFlash('legenda', '0xff0000', 3, true)
            end
            triggerEvent('Camera Follow Pos',camPosBFX+125,camPosBFY)
            fastChar('Invisibru AM', 'Sonic Exe AM')
        end
        if valor1 == '5-6' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 3, true)
            end
            fastChar('Sonic AM', 'Invisibru Exe AM')
        end
        if valor1 == '5-7' then
            fastChar('Invisibru AM', 'Sonic Exe AM')
            triggerEvent("Change Character", 'dad', 'Sonic Exe AM', 'nada', 'nada')
            triggerEvent("Play Animation", 'laugh', 'dad', 'nada', 'nada')
            setProperty('dad.specialAnim', true)
        end
        if valor1 == '6' then
            -- Lembrar de buscar o som da parede de fogo no Sonic 3 & Knuckles
            -- A parte do knux é importante!!!
            setProperty('paredefogo.visible', true)
            doTweenY('fogosobe1', 'paredefogo', 0-screenHeight*3.5, 1, 'linear')
            triggerEvent("strum swap2", 'nada', 'nada', 'nada', 'nada')
            triggerEvent("Set Cam Zoom", '1', 'nada', 'nada', 'nada')
            if not middlescroll then
                for i = 0, getProperty('opponentStrums.length')-1 do
                    setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
                end
            end
        end
        if valor1 == '6-5' then
            setProperty('HUD.iconP2.alpha', 1)
            --for i = 0, getProperty('opponentStrums.length')-1 do
            --  setPropertyFromGroup('opponentStrums', i, 'visible', true); -- Experimental, mas acho que deve funfar
            --end
            setCamMove(true);
            triggerEvent("Change Character", 'bf', 'Sonic Pixel Running flip', 'nada', 'nada')
            triggerEvent("Change Character", 'dad', 'Sonic Exe Pixel Flying flip', 'nada', 'nada')
            changeIcon('normal')
        end
        if valor1 == '7' then
            setCamMove(false)
			cyCut('blahblah');
            runTimer('triggerstatic', 4)
            triggerEvent('Camera Follow Pos',camPosBFX-900,camPosBFY+165)
            setProperty('boyfriend.x', getCharacterX('bf')-600)
            setProperty('dad.y', getCharacterY('dad')+300) -- Só pra tirar o pé dele da cena
                                                           -- Sim, seria mais fácil deixar ele invisível
                                                           -- Mas isso iria complicar muito depois já que a troca de boneco é rápida.
            setProperty('knuxerabos.y', getCharacterY('bf')+425)
		    setProperty('knuxerabos.x', getCharacterX('bf')+2000)
            runTimer('followdepois', 2.5)
            runTimer('lockmovement', 2.48) -- Essa linha talvez precise ser ajustada 
                                           -- Caso perceba alguma quebra de movimento bruta.
                                                            
            triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
        end

        if valor1 == '8' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 1, true)
            end
            if not middlescroll then
                for i = 0, getProperty('opponentStrums.length')-1 do -- Não há muita mudança aqui
                    setPropertyFromGroup('opponentStrums', i, 'visible', false); -- Experimental, mas acho que deve funfar
                end
            end
            setProperty('dad.alpha', 0)
            setProperty('HUD.iconP2.alpha', 0)
        end
        if valor1 == 'preTransAto8' then
            setProperty("redOverlay.visible", true)
            doTweenAlpha("redOverlayout", "redOverlay", 1, 1.75, "linear")
            triggerEvent("hudfade", "0", "1.5")
            
        end

        if valor1 == '9' then
            if not middlescroll then
                for i = 0, getProperty('opponentStrums.length')-1 do
                    setPropertyFromGroup('opponentStrums', i, 'visible', true);
				end
            end
            setProperty('dad.alpha', 1)
            setProperty('boyfriend.alpha', 1)
            setProperty('HUD.iconP2.alpha', 1)
            triggerEvent("strum swap1", "false", 'false')
            if flashing then
            cameraFlash('legenda', '0xffff00', 4, true)
            end
            --setCharacterX("bf", getCharacterX("bf")-1500)
            --setCharacterX("dad", getCharacterX("dad")-1500)
            --Copiando ideias de forma gratuita :sunglasses:
            triggerEvent('Camera Follow Pos',camPosBFX-500,camPosBFY)
            doTweenX('bfIndoATO9', 'boyfriend', getCharacterX('bf')+1300, 3, 'cubeinOut')
            doTweenX('dadIndoATO9', 'dad', getCharacterX('dad')+1900, 2.5, 'cubeinOut')
            
            changeHealthBar(false)
        end
        if valor1 == "ato9lockCameras" then
            setCamMove(false)
            triggerEvent('Camera Follow Pos',(camPosBFX+camPosDadX)/2,(camPosBFY+camPosDadY)/2)
            triggerEvent("Set Cam Zoom", '0.63', 'nada', 'nada', 'nada')
        end
        if valor1=="ato9unlockCamerasPT2" then
            setCamMove(true)
            triggerEvent("Set Cam Zoom", '0.75', 'nada', 'nada', 'nada')
        end
        if valor1 == "preTrans10" then
            setCamMove(false)
            --triggerEvent('Camera Follow Pos',(camPosBFX+camPosDadX)/2,(camPosBFY+camPosDadY)/2)
            triggerEvent("Set Cam Zoom", '0.75', 'nada', 'nada', 'nada')
            
            doTweenX('bfIndoATOfinale', 'boyfriend', getCharacterX('boyfriend')+3300, 2, 'cubein')
            doTweenX('dadIndoATOfinale', 'dad', getCharacterX('dad')+3500, 2, 'cubein')
        end
        if valor1 == '10' then
            if flashing then
            cameraFlash('legenda', '0xffff00', 3, true)
            end
            setCamMove(true)            
            triggerEvent("Particula CY", 'nada', 'nada', 'nada', 'nada') -- obviamente me refiro a um peixe
        end

        if valor1 == 'animaisdegrandeporte' then
            criarAnimaisdeGrandePorte() --garantia
        end
    end
end

function criarAnimaisdeGrandePorte()
    --cameraFlash('legenda', '0xff0000', 3, true)
    --triggerEvent("Add Camera Zoom", '0.25', '0.25', 'nada', 'nada')
    for i = 1,#animaisdegrandeporte do
        setProperty(animaisdegrandeporte[i]..'.visible', true)
        doTweenAlpha('tween'..animaisdegrandeporte[i], animaisdegrandeporte[i], 1, 3, 'linear')
    end
end
function onTweenCompleted(tag)
    if tag == "redOverlayout" then
        cameraFlash('achMenu', '0xff0000', 3, true)
        removeLuaSprite("redOverlay")
    end
    if tag == "bfIndoATO9" then
        updateCamPos('all')
    end
    if tag == 'sonicclashknux' then
        triggerEvent('Change Character','gf','Soul Knuckles')
        triggerEvent('Change Character','bf','Sonic Fear')
        triggerEvent('Change Character','dad','Soul Tails')
        triggerEvent('noteskinchangeBF','NOTE_assets','blood')
        triggerEvent('noteskinchangeOPPT','NOTE_assets','')
        triggerEvent('eventos-tripletrouble','400289222','nada')
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
        if flashing then
        cameraFlash('legenda', '0xffffff', 2, true)
        end
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
    if tag == "clashSonicKnucks" then
        prevBosBF = getCharacterX('bf')
        setProperty("boyfriend.x", prevBosBF-700)
        doTweenX('sonicclashknux', 'boyfriend', prevBosBF+510, 2.2, 'quartin') -- Quartin de doido k (na real a ideia é que ele chegue lá a milhão por hora)
    end
    if tag == 'followdepois' then
        
        setProperty("knuxerabos.x", getCharacterX('bf')+760)
        -- doTweenX('goknux', 'knuxerabos', getCharacterX('bf')+760, 0.25, 'quadInOut')
        triggerEvent('Camera Follow Pos',camPosBFX+20,camPosBFY+165)
        runTimer('clashSonicKnucks', 1)
    end
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
        playSound('exerisadinha', 0.8)
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

function fastChar(bf, dad)
    triggerEvent("Change Character", 'bf', bf, 'nada', 'nada')
    triggerEvent("Change Character", 'dad', dad, 'nada', 'nada')
end
