local pos = 0;

function adjustPos(var)
    if downscroll then
        setProperty(var..".y", getProperty(var..".y")-473)
    else
        setProperty(var..".y", getProperty(var..".y")-100)
    end
end

function propriedadescomuns(var, pos)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setObjectCamera(var, 'hud2');
    setGraphicSize(var, screenWidth*1.05)
    screenCenter(var, 'x')
    adjustPos(var)
    setObjectOrder(var, getObjectOrder("botplayTxt")-pos)
    addLuaSprite(var);

    
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens diferenciado' then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1', 2)
        end
        if value3 == '' or value3 == 'null' or value3 == nil then
            removeLuaSprite('exe2', true);
        else
            makeLuaSprite('exe2', legendaPath..value3, 0, pos)
            propriedadescomuns('exe2', 3)
        end
        if value4 == '' or value4 == 'null' or value4 == nil then
            removeLuaSprite('exe3', true);
        else
            makeLuaSprite('exe3', legendaPath..value4, 0, pos)
            propriedadescomuns('exe3', 4)
        end
        if value1 == '' or value1 == 'null' or value1 == nil then
            removeLuaSprite('exe', true)
        else
            makeLuaSprite('exe', legendaPath..value1, 0, pos)
            propriedadescomuns('exe', 1)
        end
    end
end
