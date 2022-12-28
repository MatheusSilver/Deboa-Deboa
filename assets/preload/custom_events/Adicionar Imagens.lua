function onEvent(name, value1, value2, value3)

    if name == 'Adicionar Imagens' then
        if tostring(value1) and tostring(value2) and tostring(value3) == '' then
            removeLuaSprite('exe', true);
            removeLuaSprite('exe1', true);
            removeLuaSprite('exe2', true);
        else
            if legendas == true then
                if downscroll == true then
                    if legendasporcima == true then
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
                        if tostring(value3) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
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

                        if tostring(value3) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, -350)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            addLuaSprite('exe2', true);
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

                        if tostring(value3) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            setLuaSpriteCamera('exe2', 'camhud');
                            addLuaSprite('exe2', true);
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

                        if tostring(value3) == '' then
                            removeLuaSprite('exe1', true);
                        else
                            imagem2 = tostring(value3)
                            makeLuaSprite('exe2', imagem2, 0, 0)
                            setScrollFactor('exe2', 0, 0);
                            scaleObject('exe2', 1, 1);
                            addLuaSprite('exe2', true);
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