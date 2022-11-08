--[[function onStepHit()
  --  if curStep == 129 then
   --     doTweenAlpha('hud', 'camHUD', 0, 0.5, 'linear')
  --  end

    if curStep == 115 then
        setProperty('camhud.visible', true)
    end

    if curStep == 131 or curStep == 1672 then
        doTweenAlpha('hud', 'camHUD', 1, 0.5, 'linear')
    end

    if curStep == 766 or curStep == 910 then
        doTweenAlpha('hud', 'camHUD', 0, 0.0, 'linear')
    end

    if curStep == 788 or curStep == 926  or curStep == 1368  then
        doTweenAlpha('hud', 'camHUD', 1, 0.0, 'linear')
    end

    if curStep == 1168 then
        doTweenAlpha('hud', 'camHUD', 0, 2.0, 'linear')
    end

    if curStep == 1632 or curStep == 2016 then
        doTweenAlpha('hud', 'camHUD', 0, 4.0, 'linear')
    end
end
]]

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
