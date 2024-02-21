function onCreate()
    if legendas == true then
        precacheImage('letras/too-fest/Legenda');
        precacheSound("rapaiz")
        precacheSound("atumalaca")
        if downscroll == true then --Até poderia arrumar isso... Mas preguiça né?
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, -350)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            addAnimationByPrefix('fundo', 'Legenda Venom', 'Legenda Venom', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            setLuaSpriteCamera('fundo', 'legenda');
            addLuaSprite('fundo', false);
            setProperty('fundo.alpha', opacidadeLegendas);
            playAnim("fundo", "Legenda RGB")
        else
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, 0)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            addAnimationByPrefix('fundo', 'Legenda Venom', 'Legenda Venom', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            setLuaSpriteCamera('fundo', 'legenda');
            addLuaSprite('fundo', false);
            setProperty('fundo.alpha', opacidadeLegendas);
            playAnim("fundo", "Legenda RGB")
        end
    end
end

local pos = 0;
local wasVenom = false
local bot_antes = false
local deslocado = false


function onCreatePost()
    if downscroll then
        pos = -355
    end
end
function propriedadescomuns(var,name)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'legenda'); --legenda por cima das setas.
    --setGraphicSize(var, screenWidth) -- k
    setProperty(var..".alpha", opacidadeLegendas);
    if name == "sanic11" then
        playSound("rapaiz")
    elseif name == "sanic36" then
        playSound("atumalaca")
    elseif name =="sanic32" then
        wasVenom = true;
        setProperty(var..'.y', getProperty(var..'.y')+5)
        playAnim("fundo", "Legenda Venom")
    elseif wasVenom then
        playAnim("fundo", "Legenda RGB")
    elseif string.find(name, "sanic19") or string.find(name, "sanic20") or string.find(name, "sanic21") or string.find(name, "sanic22") or string.find(name, "sanic41") or string.find(name, "sanic42") then
        setGraphicSize(var, screenWidth, screenHeight)
        screenCenter(var, 'xy')
        setProperty("fundo.visible", false)
    elseif not getProperty("fundo.visible") then
        setProperty("fundo.visible", true)
        deslocamento(false, 1)
    end

    if string.find(name, "sanic19") then
        deslocamento(true, 1)
    end



    --screenCenter(var, 'xy')

    addLuaSprite(var)
end

function onVideoEnd()
    triggerEvent('Adicionar Imagens diferenciado',"","bf12")
    if not bot_antes then
        botPlay = false
    end
end

