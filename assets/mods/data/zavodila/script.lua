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
                        makeLuaSprite('exe', "zavodila/"..imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', "zavodila/"..imagem, 0, -350)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        addLuaSprite('exe', true);
                    end
                else
                    if legendasporcima == true then
                        imagem = tostring(value1);
                        makeLuaSprite('exe', "zavodila/"..imagem, 0, 0)
                        setScrollFactor('exe', 0, 0);
                        scaleObject('exe', 1, 1);
                        setLuaSpriteCamera('exe', 'camhud');
                        addLuaSprite('exe', true);
                    else
                        imagem = tostring(value1);
                        makeLuaSprite('exe', "zavodila/"..imagem, 0, 0)
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

function opponentNoteHit(id,data,type,sus)
    --triggerEvent('Screen Shake','0.05, 0.01','0.01, 0.00')
    cameraShake('hud', 0.01, 0.05)
    cameraShake('game', 0.01, 0.05)
end

function onUpdate()
    if curStep == 116 then
        doTweenAlpha('basedetudo.alpha', 'basedetudo', 0, 1.5, 'linear')
        doTweenAlpha('gf.alpha', 'gf', 0, 1.5, 'linear')
        doTweenZoom('zoom', 'camGame', 1, 2.8, 'sineOut');
    end
    if curStep == 132 then
        doTweenZoom('zoom', 'camGame', 0.7, 0.05, 'sineOut');
        setProperty('gf.alpha', 1);
        setProperty('basedetudo.alpha', 1);
    end
end
