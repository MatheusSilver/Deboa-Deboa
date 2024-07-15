function onCreate()
    precacheImage('conquistas/medalhas/achievements (btt-alt)');
    precacheImage('conquistas/keydSTARS/star-alt');
    precacheImage('bad_ending');
    precacheImage('good_ending');
    precacheImage('true_ending')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoom')
    precacheImage('pixelUI/NOTE-FURNACE_assetszoomENDS')
    precacheImage('pixelUI/NOTE-STARVI_assetszoom')
    precacheImage('pixelUI/NOTE-STARVI_assetszoomENDS')
    precacheImage('pixelUI/NOTE-supa_assetszoom')
    precacheImage('pixelUI/NOTE-supa_assetszoomENDS')
    precacheImage('NOTE_assets')
    precacheSound('AvisoSom')

    --setGameover('sonic', 'gameOverEndSonic', 'breakfast')
    setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/

end

local pos = 0;

function propriedadescomuns(var,name)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'other');
    setProperty(var..".alpha", opacidadeLegendas);
    setGraphicSize(var, screenWidth) -- k
    adjustPos(var, name)
    screenCenter(var, 'x')

    addLuaSprite(var, true);
end

function adjustPos(object, image)
    if string.find(image, "preycutscene") then
        setProperty(object..'.y', getProperty(object..'.y')+50)
    elseif not getProperty("canRegen") and downscroll then
        setProperty(object..'.y', getProperty(object..'.y')-550)
    elseif downscroll and curStep > 3425 and curStep < 4480 then
        setProperty(object..'.y', getProperty(object..'.y')-360)
    elseif downscroll then
        setProperty(object..'.y', getProperty(object..'.y')-410)
    elseif not downscroll then
        setProperty(object..'.y', getProperty(object..'.y')-90)
    end
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens diferenciadasso' and (legendas == true or string.find(value1, "preycutscene")) then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1', value2)
        end
        if value3 == '' or value3 == 'null' or value3 == nil then
            removeLuaSprite('exe2', true);
        else
            makeLuaSprite('exe2', legendaPath..value3, 0, pos)
            propriedadescomuns('exe2', value3)
        end
        if value4 == '' or value4 == 'null' or value4 == nil then
            removeLuaSprite('exe3', true);
        else
            makeLuaSprite('exe3', legendaPath..value4, 0, pos)
            propriedadescomuns('exe3', value4)
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
        makeLuaSprite('exe', legendaPath..value1, 0, pos)
        propriedadescomuns('exe', value1)
        end
    elseif name == 'Adicionar Imagens diferenciadasso' and legendas == false then
        if value1== "furnace1" or value1== "starved1" or value1 == "ssonic1" then
            removeLuaSprite('exe', true)
        end
    end
end
