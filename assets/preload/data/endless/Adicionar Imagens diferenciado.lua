local pos = 0;

function propriedadescomuns(var)
    setScrollFactor(var, 0, 0);
    scaleObject(var, 1, 1);
    setLuaSpriteCamera(var, 'camlegenda');
    --setGraphicSize(var, screenWidth) -- k
    if var == "exe1" then
        adjustPos(var)
    end
    screenCenter(var, 'x')
end

function adjustPos(var) --Usado para arrumar a posição da tradução em portugues da parte em 日本語
                        --Silvio Says: OTAKU FEDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDO
    if downscroll then
        setProperty(var..".y", getProperty(var..".y")+325)
    else
        setProperty(var..".y", getProperty(var..".y")-325)
    end

end

function onCreatePost()
    if downscroll then
        pos = -350
    else
        pos = 0
    end
end

function onEvent(name, value1, value2, value3, value4)
    if name == 'Adicionar Imagens diferenciado' then
        if value2 == '' or value2 == 'null' or value2 == nil then
            removeLuaSprite('exe1', true);
        else
            makeLuaSprite('exe1', legendaPath..value2, 0, pos)
            propriedadescomuns('exe1')
            addLuaSprite('exe1', true);
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
