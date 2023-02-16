function onEvent(name, value1, value2, value3, value4, path)

    if name == 'Adicionar Imagens' then
        if tostring(value1) == '' then
            removeLuaSprite('exe', true);
        else
            if legendas == true then
                if downscroll == true then
                        if tostring(value2) == ''  then
                            removeLuaSprite('exe1', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem1 = tostring(path)..'/'..tostring(value2)
                            else
                                imagem1 = tostring(value2)
                            end
                            makeLuaSprite('exe1', imagem1, 0, -350)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end
                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem2 = tostring(path)..'/'..tostring(value3)
                            else
                                imagem2 = tostring(value3)
                            end
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem3 = tostring(path)..'/'..tostring(value4)
                            else
                                imagem3 = tostring(value4)
                            end
                            makeLuaSprite('exe3', imagem3, 0, -350)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end
                        if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                            imagem = tostring(path)..'/'..tostring(value1)
                        else
                            imagem = tostring(value1);
                        end
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                else
                        if tostring(value2) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem1 = tostring(path)..'/'..tostring(value2)
                            else
                                imagem1 = tostring(value2)
                            end
                            makeLuaSprite('exe1', imagem1, 0, 0)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end

                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem2 = tostring(path)..'/'..tostring(value3)
                            else
                                imagem2 = tostring(value3)
                            end
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                                imagem3 = tostring(path)..'/'..tostring(value4)
                            else
                                imagem3 = tostring(value4)
                            end
                            makeLuaSprite('exe3', imagem3, 0, 0)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end
                        if tostring(path) ~= '' and tostring(path) ~= 'nil' then
                            imagem = tostring(path)..'/'..tostring(value1)
                        else
                            imagem = tostring(value1)
                        end
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