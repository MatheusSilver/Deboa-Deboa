local pos = 0;

function propriedadescomuns(var)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'camlegenda');
    setGraphicSize(var, screenWidth) -- k
    screenCenter(var, 'x')
end

function onCreatePost()
    if downscroll then
        pos = -350
    else
        pos = 0
    end
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens' and legendas == true then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1')
            addLuaSprite('exe1', true);
        end
        if value3 == '' or value3 == 'null' or value3 == nil then
            removeLuaSprite('exe2', true);
        else
            makeLuaSprite('exe2', legendaPath..value3, 0, pos)
            propriedadescomuns('exe2')
            addLuaSprite('exe2', true);
        end
        if value4 == '' or value4 == 'null' or value4 == nil then
            removeLuaSprite('exe3', true);
        else
            makeLuaSprite('exe3', legendaPath..value4, 0, pos)
            propriedadescomuns('exe3')
            addLuaSprite('exe3', true);
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
        makeLuaSprite('exe', legendaPath..value1, 0, pos)
        propriedadescomuns('exe')
        addLuaSprite('exe', true);
        end
    end
end
