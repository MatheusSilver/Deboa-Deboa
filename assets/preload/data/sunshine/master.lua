	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

    --Modificações por el silvo omagadaioh pls send salve rapaziada ai de cima big fan here
    local darknotevisibility = false;
    
    --local usertimebar = ''
    
    function opponentNoteHit()
        if darknotevisibility == true then
            setPropertyFromGroup('strumLineNotes', 4, 'alpha', 0.5);
            setPropertyFromGroup('strumLineNotes', 5, 'alpha', 0.5);
            setPropertyFromGroup('strumLineNotes', 6, 'alpha', 0.5);
            setPropertyFromGroup('strumLineNotes', 7, 'alpha', 0.5);
        end
    end

    function onCreate()
        setCamMove(true) --Só pra garantir...
        addCharacterToList("bf_dream", 'bf')
        addCharacterToList("tailsdoll_dream", 'dad')
        addCharacterToList("bf", 'bf')
        addCharacterToList("tailsdoll-cartoon", 'dad')
    end

    function onCreatePost()
        if downscroll then
            pos = -350
        else
            pos = 0
        end
    end

    function onEvent(name, value1, value2)
        if name == "eventos_sunshine" then
            if value1== "580" then
                triggerEvent('Camera Follow Pos', '625', '475');
                setProperty('defaultCamZoom', 1.3);
                setCamMove(false)
                
            elseif value1=="588" then
                setGraphicSize("blackFuck", screenWidth, screenHeight)
                setProperty("blackFuck.visible", true)
                screenCenter("blackFuck", "XY")
                setProperty("blackFuck.alpha", 1)
                makeLuaVideoSprite("sunshine_video", 700, 500)
                addLuaSprite("sunshine_video")
                playVideoSprite("sunshine_video", "AnimacoesJogaveis/sunshine-rema")
                triggerEvent('Camera Follow Pos', '1150', '750');

            elseif value1== "590" then

                setProperty("blackFuck.visible", false)
                setProperty("blackFuck.alpha", 0)
                sunshine_shaders(true)
                
                triggerEvent('Change Character', 'dad', 'tailsdoll_dream');
                triggerEvent('Change Character', 'bf', 'bf_dream');
                setProperty('defaultCamZoom', 2.2);
                setProperty('stage.visible', false);
                setProperty('healthBar.visible', false);
                setProperty('healthBarBG.visible', false);
                setProperty('iconP1.visible', false);
                setProperty('iconP2.visible', false);
                setProperty('scoreTxt.visible', false);
        
                noteTweenX('left', 0, -2000, 0.01, 'linear');
                noteTweenX('down', 1, -2000, 0.01, 'linear');
                noteTweenX('up', 2, -2000, 0.01, 'linear');
                noteTweenX('right', 3, -2000, 0.01, 'linear');
        
                setPropertyFromGroup('strumLineNotes', 4, 'x', 412);
                setPropertyFromGroup('strumLineNotes', 5, 'x', 524);
                setPropertyFromGroup('strumLineNotes', 6, 'x', 636);
                setPropertyFromGroup('strumLineNotes', 7, 'x', 748);
                setPropertyFromGroup('strumLineNotes', 4, 'alpha', 0.5);
                setPropertyFromGroup('strumLineNotes', 5, 'alpha', 0.5);
                setPropertyFromGroup('strumLineNotes', 6, 'alpha', 0.5);
                setPropertyFromGroup('strumLineNotes', 7, 'alpha', 0.5);
        
                darknotevisibility = true;

                doTweenY('tween_bf_arriba', "boyfriend", getProperty("boyfriend.y")-50, 5, "cubeinout")
                doTweenY('tween_dad_abaja', "dad", getProperty("dad.y")+50, 5, "cubeinout")

            elseif value1== "855" then

                setProperty("blackFuck.visible", true)
                setProperty("blackFuck.alpha", 0)

                doTweenAlpha("blackFucktween", "blackFuck", 1, 1.5, "linear")
            elseif value1 == "860" then
                sunshine_shaders(false)
                setCamMove(true)
                removeLuaSprite("sunshine_video", true) -- Esse padrão é semi obrigatório.
                cancelTween("tween_dad_abaja")
                cancelTween("tween_dad_arriba")
                cancelTween("tween_bf_abaja")
                cancelTween("tween_bf_arriba")
                cancelTween("blackFucktween")
                setProperty("blackFuck.alpha", 0)
                setProperty("blackFuck.visible", false)
    
                triggerEvent('Change Character', 'dad', 'tailsdoll-cartoon');
                triggerEvent('Change Character', 'bf', 'bf');
    
                setProperty('defaultCamZoom', 0.86);
                
                setProperty('stage.alpha', 1);
                setProperty('stage.visible', true);
                setProperty('healthBar.visible', true);
                setProperty('healthBarBG.visible', true);
                setProperty('timeTxt.visible', true);
                setProperty('iconP1.visible', true);
                setProperty('iconP2.visible', true);
                setProperty('scoreTxt.visible', true);
        
                noteTweenX('left', 0, defaultOpponentStrumX0, 0.01, 'linear');
                noteTweenX('down', 1, defaultOpponentStrumX1, 0.01, 'linear');
                noteTweenX('up', 2, defaultOpponentStrumX2, 0.01, 'linear');
                noteTweenX('right', 3, defaultOpponentStrumX3, 0.01, 'linear');
        
                setPropertyFromGroup('strumLineNotes', 4, 'x', defaultPlayerStrumX0);
                setPropertyFromGroup('strumLineNotes', 5, 'x', defaultPlayerStrumX1);
                setPropertyFromGroup('strumLineNotes', 6, 'x', defaultPlayerStrumX2);
                setPropertyFromGroup('strumLineNotes', 7, 'x', defaultPlayerStrumX3);
                setPropertyFromGroup('strumLineNotes', 4, 'alpha', 1);
                setPropertyFromGroup('strumLineNotes', 5, 'alpha', 1);
                setPropertyFromGroup('strumLineNotes', 6, 'alpha', 1);
                setPropertyFromGroup('strumLineNotes', 7, 'alpha', 1);
        
                darknotevisibility = false;
            end
        end
        if name == 'Adicionar Imagens diferenciado' and legendas == true then
            if value2 == '' or value2 == 'null' or value2 == nil then
                removeLuaSprite('exe1', true);
            else
                makeLuaSprite('exe1', legendaPath..value2, 0, pos)
                propriedadescomuns('exe1')
            end
            if value1 == '' or value1 == 'null' or value1 == nil then
                removeLuaSprite('exe', true)
            else
            makeLuaSprite('exe', legendaPath..value1, 0, pos)
            propriedadescomuns('exe')
            end
        end
    end

    local pos = 0;

