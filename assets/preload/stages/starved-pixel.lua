local speedChanger = 1
local speedModifier = -60

local std_x_furnace_end = 0
local std_y_furnace_end = 0

local floor_running = "piso_parte1"
local bg_running = "bg_normal"

local should_run=false
local desvioPrey=false

function onCreate()

    pushScriptData('vgs');
    pushScriptData('Adicionar Imagens diferenciado');
    --Configurando o final.
    makeLuaSprite("theendbg", "cenarios/starved/Prey End", -400,-150)
    scaleObject("theendbg",1.3,1.3)
    setProperty("theendbg.visible", false)
    addLuaSprite("theendbg")

    makeAnimatedLuaSprite("furnaceTheEnd", 'cenarios/starved/Furnace', 50, 2500)
    addAnimationByPrefix("furnaceTheEnd", "idle", "Furnace Idle", 24, true)
    scaleObject("furnaceTheEnd",2,2)
    setProperty("furnaceTheEnd.visible", true)
    addLuaSprite("furnaceTheEnd", true)

    --Configurando os bgs - corrida.
    makeLuaTiledSprite("bg_normal", 'cenarios/starved/stardustBg2', 4608, 2832, true, false)
    setScrollFactor("bg_normal", 0.4, 0.4)
    setPropertyTiledLuaSprite("bg_normal.visible", false)
    screenCenter("bg_normal")
    setPropertyTiledLuaSprite("bg_normal.y", getPropertyTiledLuaSprite("bg_normal.y")+50)
    addLuaSprite("bg_normal")


    makeLuaTiledSprite("bg_good_ending", 'cenarios/starved/stardustBg', 4608, 2832, true, false)
    setScrollFactor("bg_good_ending", 0.4, 0.4)
    setPropertyTiledLuaSprite("bg_good_ending.visible", false)
    screenCenter("bg_good_ending")
    addLuaSprite("bg_good_ending")

    --done

    --Configurando os pisos - Corrida
    makeLuaTiledSprite("piso_parte1", 'cenarios/starved/stardustFloor1', 4608, 2832, true, false)
    setPropertyTiledLuaSprite("piso_parte1.visible", false)
    screenCenter("piso_parte1")
    setPropertyTiledLuaSprite("piso_parte1.x", getPropertyTiledLuaSprite("bg_normal.x"))
    setPropertyTiledLuaSprite("piso_parte1.y", getPropertyTiledLuaSprite("bg_normal.y")+1700)
    addLuaSprite("piso_parte1", true)

    makeLuaTiledSprite("piso_parte2", 'cenarios/starved/stardustFloor2', 4608, 2832, true, false)
    setPropertyTiledLuaSprite("piso_parte2.visible", false)
    screenCenter("piso_parte2")
    setPropertyTiledLuaSprite("piso_parte2.x", getPropertyTiledLuaSprite("bg_normal.x"))
    setPropertyTiledLuaSprite("piso_parte2.y", getPropertyTiledLuaSprite("bg_normal.y")-455)
    addLuaSprite("piso_parte2", true)

    makeLuaTiledSprite("piso_parte3", 'cenarios/starved/stardustFloor3', 4608, 2832, true, false)
    setPropertyTiledLuaSprite("piso_parte3.visible", false)
    screenCenter("piso_parte3")
    setPropertyTiledLuaSprite("piso_parte3.x", getPropertyTiledLuaSprite("bg_normal.x"))
    setPropertyTiledLuaSprite("piso_parte3.y", getPropertyTiledLuaSprite("bg_normal.y")-455)
    addLuaSprite("piso_parte3", true)

    makeLuaTiledSprite("piso_parte4", 'cenarios/starved/stardustFloor4', 4608, 2832, true, false)
    setPropertyTiledLuaSprite("piso_parte4.visible", false)
    screenCenter("piso_parte4")
    setPropertyTiledLuaSprite("piso_parte4.x", getPropertyTiledLuaSprite("bg_normal.x"))
    setPropertyTiledLuaSprite("piso_parte4.y", getPropertyTiledLuaSprite("bg_normal.y")+1700)
    addLuaSprite("piso_parte4", true)


    --done mas provavelmente vai ter que arrumar offsets depois.

    --Adicionais
    makeAnimatedLuaSprite("stardustFurnace", "characters/prey/Furnace_sheet", -1000, 900)
    addAnimationByPrefix("stardustFurnace", "idle", "Furnace idle", 24, true)
    scaleObject("stardustFurnace", 6, 6)
    setProperty("stardustFurnace.antialiasing", false)
    setProperty("stardustFurnace.visible", false)
    addLuaSprite("stardustFurnace")

    makeAnimatedLuaSprite("warning", "slash_warning_sheet", 0, 0)
    addAnimationByPrefix("warning", "warn", "slash warning", 24, false)
    setGraphicSize("warning", getProperty("warning.width")*2.5)
    setProperty("warning.visible", false)
    screenCenter("warning")
    setObjectCamera("warning", "hud")
    addLuaSprite("warning")

    makeLuaSprite("gotcha", 'furnace_gotcha', 0, 0)
    setGraphicSize("gotcha", getProperty("gotcha.width")*5)
    setProperty("gotcha.antialiasing", false)
    setProperty("gotcha.visible", false)
    setProperty("gotcha.flipX", false)
    addLuaSprite("gotcha")
end

