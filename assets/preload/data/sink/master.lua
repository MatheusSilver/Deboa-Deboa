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
end

function onCreate()
    makeLuaSprite("sonic_cuidado", "AlexisTransition", 0, 0)
    screenCenter("sonic_cuidado", "xy")
    setProperty("sonic_cuidado.alpha", 0)
    setProperty("sonic_cuidado.visible", false)
    setLuaSpriteCamera("sonic_cuidado", 'hud2');
    addLuaSprite("sonic_cuidado")
end