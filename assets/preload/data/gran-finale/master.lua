local isMain = false
local zoomModifier = false
local mainTweenTime = 1 -- Por motivos de preguiça
local cameraMove = false
local camFollow = false
local prevInfo = 0
local zoomDAD = 0.37
local zoomBF = 0.5
local drainLife = false
local isDead= false
local limite = 0.1
local healthLoss = 0.0015

local ato1 = {'Ring', 'Text', 'Checkpoint', 'Rock', 'Sega', 'Eggman', 'S', 'O', 'N', 'I', 'C', 'Mountains', 'Lake', 'Band'}
local ato1Tweens = {'Checkpoint', 'Rock', 'Sega', 'Eggman', 'S', 'O', 'N', 'I', 'C'}
local maoboba = {'daHand', 'Band_perpective'}

function onCreate()
    --pushScriptData('intro');
    -- Substituido pelo vídeo

    initialSettings()
end

function onSongStart()
    triggerEvent('video player','AnimacoesJogaveis/finale_intro', '1', 'false')
end



function stage_manager(act, visible)
    if act == 'main' or act == 'all' then -- Esse 'all' foi feito espeficamente porque não sei a ordem das coisas ainda, mas provavelmente será usado na parte da agua, ou epilogo, essas partes ai.
        for i = 1,#ato1 do
            setProperty(ato1[i]..'.visible', visible)
        end
        setProperty('Background.visible', visible)
        if visible then
            runTimer('tweenUp', 0.1)
            isMain = true
            doTweenY('sonic_voano_cima', 'dad', getProperty('dad.y')-200, mainTweenTime, 'sineinout')
        else
            isMain = false
        end
    end
    if act == 'lateralRun' or act == 'all' then
        setProperty('BandFlat.visible', visible)
        setProperty('Background.visible', visible)
    end
    if act == 'face-to-face' or act == 'all' then
        setProperty('way2.visible', visible)
    end
    if act == 'maoboba' or act == 'all' then
        for i = 1,#maoboba do
            setProperty(maoboba[i]..'.visible', visible)
        end
    end
end

function onVideoEnd()
    if curBeat < 64 then
        camFollow = false
        cameraMove = true
        removeLuaSprite('introBG')
        stage_manager('all', false)
        --cameraFlash('legenda', '0xff0000', 1, true)
        setProperty('camHUD.visible', true)
        setProperty('camGame.visible', true)
        setProperty('defaultCamZoom', 0.85)
        setObjectOrder('circuloinicio',getObjectOrder('blackFuck') + 1)
        setObjectOrder('textoinicio',getObjectOrder('blackFuck') + 2)
        actIntro();
    end
end