function propriedadescomuns(var)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'camhud'); -- O único motivo de eu usar o diferenciado é esse aqui
                                       -- Assim poupo de ter que colocar um shader a mais pra camLegenda.
    --setGraphicSize(var, screenWidth) -- k
    screenCenter(var, 'x')
    addLuaSprite(var, true);
end


    function onTweenCompleted(tag)
        if tag == "blackFucktween" then
            triggerEvent('Adicionar Imagens diferenciado', '', '');
        end
        if tag == 'tween_bf_arriba' then
            doTweenY('tween_bf_abaja', "boyfriend", getProperty("boyfriend.y")+50, 5, "cubeinout")
        elseif tag == "tween_bf_abaja" then
            doTweenY('tween_bf_arriba', "boyfriend", getProperty("boyfriend.y")-50, 5, "cubeinout")
        end
        if tag == 'tween_dad_abaja' then
            doTweenY('tween_dad_arriba', "dad", getProperty("dad.y")-50, 5, "cubeinout")
        elseif tag == "tween_dad_arriba" then
            doTweenY('tween_dad_abaja', "dad", getProperty("dad.y")+50, 5, "cubeinout")
        end   
    end
    
    function onFixedUpdate() 
        if darknotevisibility then
            if getPropertyFromGroup('strumLineNotes', 4, 'alpha') > 0 then
                setPropertyFromGroup('strumLineNotes', 4, 'alpha', getPropertyFromGroup('strumLineNotes', 4, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 5, 'alpha', getPropertyFromGroup('strumLineNotes', 5, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 6, 'alpha', getPropertyFromGroup('strumLineNotes', 6, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 7, 'alpha', getPropertyFromGroup('strumLineNotes', 7, 'alpha') - 0.02);
            end
        end
    end