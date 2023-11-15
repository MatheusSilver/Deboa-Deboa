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
    end

    function onEvent(name, value1, value2)
        if name == "eventos_sunshine" then
            if value1== "580" then
                triggerEvent('Camera Follow Pos', '625', '475');
                setProperty('defaultCamZoom', 1.3);
                setCamMove(false)
                
            elseif value1=="588" then

                setProperty("blackFuck.visible", true)
                setProperty("blackFuck.alpha", 1)
                triggerEvent('Camera Follow Pos', '1150', '750');

            elseif value1== "590" then

                setProperty("blackFuck.visible", false)
                setProperty("blackFuck.alpha", 0)
                
                triggerEvent('Change Character', 'dad', 'tailsdoll_dream');
                triggerEvent('Change Character', 'bf', 'bf_dream');
                triggerEvent('video player super legal demais', 'AnimacoesJogaveis/sunshine', '835', '500', '1.5');
                setObjectOrder("videoSpr", getObjectOrder("stage"))
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
                setCamMove(true)
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
                setProperty("videoSpr.visible", false)
                --IMPORTANTE: TEM QUE EDITAR O VÍDEO PRA DEIXAR ELE NO TAMANHO CERTO
                --Esse videoSpr.visible não deveria existir...
                
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
    end

    function onTweenCompleted(tag)
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
    
    function onUpdate() 
        if darknotevisibility then
            if getPropertyFromGroup('strumLineNotes', 4, 'alpha') > 0 then
                setPropertyFromGroup('strumLineNotes', 4, 'alpha', getPropertyFromGroup('strumLineNotes', 4, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 5, 'alpha', getPropertyFromGroup('strumLineNotes', 5, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 6, 'alpha', getPropertyFromGroup('strumLineNotes', 6, 'alpha') - 0.02);
                setPropertyFromGroup('strumLineNotes', 7, 'alpha', getPropertyFromGroup('strumLineNotes', 7, 'alpha') - 0.02);
            end
        end
    end