function onEvent(name, value1, value2)
	if name == "trocar ato" then
        if value1 == 'herewego' then
            setProperty('camGame.visible', false)
            setProperty('camHUD.visible', false)
            setProperty('herewego.visible', true)
            playAnim('herewego', 'anim', true)
            fastChar('bfrun', 'xenofinal')
        end
        if value1 == 'herewego_end' then
            camFollow = cameraZoomOnBeat
            setProperty('camGame.visible', true)
            setProperty('camHUD.visible', true)
            setProperty('herewego.visible', false)
            lifeStuffVisibility(true)
            setProperty('health', 2) --Só pra garantir que o player sempre comece na distância máxima do sonico
            stage_manager('main', true)
            switchDrain(true)
            setProperty('defaultCamZoom', 0.5)
            setProperty('global_shader.visible', true)
            if flashing then
            cameraFlash('legenda', '0xffffff', 0.5, true)
            end
            zoomModifier = true
            zoomDAD = 0.37
            zoomBF = 0.5
        end
        if value1 == 'face-to-face' then
            setProperty('global_shader.visible', true)
            if flashing then
            cameraFlash('legenda', '0xffffff', 0.5, true)
            end
            stage_manager('main', false)
            stage_manager('face-to-face', true)
            fastChar('bf_ftf', 'xeno-ftf')
            zoomModifier = true
            zoomBF = 0.65
            zoomDAD = 0.6
        end
        if value1 == 'face-to-face_init_end' then
            triggerEvent('TelaPreta','true')
            runTimer('callEnd-ftf', 1.7)
        end
        if value1 == 'face-to-face-end' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 0.5, true)
            end
            fastChar('bfrun', 'xenofinal')
            stage_manager('main', true)
            stage_manager('face-to-face', false)
            setProperty('defaultCamZoom', 0.5)
            setProperty('global_shader.visible', false)
            zoomModifier = true
            zoomBF = 0.5
            zoomDAD = 0.37
        end
        if value1 == 'sudden_black_off' then
            setProperty('blackFuck.alpha', 0)
            --characterPlayAnim('bf', 'trans', true)
            if flashing then
            cameraFlash('legenda', '0xffffff', 0.6, true)
            end
            prevInfo = getPropertySpecial('boyfriend.x')
            setProperty('boyfriend.x', prevInfo - 100)
            doTweenX('boyfriendtween', 'boyfriend', prevInfo, 0.5, 'smoothstepinout')
            
        end
        if value1 == 'sudden_iamgod' then
            setProperty('iamgod.visible', true)
        end
        if value1 == 'iamgod_fade' then
            doTweenAlpha('iamgodfade', 'iamgod', 0, 1.5, 'linear')
            if flashing then
            cameraFlash('camHUD', '0xff0000', 1.5, true)
            end
        end
        if value1 == 'maoboba' then
            camFollow = false
            fastChar('bfrunHand', 'invisibru')
            if flashing then
            cameraFlash('legenda', '0xff0000', 0.5, true)
            end
            stage_manager('main', true)
            setProperty('Band.visible', false)
            stage_manager('maoboba', true) -- Isso também deverá iniciar el movimento junto.
            doTweenX('daHandX', 'daHand', getProperty('daHand.x')+1607, 21, 'linear')
            doTweenY('daHandY', 'daHand', getProperty('daHand.y')+581, 21, 'linear')
            zoomModifier = false
        end
        if value1== 'yuwontgetaway_start' then
            setProperty('camGame.visible', false)
            setProperty('camHUD.visible', false)
            setProperty('herewego.visible', true)
            playAnim('herewego', 'justXeno', true)
        end
        if value1=='yuwont_end' then
            if flashing then
            cameraFlash('camhud', '0xff0000', 0.5, true)
            end
            setProperty('camGame.visible', true)
            setProperty('camHUD.visible', true)
            removeLuaSprite('herewego')
        end
        if value1 == 'maoboba_end' then
            triggerEvent('TelaPreta','true')
            runTimer('callEnd_maoboba', 0.55)
        end
        if value1 == 'red appear' then
            setProperty('redTrans.visible', true)
            doTweenAlpha('redTween', 'redTrans', 0.6, 3, 'cubeinout')
        end
        if value1 == 'lateralRun' then
            --setProperty('global_shader.visible', true)
            stage_manager('all', false)
            stage_manager('lateralRun', true)
            lifeStuffVisibility(false)
            setProperty("camHUD.visible", false)
        end
        if value1 == 'grab_start' then -- mudanças artísticas...
        --[[
            setProperty('bfrunlegsbobo.visible', false)
            setProperty('boyfriend.visible', false)
            setProperty('grabbf.x', getProperty('boyfriend.x')-100)
            setProperty('grabbf.y', getProperty('boyfriend.y') - 100)
            setProperty('grabbf.visible', true)
            doTweenX('grabgofront', 'grabbf', getProperty('grabbf.x')+300, 0.5, 'smoothstepin')
            playAnim('grabbf','anim', true)]]
        end
        if value1 == 'floor_down' then
            doTweenY('chaoscaem', 'BandFlat', getProperty('BandFlat.y')-1800, 1.5, 'cubeinout')
            doTweenY('bftweencaem', 'boyfriend', getProperty('BandFlat.y')-1800, 2, 'cubeinout')
            doTweenY('bftweenpernascaem', 'bfrunlegsbobo', getProperty('BandFlat.y')-1800+235, 2, 'cubeinout')
            setProperty('bffall.visible', true)
            doTweenY('bffallcaindo', 'bffall', -400, 1.5, 'smoothstepin')
            --setProperty('bffall.alpha', 0)
            --doTweenAlpha('bffallnicial', 'bffall', 1, 0.5, 'linear')
        end
        if tag == 'drown_anim' then 
            playAnim('bffall', 'anim', true) 
            setProperty('camGame.visible', false)
            setProperty('camHUD.visible', false)
            setProperty('global_shader.visible', false)
            stage_manager('all', false)
            --removeLuaSprite('grabbf')
        end
        if value1 == 'drown_anim_end' then
            camFollow = cameraZoomOnBeat
            setProperty('blackFuck.alpha', 0)
            setProperty('blackFuck.visible', true)
            doTweenAlpha('blackTween1', 'blackFuck', 1, 0.5, 'cubeinout')
            doTweenAlpha('bffalltween', 'bffall', 0, 1, 'linear')
            zoomModifier = false
            setProperty("camHUD.visible", true)
            lifeStuffVisibility(true)
            switchDrain(true)
            setProperty('canRegen', false)
            healthLoss = 0.0005            
            limite = 0.1
        end
        if value1 == 'pregiga' then
            --setProperty('daHandDrowning.x', getPropertySpecial('boyfriend.x'))
            --setProperty('daHandDrowning.y', getPropertySpecial('boyfriend.y'))
            setProperty('daHandDrowning.visible', true)
            doTweenAlpha('daHandDrowningtweening', 'daHandDrowning', 0.4, 1, 'linear')
            playAnim('daHandDrowning', 'anim', true)
        end
        if value1 == 'gigasonic_trans' then
            switchDrain(false)
            setProperty('canRegen', true)
            cancelTween('daHandDrowningtweening') -- Só pra garantir...
            removeLuaSprite('daHandDrowning', true)
            camFollow = false
            fastChar('beef', 'xenoholding')
            removeLuaSprite('redTrans', true)
            if flashing then
            cameraFlash('legenda', '0xff0000', 0.5, true)
            end
            pushScriptData('gigasonic_moment') -- É apenas um controlador, então não tem problema puxar ele tardiamente.
            zoomModifier = true
            zoomBF = 0.5
            zoomDAD = 0.37
        end
        if value1 == 'emerald_appear' then
            -- code pro aparecimento de esmeraldas na hora do circus
            --Tem 6 segundos pra poder trabalhar nisso.
        end
        if value1 == 'bfgetsthemic' then
            setProperty('camHUD.visible', false)
            setProperty('camGame.visible', false)
            setProperty('bfgetsmic.visible', true)
            playAnim('bfgetsmic', 'anim', true)
            zoomModifier = true
            camFollow = cameraZoomOnBeat
            zoomBF = 0.4
            zoomDAD = 0.37
        end
        if value1 == 'removebfmic' then
            if flashing then
            cameraFlash('legenda', '0xffffff', 0.5, true)
            end
            setProperty('camHUD.visible', true)
            setProperty('camGame.visible', true)
            removeLuaSprite('bfgetsmic')
        end
        if value1 == 'appearStatic' then
            objectPlayAnimation('static','dance',true)
	        setProperty('static.visible', true)
            if flashing then
            cameraFlash('legenda', '0xff0000', 0.5, true)
            end
        end
        if value1 == 'GranFinale' then
            zoomModifier = true
            if flashing then
            cameraFlash('legenda', '0xff0000', 1, true)
            end
            setProperty('static.visible', false)
            stage_manager('main', true)
            setProperty('Background.visible', false)
            setProperty('Band.visible', false)
            fastChar('sbf2', 'xenofinal')
        end
        if value1 == 'GranFinale-ato2' then
            stage_manager('all', false)
            if flashing then
            cameraFlash('legenda', '0xff0000', 1, true)
            end
            setProperty('static.visible', true)
        end
        if value1 =='GranFinale-ato3' then -- cara a cara
            zoomModifier=false
            camFollow = false
        end
        if value1 =='GranFinale-ato3bf' then -- cara a cara
            zoomModifier=false
        end
        if value1== 'videoend' then
            triggerEvent('video player','AnimacoesJogaveis/GranFinale_end', '1', 'false', 'true')
        end
        if value1== 'cleanstage' then
            setProperty('camHUD.visible', false)
            setProperty('camGame.visible', false)
        end
        if value1 == 'callCircus' then -- Só porque o negócio estava extremamente bugado quando colocado dentro de Gigasonic_moment
            pushScriptData('circus')
            doTweenAngle('fromnegative', 'camHUD', -5, stepCrochet*0.01, 'sineinout') --No fim... acabei usando algo muito parecido logo em seguida k
            doTweenAngle('tt', 'camGame', -5, stepCrochet*0.01, 'sineinout')
        end
    end
