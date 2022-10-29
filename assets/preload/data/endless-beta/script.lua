function onEvent(name, value1, value2)

    if name == 'Adicionar Imagens' then
        if value1 == '' then
            makeLuaSprite('exe', 'fundosemnada', 0, -350)
            setScrollFactor('exe', 0, 0);
            scaleObject('exe', 1, 1);
            setLuaSpriteCamera('exe', 'camhud');
            addLuaSprite('exe', true);
        else
            if legendas == true then
                if downscroll == true then
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        addLuaSprite('exe', true);
                    end
                else
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
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

function onUpdate()
    if curStep == 910 then
        makeLuaSprite('three', 'three', 250, 50)
        setScrollFactor('three', 0, 0);
        scaleObject('three', 1, 1);
        setLuaSpriteCamera('three', 'camhud');
        addLuaSprite('three', true);
    end
    if curStep == 915 then
        removeLuaSprite('three', true)
        makeLuaSprite('two', 'two', 250, 50)
        setScrollFactor('two', 0, 0);
        scaleObject('two', 1, 1);
        setLuaSpriteCamera('two', 'camhud');
        addLuaSprite('two', true);
    end
    if curStep == 920 then
        removeLuaSprite('two', true)
        makeLuaSprite('one', 'one', 250, 50)
        setScrollFactor('one', 0, 0);
        scaleObject('one', 1, 1);
        setLuaSpriteCamera('one', 'camhud');
        addLuaSprite('one', true);
    end
    if curStep == 925 then
        removeLuaSprite('one', true)
        makeLuaSprite('go', 'gofun', 250, 50)
        setScrollFactor('go', 0, 0);
        scaleObject('go', 1, 1);
        setLuaSpriteCamera('go', 'camhud');
        addLuaSprite('go', true);
    end
    if curStep == 927 then
        removeLuaSprite('go', true)
    end

    if curStep == 1208 then
        makeLuaSprite('three', 'three', 250, 50)
        setScrollFactor('three', 0, 0);
        scaleObject('three', 1, 1);
        setLuaSpriteCamera('three', 'camhud');
        addLuaSprite('three', true);
    end
    if curStep == 1212 then
        removeLuaSprite('three', true)
        makeLuaSprite('two', 'two', 250, 50)
        setScrollFactor('two', 0, 0);
        scaleObject('two', 1, 1);
        setLuaSpriteCamera('two', 'camhud');
        addLuaSprite('two', true);
    end
    if curStep == 1216 then
        removeLuaSprite('two', true)
        makeLuaSprite('one', 'one', 250, 50)
        setScrollFactor('one', 0, 0);
        scaleObject('one', 1, 1);
        setLuaSpriteCamera('one', 'camhud');
        addLuaSprite('one', true);
    end
    if curStep == 1221 then
        removeLuaSprite('one', true)
        makeLuaSprite('go', 'gofun', 250, 50)
        setScrollFactor('go', 0, 0);
        scaleObject('go', 1, 1);
        setLuaSpriteCamera('go', 'camhud');
        addLuaSprite('go', true);
    end
    if curStep == 1226 then
        removeLuaSprite('go', true)
    end
end

function onCreate()
    precacheImage('three')
    precacheImage('two')
    precacheImage('one')
    precacheImage('gofun')
end
