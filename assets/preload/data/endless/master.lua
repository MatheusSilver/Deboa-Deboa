	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

    function onCreate()
        setCamMove = true
        precacheImage('simbolo_infinito');
        precacheImage('Majin_Notes');
        precacheImage('one');
        precacheImage('three');
        precacheImage('two');
        precacheImage('gofun');



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
    
    function onStepHit() -- Isso é definitivamente um script já feito
     
        if curStep == 888 then
            setCamMove = false
            triggerEvent('Camera Follow Pos', '690', '820')
            doTweenZoom('bruh', 'camGame', 1.2, 0.7, 'cubeInOut')
            setProperty('three.visible', true)
            doTweenAlpha('threeAlpha', 'three', 0, 0.25, 'cubeOut');
        end
    
        if curStep == 891 then
            doTweenZoom('bruh', 'camGame', 1.5, 0.7, 'cubeInOut')
            setProperty('two.visible', true)
            doTweenAlpha('twoAlpha', 'two', 0, 0.25, 'cubeOut');
        end
    
        if curStep == 896 then
            doTweenZoom('bruh', 'camGame', 1.8, 0.7, 'cubeInOut')
            setProperty('one.visible', true)
            doTweenAlpha('oneAlpha', 'one', 0, 0.25, 'cubeOut');
        end
    
        if curStep == 899 then
            setCamMove = true
            triggerEvent('Camera Follow Pos', '', '')
            doTweenZoom('bruh', 'camGame', 0.9, 0.7, 'cubeInOut')
            setProperty('gofun.visible', true)
            doTweenAlpha('gofunAlpha', 'gofun', 0, 0.25, 'cubeOut');
        end
    end