end

function onTimerCompleted(tag)
    if tag == 'HpDecay' then
        setProperty('health',getProperty('health') - healthLoss)
        end
    if tag == 'introEnd' then
        doTweenAlpha('blackFuckalpha', 'blackFuck', 0, 1, 'linear')
        doTweenAlpha('startCirclealpha', 'circuloinicio', 0, 1, 'linear')
        doTweenAlpha('startTextalpha', 'textoinicio', 0, 1, 'linear')
    end
    if tag == 'callEnd-ftf' then
        triggerEvent('TelaPreta','false', '')
        triggerEvent('trocar ato','face-to-face-end', '')
    end
    if tag == 'callEnd_maoboba' then
        if flashing then
        cameraFlash('legenda', '0xffffff', 1, true)
        end
        fastChar('bfrunbobo', 'invisibru')
        triggerEvent('trocar ato','lateralRun', '')
        switchDrain(false)
        cancelTimer('HpDecay')
        setProperty('global_shader.visible', false)
        --triggerEvent('Play Animation','parry', 'bf')

        -- Agora via eventos
    end
    if tag == 'startFinalTween' then
        fastChar('bf_drowning', 'invisibru')
        doTweenAlpha('finalTweenArt', 'drowningArt0', 0, 1.5, 'linear')
        doTweenAlpha('finalTweenBlack', 'blackFuck', 0, 0.5, 'cubeinout')
    end

    if tag == 'tweenDown' then
        tweenStuff(false)
    end
    if tag == 'tweenUp' then
        tweenStuff(true)
    end
