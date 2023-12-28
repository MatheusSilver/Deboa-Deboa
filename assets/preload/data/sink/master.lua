local pos = 0;

function propriedadescomuns(var)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'camlegenda');
    --setGraphicSize(var, screenWidth) -- k
    screenCenter(var, 'x')
end

function onCreatePost()
    if downscroll then
        pos = -370
    else
        pos = -70
    end
end

function onTweenCompleted(tag)
    if tag == "cuidado_out" then
        removeLuaSprite("sonic_cuidado")
    end
end


function onEvent(name, value1, value2, value3, value4)
    if name == "cuidado_event" then
        if value1 == "intro" then
            setProperty("sonic_cuidado.visible", true)
            doTweenAlpha("cuidado_intro", "sonic_cuidado", 1, 0.5, "smoothstepin")
        elseif value1 == "out" then
            doTweenAlpha("cuidado_out", "sonic_cuidado", 0, 0.5, "smoothstepout")
        end

    end
    if name == 'Adicionar Imagens diferenciado' then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2..idioma, 0, pos)
            propriedadescomuns('exe1')
            addLuaSprite('exe1', true);
            --traceLog("value 2 invocou, "..value2.." em: "..getSongPosition())
        end
        if value4 == '' or value4 == 'null' or value4 == nil then
            removeLuaSprite('exe3', true);
        else
            makeLuaSprite('exe3', legendaPath..value4..idioma, 0, pos)
            propriedadescomuns('exe3')
            addLuaSprite('exe3', true);
            --traceLog("value 4 invocou, "..value4.." em: "..getSongPosition())
        end
        if value3 == '' or value3 == 'null' or value3 == nil then
            removeLuaSprite('exe2', true);
        else
            makeLuaSprite('exe2', legendaPath..value3..idioma, 0, pos)
            propriedadescomuns('exe2')
            addLuaSprite('exe2', true);
            --traceLog("value 3 invocou, "..value3.." em: "..getSongPosition())
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
        makeLuaSprite('exe', legendaPath..value1..idioma, 0, pos)
        propriedadescomuns('exe')
        addLuaSprite('exe', true);
        --traceLog("value 1 invocou, "..value1.." em: "..getSongPosition())
        end
    end
end

function onCreate()
    makeLuaSprite("sonic_cuidado", "AlexisTransition", 0, 0)
    screenCenter("sonic_cuidado", "xy")
    setProperty("sonic_cuidado.alpha", 0)
    setProperty("sonic_cuidado.visible", false)
    setLuaSpriteCamera("sonic_cuidado", 'hud2');
    addLuaSprite("sonic_cuidado")
end