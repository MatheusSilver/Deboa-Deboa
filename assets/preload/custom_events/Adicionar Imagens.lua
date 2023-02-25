function onEvent(name, value1, value2, value3, value4, path)

    if name == 'Adicionar Imagens' then
        if tostring(value1) == '' then
            removeLuaSprite('exe', true);
        else
            if legendas == true then
                if downscroll == true then
                        if tostring(value2) == '' or tostring(value2) == 'nil' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem1 = tostring(legendaPath)..tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, -350)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end
                        if tostring(value3) == '' or tostring(value3) == 'nil' then
                            removeLuaSprite('exe2', true);
                        else
                                imagem2 = tostring(legendaPath)..tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'nil' then
                            removeLuaSprite('exe3', true);
                        else
                                imagem3 = tostring(legendaPath)..tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, -350)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end
                            imagem = tostring(legendaPath)..tostring(value1)
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                else
                        if tostring(value2) == '' or tostring(value2) == 'nil'then
                            removeLuaSprite('exe1', true);
                        else
                                imagem1 = tostring(legendaPath)..tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, 0)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end

                        if tostring(value3) == '' or tostring(value3) == 'nil' then
                            removeLuaSprite('exe2', true);
                        else
                                imagem2 = tostring(legendaPath)..tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'nil' then
                            removeLuaSprite('exe3', true);
                        else
                                imagem3 = tostring(legendaPath)..tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, 0)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end
                            imagem = tostring(legendaPath)..tostring(value1)
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                end
            else
                --nada
            end
        end
    end
end