end

function onTweenCompleted(tag) --a

    if tag == 'startTextalpha' then
        removeLuaSprite('textoinicio', true)
    end
    if tag == 'startCirclealpha' then
        removeLuaSprite('circuloinicio', true)
        setProperty('blackFuck.visible', false)
    end
    if tag == 'iamgodfade' then
        removeLuaSprite('iamgod', true)
    end
	if tag == 'sonic_voano_cima' and isMain then
		doTweenY('sonic_voano_baixo', 'dad', getProperty('dad.y')+100, mainTweenTime, 'sineinout')
	end
    if tag == 'sonic_voano_baixo' and isMain then 
		doTweenY('sonic_voano_cima', 'dad', getProperty('dad.y')-100, mainTweenTime, 'sineinout')
	end
    if tag == 'bffalltween' then
        removeLuaSprite('bffall', true)
    end
    if tag == 'blackTween1' then
        addLuaSprite('drowningArt0', true)
        setObjectOrder('drowningArt0', getObjectOrder('blackFuck')+1)
        doTweenAlpha('artTween', 'drowningArt0', 0.5, 1.0, 'linear')
    end
    if tag == 'artTween' then
        setProperty('camGame.alpha', 0)
        setProperty('camHUD.alpha', 0)
        setProperty('camGame.visible', true)
        setProperty('camHUD.visible', true)
        runTimer('startFinalTween', 1)
    end
    if tag == 'finalTweenArt' then
        removeLuaSprite('drowningArt0')
    end
    if tag == 'finalTweenBlack' then
        setProperty('boyfriend.visible', true)
        setProperty("Background.visible", false)
        doTweenAlpha('hudtween', 'camHUD', 1, 1, 'cubeinout')
        doTweenAlpha('gameTween', 'camGame', 1, 1, 'cubeinout')
        pushScriptData('drowningMoment') -- É apenas um controlador, então não tem problema puxar ele tardiamente.
    end
    if tag == 'chaoscaem' then
        removeLuaSprite('BandFlat', true)
    end
end

function tweenStuff(goUp) -- O Sonic segue uma lógica diferente.
    if not isMain then
        for i = 1,#ato1Tweens do
            cancelTween(ato1[i]..'tween')
        end
        return
    end
    if goUp then
        for i = 1,#ato1Tweens do
            doTweenY(ato1Tweens[i]..'tween', ato1Tweens[i], getProperty(ato1Tweens[i]..'.y') - 100, mainTweenTime, 'sineinout') 
        end
        runTimer('tweenDown', mainTweenTime)
    else
        for i = 1,#ato1Tweens do
            doTweenY(ato1Tweens[i]..'tween', ato1Tweens[i], getProperty(ato1Tweens[i]..'.y') + 100, mainTweenTime, 'sineinout')
        end
        runTimer('tweenUp', mainTweenTime)
    end
end

function lifeStuffVisibility(visible)
    setProperty('healthBarBG.visible', visible)
    --setProperty('healthBar.visible', visible)
    setProperty('HPbar.visible', visible)
    setProperty('oppIcon.visible', visible)
    setProperty('bfIcon.visible', visible)
    setProperty('scoreTxt.visible', visible)
