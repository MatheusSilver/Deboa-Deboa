function onCreate()
    if downscroll == true then
        if legendasporcima == true then
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, -350)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            setLuaSpriteCamera('fundo', 'camhud');
            addLuaSprite('fundo', true);
            --setProperty('fundo.alpha', 0);
        else
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, -350)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            addLuaSprite('fundo', true);
            --setProperty('fundo.alpha', 0);
        end
    else
        if legendasporcima == true then
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, 0)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            setLuaSpriteCamera('fundo', 'camhud');
            addLuaSprite('fundo', true);
            --setProperty('fundo.alpha', 0);
        else
            makeAnimatedLuaSprite('fundo', 'letras/too-fest/Legenda', 0, 0)
            addAnimationByPrefix('fundo', 'Legenda RGB', 'Legenda RGB', 24, true);
            setScrollFactor('fundo', 0, 0);
            scaleObject('fundo', 1, 1);
            addLuaSprite('fundo', true);
            --setProperty('fundo.alpha', 0);
        end
    end
end