function onCreatePost()
    setProperty("desviou", false)
end

function onEvent(name, value1, value2)
	if name == "eventos-prey" then
		value1=tonumber(value1)
        switch(value1, { --Obviamente eu poderia fazer um else if aqui, mas não quero o x02 com dois quilos de faca no meu pescoço
            [1] = function()
                should_run=true
            end,
            [128] = function()
                changeFloor(1)
                setPropertyTiledLuaSprite("bg_normal.visible", true)
            end,
            [511] = function()
                changeFloor(2)
            end,
            [1280] = function()
                changeFloor(3)
            end,
            [1780] = function()
                speedModifier=-90
                changeFloor(1)
            end,
            [2400] = function()
                playSound("AvisoSom", 0.6, "sonicAviso")
                setProperty("warning.visible", true)
                objectPlayAnimation("warning", "warn", true)
                desvioPrey=true
            end,
            [2432] = function()
                setProperty("stardustFurnace.visible", true)
                objectPlayAnimation('stardustFurnace', 'idle', true)
                doTweenX("furnaceGOL", "stardustFurnace", 2600, 10, 'linear')
            end,
            [3364] = function()
                setProperty("gotcha.x", getProperty("boyfriend.x")+1000, getProperty("boyfriend.y"))
                doTweenX("gotchaTween", "gotcha", getProperty("boyfriend.x")+100, 0.1, "expoinout")
            end,
            [3400] = function()
                changeFloor(4)
                bg_running = "bg_good_ending"
                removeLuaSprite("bg_normal.visible", false)
                setPropertyTiledLuaSprite("bg_good_ending.visible", true)

            end,
            [3425] = function()
                speedModifier=-120
            end,
            [1010101] = function()
                if (gore) then
                    doTweenY("furnaceEndTweenY", 'furnaceTheEnd', -160, 1.5, "cubeinout")
                    doTweenX("furnaceEndTweenX", 'furnaceTheEnd', getProperty("furnaceTheEnd.x")+45, 1.5, "cubeinout")
                else
                    doTweenY("furnaceEndTweenY", 'furnaceTheEnd', -350, 1.5, "cubeinout")
                end
            end,
            [4498] = function()
                should_run=false
                changeFloor(0)
                removeLuaSprite("bg_normal", true)
                removeLuaSprite("bg_good_ending", true)
                setProperty("theendbg.visible", true)
                setProperty("furnaceTheEnd.visible", true)
                objectPlayAnimation('"furnaceTheEnd', 'idle', true)
            end
        })
    end
end

function onTweenCompleted(tag)
    if tag == "furnaceEndTweenY" then
        std_x_furnace_end = getProperty("furnaceTheEnd.x")
        std_y_furnace_end = getProperty("furnaceTheEnd.y")
        doTweenX("furnace_tween_x", "furnaceTheEnd", std_x_furnace_end + math.random(-30, 30), math.random(1, 3), "smootherstepinout")
        doTweenY("furnace_tween_y", "furnaceTheEnd", std_y_furnace_end + math.random(-30, 30), math.random(1, 3), "smootherstepinout")
    end
    if tag == "furnace_tween_x" then
        doTweenX("furnace_tween_x", "furnaceTheEnd", std_x_furnace_end + math.random(-30, 30), math.random(1, 3), "smootherstepinout")
    end
    if tag == "furnace_tween_y" then
        doTweenY("furnace_tween_y", "furnaceTheEnd", std_y_furnace_end + math.random(-30, 30), math.random(1, 3), "smootherstepinout")
    end
    if tag == "furnaceGOL" then
        setProperty("stardustFurnace.visible", false)
        removeLuaSprite("stardustFurnace", true)
        if getProperty("desviou") then
            triggerEvent('Change Character', 'bf', 'bf-Sonic-Peelout');
        end
    end
    if tag == "gotchaTween" then
        cameraFlash("hud2", "0xFFFF0000", 2 , true)
        removeLuaSprite("gotcha") 
    end
end

function onSoundFinished(tag)
    if tag=="sonicAviso" then
        desvioPrey=false
        setProperty("warning.visible", false)
        removeLuaSprite("warning", true)
    end
end

function changeFloor(new_floor)
    for i = 1,4 do
        if new_floor==0 then
            removeLuaSprite("piso_parte"..tostring(i),true)
        else
            if i == new_floor then
                setPropertyTiledLuaSprite("piso_parte"..tostring(i)..".visible", true)
                floor_running="piso_parte"..tostring(i)
            elseif new_floor == 4 then
                removeLuaSprite("piso_parte"..tostring(i),true)
            else
                setPropertyTiledLuaSprite("piso_parte"..tostring(i)..".visible", false)
            end
        end
    end
end

_G.switch = function(param, case_table)
    local case = case_table[param]
    if case then return case() end
    local def = case_table['default']
    return def and def() or nil
end

function onUpdate(elapsed)
    if desvioPrey and keyJustPressed("space") then
        setProperty("desviou", true) -- O "desviou", não pode vir pro lua por causa do achievement.
        desvioPrey=false
        setProperty("warning.visible", false)
    end
    if should_run then
        speedChanger = speedChanger + 1
        setPropertyTiledLuaSprite(bg_running..".scrollX", speedChanger*speedModifier*0.4)
        setPropertyTiledLuaSprite(floor_running..".scrollX", speedChanger*speedModifier)
    end
end