end

function switchDrain(shouldDrain)
    drainLife = shouldDrain
    if not shouldDrain then
        cancelTimer('HpDecay')
    end
end

function initialSettings()
    switchDrain(false)
    isDead= false
    setProperty('healthBar.visible', false)
    setProperty('iconP1.visible', false) --Agora estamos usando o que está contido dentro do próprio lua.
    setProperty('iconP2.visible', false)
    setProperty('camHUD.visible', false)
    setProperty('camGame.visible', false)
    --setProperty('defaultCamZoom', 1.2)
    setObjectOrder('healthBar', getObjectOrder('timeBar') -6)
    setObjectOrder('healthBarBG', getObjectOrder('timeBar') -5)
    setCamMove(false);
    cameraMove = false
    setProperty('healthBarBG.xAdd', -30)
    setProperty('healthBarBG.yAdd', -20)

    lifeStuffVisibility(false)
end

function fastChar(bf, dad)
    triggerEvent("Change Character", 'bf', bf, 'nada', 'nada')
    triggerEvent("Change Character", 'dad', dad, 'nada', 'nada')
end


-- Cam Follow Stuff
-- Movi isso do outro lua porque por algum motivo o getCamMove não tá funfando lá

local ofs = 40;


-- Sim... Esse é o camFollowGlobal mas com uma pequena sutileza, agora ele atualiza o tempo todo
-- Movimento de camera mais liso, sabe como é né?
-- O bixo fica voando pra cima e pra baixo o tempo todo té doido...

function onUpdate(elapsed)
    -- updateCamPos('all') -- Provavelmente isso deixaria essa parte um cadin lagada de mais.
    -- Provavelmente teremos que fazer uma modificação nesse script para o player com efeitos de camera desligados.
    if getProperty('health') < 0.25 then
        objectPlayIndexedAnimation('bfIcon', 1)
    elseif getProperty('health') > 1.8 then
        objectPlayIndexedAnimation('oppIcon', 1)
    else
        objectPlayIndexedAnimation('oppIcon', 0)
        objectPlayIndexedAnimation('bfIcon', 0)
    end

    if drainLife and not isDead and getProperty('health') > limite then
        runTimer('HpDecay', 0.015, 0)
    elseif getProperty('health') <= limite then
        cancelTimer('HpDecay')
    end
    setProperty('HPbar.width', (getProperty('health') / 2) )
    setProperty('HPbar.scale.x', (getProperty('health') / 2) )

    updateHitbox('HPbar')

    if getProperty('health') < 1.98 then
        setProperty('bfIcon.x', getProperty('HPbar.width') + 215 )
    end
    
    if cameraMove then
        if not mustHitSection then
            if zoomModifier then
                setProperty('defaultCamZoom', zoomDAD)
            end
            updateCamPos('dad')
            if camFollow then
                if getPropertySpecial('dad.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos',camPosDadX-ofs,camPosDadY)
                end
                if getPropertySpecial('dad.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos',camPosDadX+ofs,camPosDadY)
                end
                if getPropertySpecial('dad.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY-ofs)
                end
                if getPropertySpecial('dad.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY+ofs)
                end
            end
            if getPropertySpecial('dad.animation.curAnim.name') == 'idle' or not camFollow then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
            end
        else
            if zoomModifier then
                setProperty('defaultCamZoom', zoomBF)
            end
            if camFollow then
            --updateCamPos('bf') -- Tenho minhas duvidas se o bf real vai precisar disso... Mas acho que não
                if getPropertySpecial('boyfriend.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos',camPosBFX-ofs,camPosBFY)
                end
                if getPropertySpecial('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos',camPosBFX+ofs,camPosBFY)
                end
                if getPropertySpecial('boyfriend.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY-ofs)
                end
                if getPropertySpecial('boyfriend.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY+ofs)
                end
            end

	        if getPropertySpecial('boyfriend.animation.curAnim.name') == 'idle' or not camFollow then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
            end 
        end
    end
end

function onGameOver()
    isDead= true
end

function actIntro()
    setProperty('blackFuck.visible', true)
    setProperty('blackFuck.alpha', 1)

    doTweenX('circuloiniciotween', 'circuloinicio', 0, 0.5, 'linear')
    doTweenX('textoiniciotween', 'textoinicio', 0, 0.5, 'linear')

    runTimer('introEnd', 1.9)
end