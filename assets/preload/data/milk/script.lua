

function onUpdate(elapsed)
        if curStep == 4 then
            --startVideo('paaq') nunca faça isso
        end
        if curStep == 69 then
            doTweenZoom('zoom', 'camGame', 1.3, 3, 'sineOut');
            --setProperty('defaultCamZoom',1.0, 1)
        end
        if curStep == 71 then
            --setProperty('defaultCamZoom',1.05, 1)
        end
        if curStep == 73 then
            --setProperty('defaultCamZoom',1.1, 1)
        end
        if curStep == 75 then
            --setProperty('defaultCamZoom',1.15, 1)
        end
        if curStep == 77 then
            --setProperty('defaultCamZoom',1.2, 1)
        end
        if curStep == 79 then
            --setProperty('defaultCamZoom',1.25, 1)
        end
        if curStep == 81 then
           --setProperty('defaultCamZoom',1.3, 1)
        end
        if curStep == 83 then
            --setProperty('defaultCamZoom',1.35, 1)
        end
        if curStep == 85 then
            --setProperty('defaultCamZoom',1.4, 1)
        end
        if curStep == 87 then
            --setProperty('defaultCamZoom',1.45, 1)
        end
        if curStep == 89 then
            --setProperty('defaultCamZoom',1.5, 1)
        end
        if curStep == 91 then
            --setProperty('defaultCamZoom',1.55, 1)
        end
        if curStep == 93 then
            --setProperty('defaultCamZoom',1.6, 1)
        end
        if curStep == 95 then
            --setProperty('defaultCamZoom',1.65, 1)
        end
        if curStep == 96 then
            --setProperty('defaultCamZoom',0.9, 0)
            doTweenZoom('zoom', 'camGame', 0.9, 0.05, 'sineOut');
        end
        if curStep == 537 then
            setProperty('dad.alpha', 0);
            makeLuaSprite('bob', 'malditobob', 100, 550)
            setScrollFactor('bob', 1, 1);
            scaleObject('bob', 0.5, 0.5);
            addLuaSprite('bob', true);
        end
        if curStep == 558 then
            removeLuaSprite('bob', true)
            setProperty('dad.alpha', 1);
        end
        if curStep == 2272 then
            setProperty('dad.alpha', 0);
            makeLuaSprite('bob', 'malditobob', 100, 550)
            setScrollFactor('bob', 1, 1);
            scaleObject('bob', 0.5, 0.5);
            addLuaSprite('bob', true);
        end
        if curStep == 2297 then
            removeLuaSprite('bob', true)
            setProperty('dad.alpha', 1);
        end
end


function onEvent(name, value1, value2)

    if name == 'Adicionar Imagens' then
        if value1 == '' then
            makeLuaSprite('exe', 'fundosemnada', 0, -350)
            setScrollFactor('exe', 0, 0);
            scaleObject('exe', 1, 1);
            setLuaSpriteCamera('exe', 'camhud');
            addLuaSprite('exe', true);
        else
			if curStep < 2 then
				if legendas == true then
                    if downscroll == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        setProperty('exe.alpha', 0);
                        doTweenAlpha('exe.alpha', 'exe', 1, 0.1, 'linear')
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'other');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        setProperty('exe.alpha', 0);
                        doTweenAlpha('exe.alpha', 'exe', 1, 0.1, 'linear')
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'other');
                        addLuaSprite('exe', true);
                    end
				end
            elseif legendas == true then
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
