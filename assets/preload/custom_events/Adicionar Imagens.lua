function onEvent(name, value1, value2, value3, value4)

    if name == 'Adicionar Imagens' then
        if tostring(value1) == '' then
            removeLuaSprite('exe', true);
        else
            if legendas == true then
                if downscroll == true then
                    if legendasporcima == true then
                        if tostring(value2) == ''  then
                            removeLuaSprite('exe1', true);
                        else
                            imagem1 = tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, -350)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end
                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            imagem3 = tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, -350)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end

                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        if tostring(value2) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem1 = tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, -350)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end

                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            addLuaSprite('exe2', true);
                        end

                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            imagem3 = tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, -350)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            addLuaSprite('exe3', true);
                        end

                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        addLuaSprite('exe', true);
                    end
                else
                    if legendasporcima == true then
                        if tostring(value2) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem1 = tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, 0)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            setLuaSpriteCamera('exe1', 'camhud');
                            addLuaSprite('exe1', true);
                        end

                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
                        end
                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            imagem3 = tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, 0)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            setLuaSpriteCamera('exe3', 'camhud');
                            addLuaSprite('exe3', true);
                        end

                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        if tostring(value2) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem1 = tostring(value2)
                            makeLuaSprite('exe1', imagem1, 0, 0)
                            setScrollFactor('exe1', 0, 0);
                            scaleObject('exe1', 1, 1);
                            addLuaSprite('exe1', true);
                        end

                        if tostring(value3) == '' or tostring(value3) == 'null' then
                            removeLuaSprite('exe2', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            addLuaSprite('exe2', true);
                        end

                        if tostring(value4) == '' or tostring(value4) == 'null' then
                            removeLuaSprite('exe3', true);
                        else
                            imagem3 = tostring(value4)
                            makeLuaSprite('exe3', imagem3, 0, 0)
                            setScrollFactor('exe3', 0, 0);
                            scaleObject('exe3', 1, 1);
                            addLuaSprite('exe3', true);
                        end
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        addLuaSprite('exe', true);
                    end
                end
            else
                --nada
            end
        end
    end
end