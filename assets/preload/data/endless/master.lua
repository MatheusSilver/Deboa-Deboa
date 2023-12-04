	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

    function onCreate()
        setCamMove = true
        if legendas then
            pushScriptData("Adicionar Imagens diferenciado")
        end
        precacheImage('simbolo_infinito');
        precacheImage('Majin_Notes');
        precacheImage('conquistas/medalhas/achievements (btt-luxuria)');
        precacheImage('conquistas/keydSTARS/star-luxuria');



        makeLuaSprite('three', 'three', 260, 60);
        setScrollFactor('three', 0, 0);
        setProperty('three.alpha', 0.5)
        setProperty('three.visible', false)
        addLuaSprite('three', true);
    
        makeLuaSprite('two', 'two', 260, 60);
        setScrollFactor('two', 0, 0);
        setProperty('two.alpha', 0.5)
        setProperty('two.visible', false)
        addLuaSprite('two', true);
    
        makeLuaSprite('one', 'one', 260, 60);
        setScrollFactor('one', 0, 0);
        setProperty('one.alpha', 0.5)
        setProperty('one.visible', false)
        addLuaSprite('one', true);
    
        makeLuaSprite('gofun', 'gofun', 260, 60);
        setScrollFactor('gofun', 0, 0);
        setProperty('gofun.alpha', 0.5)
        setProperty('gofun.visible', false)
        addLuaSprite('gofun', true);
    end
    
    function onBeatHit() -- Isso é definitivamente um script já feito
     
        if curBeat == 222 then
            setCamMove = false
            triggerEvent('Camera Follow Pos', '690', '820')
            doTweenZoom('bruh', 'camGame', 1.2, 0.7, 'cubeInOut')
            setProperty('three.visible', true)
            doTweenAlpha('threeAlpha', 'three', 0, 0.25, 'cubeOut');
        end
    
        if curBeat == 223 then
            doTweenZoom('bruh', 'camGame', 1.5, 0.7, 'cubeInOut')
            setProperty('two.visible', true)
            doTweenAlpha('twoAlpha', 'two', 0, 0.25, 'cubeOut');
        end
    
        if curBeat == 224 then
            doTweenZoom('bruh', 'camGame', 1.8, 0.7, 'cubeInOut')
            setProperty('one.visible', true)
            doTweenAlpha('oneAlpha', 'one', 0, 0.25, 'cubeOut');
        end
    
        if curBeat == 225 then
            setCamMove = true
            triggerEvent('Camera Follow Pos', '', '')
            doTweenZoom('bruh', 'camGame', 0.9, 0.7, 'cubeInOut')
            setProperty('gofun.visible', true)
            doTweenAlpha('gofunAlpha', 'gofun', 0, 0.25, 'cubeOut');
        end

        objectPlayAnimation('funboppers2ANIM', 'bumpypillar', true)
        objectPlayAnimation('funpillarts1ANIM', 'bumpypillar', true)
        objectPlayAnimation('funboppers1ANIM', 'bumpypillar', true)
        objectPlayAnimation('funpillarts2ANIM', 'bumpypillar', true)
    end