function deslocamento(inicio, Speed)
    if inicio and not downscroll then
        noteTweenY('NOTEMOVE1', 0, 130, Speed, "smootherstepinout")	
        noteTweenY('NOTEMOVE2', 1, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE3', 2, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE4', 3, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE5', 4, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE6', 5, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE7', 6, 130, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE8', 7, 130, Speed, "smootherstepinout")
        setProperty('botplayTxt.text', '')
        doTweenAlpha('AlphaTween1', 'healthBarBG', 0, 0.1)
        doTweenAlpha('AlphaTween2', 'healthBar', 0, 0.1)
        doTweenAlpha('AlphaTween3', 'scoreTxt', 0, 0.1)
        doTweenAlpha('AlphaTween4', 'iconP1', 0, 0.1)
        doTweenAlpha('AlphaTween5', 'iconP2', 0, 0.1)
        doTweenAlpha('AlphaTween6', 'timeBar', 0, 0.1)
        doTweenAlpha('AlphaTween7', 'timeBarBG', 0, 0.1)
        doTweenAlpha('AlphaTween8', 'timeTxt', 0, 0.1)
        doTweenAlpha('AlphaTween9', 'judgementCounter', 0, 0.1)
    
    
    elseif downscroll and inicio then
        noteTweenY('NOTEMOVE1', 0, 480, Speed, "smootherstepinout")	
        noteTweenY('NOTEMOVE2', 1, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE3', 2, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE4', 3, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE5', 4, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE6', 5, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE7', 6, 480, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE8', 7, 480, Speed, "smootherstepinout")
        setProperty('botplayTxt.text', '')
        doTweenAlpha('AlphaTween1', 'healthBarBG', 0, 0.1)
        doTweenAlpha('AlphaTween2', 'healthBar', 0, 0.1)
        doTweenAlpha('AlphaTween3', 'scoreTxt', 0, 0.1)
        doTweenAlpha('AlphaTween4', 'iconP1', 0, 0.1)
        doTweenAlpha('AlphaTween5', 'iconP2', 0, 0.1)
        doTweenAlpha('AlphaTween6', 'timeBar', 0, 0.1)
        doTweenAlpha('AlphaTween7', 'timeBarBG', 0, 0.1)
        doTweenAlpha('AlphaTween8', 'timeTxt', 0, 0.1)
        doTweenAlpha('AlphaTween9', 'judgementCounter', 0, 0.1)
    
    elseif not inicio and not downscroll  then
        noteTweenY('NOTEMOVE1', 0, 50, Speed, "smootherstepinout")	
        noteTweenY('NOTEMOVE2', 1, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE3', 2, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE4', 3, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE5', 4, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE6', 5, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE7', 6, 50, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE8', 7, 50, Speed, "smootherstepinout")
        setProperty('botplayTxt.text', 'BOTPLAY')
        doTweenAlpha('AlphaTween1', 'healthBarBG', 1, 0.1)
        doTweenAlpha('AlphaTween2', 'healthBar', 1, 0.1)
        doTweenAlpha('AlphaTween3', 'scoreTxt', 1, 0.1)
        doTweenAlpha('AlphaTween4', 'iconP1', 1, 0.1)
        doTweenAlpha('AlphaTween5', 'iconP2', 1, 0.1)
        doTweenAlpha('AlphaTween6', 'timeBar', 1, 0.1)
        doTweenAlpha('AlphaTween7', 'timeBarBG', 1, 0.1)
        doTweenAlpha('AlphaTween8', 'timeTxt', 1, 0.1)
        doTweenAlpha('AlphaTween9', 'judgementCounter', 1, 0.1)
        
    else
        noteTweenY('NOTEMOVE1', 0, 570, Speed, "smootherstepinout")	
        noteTweenY('NOTEMOVE2', 1, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE3', 2, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE4', 3, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE5', 4, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE6', 5, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE7', 6, 570, Speed, "smootherstepinout")
        noteTweenY('NOTEMOVE8', 7, 570, Speed, "smootherstepinout")
        setProperty('botplayTxt.text', 'BOTPLAY')
        doTweenAlpha('AlphaTween1', 'healthBarBG', 1, 0.1)
        doTweenAlpha('AlphaTween2', 'healthBar', 1, 0.1)
        doTweenAlpha('AlphaTween3', 'scoreTxt', 1, 0.1)
        doTweenAlpha('AlphaTween4', 'iconP1', 1, 0.1)
        doTweenAlpha('AlphaTween5', 'iconP2', 1, 0.1)
        doTweenAlpha('AlphaTween6', 'timeBar', 1, 0.1)
        doTweenAlpha('AlphaTween7', 'timeBarBG', 1, 0.1)
        doTweenAlpha('AlphaTween8', 'timeTxt', 1, 0.1)
        doTweenAlpha('AlphaTween9', 'judgementCounter', 1, 0.1)  
    end
end



function onEvent(name, value1, value2)
    if name=="video player" then
        setProperty('camHUD2.visible', false)
        bot_antes = botPlay
        botPlay= true
    end
    if name == 'Adicionar Imagens diferenciado' and legendas then
        if value1 ==  "" and value2 == "" then
            doTweenAlpha('fundoBye', 'fundo', 0, 1, 'linear')
            doTweenAlpha('legenda1Bye', 'exe', 0, 1, 'linear')
            return
        end
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1', value2)
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
            makeLuaSprite('exe', legendaPath..value1, 0, pos)
            propriedadescomuns('exe', value1)
        end
        if value1=="sanic1" then
            setProperty("exe.alpha", 0)
            doTweenAlpha('fundoOi', 'fundo', 1, 0.5, 'linear')
            doTweenAlpha('exeOi', 'exe', 1, 0.5, 'linear')
        end
    end
end