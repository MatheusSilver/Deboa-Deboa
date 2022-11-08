	-- Port By Lechan (Jos), Bubcraft19, Enginer Gaming

function onCreate()

    makeAnimatedLuaSprite('teste1', 'PhantomNote', -9999, -9999); --preload purposes
    makeAnimatedLuaSprite('teste2', 'staticNotes', -9999, -9999);

    addLuaSprite('teste1', true);
    addLuaSprite('teste2', true);
    
    
    makeLuaSprite('blackFuck', 'black', 0, 0);
	scaleObject('blackFuck', 6.0, 6.0);
	setObjectCamera('blackFuck', 'other');
	addLuaSprite('blackFuck', true);

	makeLuaSprite('startCircle', 'StartScreens/CircleYouCantRun', 777, 0);
	setObjectCamera('startCircle', 'other');
	addLuaSprite('startCircle', true);

	makeLuaSprite('startText', 'StartScreens/TextYouCantRun', -1200, 0);
	setObjectCamera('startText', 'other');
	addLuaSprite('startText', true);

    makeLuaSprite('vg', 'RedVG', 0, 0);
	setObjectCamera('vg', 'camHUD');
	setProperty('vg.alpha', 0)
	addLuaSprite('vg', true);

    makeAnimatedLuaSprite('daStatic', 'daSTAT', 0, 0)
    addAnimationByPrefix('daStatic', 'static', 'staticFLASH', 24, false)
    addAnimationByPrefix('daStatic', 'sumidao', 'sumidao', 24, false)
    objectPlayAnimation('daStatic', 'sumidao', false)
	scaleObject('daStatic', 3.19, 2.41);
	setObjectCamera('daStatic', 'camHUD');
    addLuaSprite('daStatic', true)

    setScrollFactor('gf', 1.37, 1);
    setScrollFactor('dad', 1.37, 1);
    setScrollFactor('boyfriend', 1.37, 1);
	addCharacterToList('sonicP2Pixel', 'dad')
	addCharacterToList('gf-pixel-sonic', 'gf')
	addCharacterToList('bf-pixel-sonic', 'bf')
end

function onSongStart()
	runTimer('textmove', 0.6)
	runTimer('textfade', 1.9)
end

function onTimerCompleted(tag)
    if tag == 'textmove' then
		doTweenX('circleTween', 'startCircle', 0, 0.5, 'linear');
		doTweenX('textTween', 'startText', 0, 0.5, 'linear');
	end
	
    if tag == 'textfade' then
		doTweenAlpha('graphicAlpha', 'blackFuck', 0, 1, 'linear');
		doTweenAlpha('circleAlpha', 'startCircle', 0, 1, 'linear');
		doTweenAlpha('textAlpha', 'startText', 0, 1, 'linear');
	end
	
    if tag == 'nojumpscare' then
		setProperty('simplejump.visible', false)
	end
end

function opponentNoteHit()
	triggerEvent('Screen Shake', '0.50, 0.005', '0, 0')
end

function onStepHit()
	if curStep == 128 or curStep == 328 or curStep == 1288 then
		triggerEvent('Play Animation', 'laugh', 'dad')
	end

	if curStep == 130 or curStep == 132 or curStep == 134 or curStep == 136 or curStep == 138 or curStep == 140 or curStep == 330 or curStep == 332 or curStep == 334 or curStep == 1290 or curStep == 1292 or curStep == 1294 then
		triggerEvent('Play Animation', 'laugh', 'dad')
	end

	if curStep == 142 or curStep == 336 or curStep == 1296 then
		triggerEvent('Play Animation', 'laugh', 'dad')
	end

	if curStep == 528 then
		objectPlayAnimation('daStatic', 'static', false)
		playSound('staticBUZZ')
		for i = 0, getProperty('playerStrums.length') do
		end
        triggerEvent('Change Character', 'dad', 'sonicP2Pixel')
        setProperty('dad.x', 600)
        setProperty('dad.y', -750)
        triggerEvent('Change Character', 'gf', 'gf-pixel-sonic')
        setProperty('girlfriend.x', 650)
        setProperty('girlfriend.y', -1300)

        triggerEvent('Change Character', 'bf', 'bf-pixel-sonic')
        setProperty('boyfriend.x', 1100)
        setProperty('boyfriend.y', -830)

	end

    if curStep == 533 then
        objectPlayAnimation('daStatic', 'sumidao', false)
    end

	if curStep == 784 then
		objectPlayAnimation('daStatic', 'static', false)
		playSound('staticBUZZ')
		for i = 0, getProperty('playerStrums.length') do
		end
        triggerEvent('Change Character', 'dad', 'sonicP2')
        setProperty('dad.x', 50)
        setProperty('dad.y', 130)
        triggerEvent('Change Character', 'gf', 'gf')
        setProperty('girlfriend.x', 400)
        setProperty('girlfriend.y', 130)
        triggerEvent('Change Character', 'bf', 'bf')
        setProperty('boyfriend.x', 800)
        setProperty('boyfriend.y', 450)
		setScrollFactor('dad', 1.3, 1);
		setScrollFactor('boyfriend', 1.3, 1);
		setScrollFactor('gf', 1.25, 1);
	end

    if curStep == 790 then
        objectPlayAnimation('daStatic', 'sumidao', false)
    end

	if curStep == 521 or curStep == 1160 then
		triggerEvent('Screen Shake', '1.5, 0.03', '1, 0.05')
	end

	if curStep == 80 or curStep == 100 or curStep == 120 or curStep == 140 or curStep == 160 or curStep == 180 or curStep == 200 or curStep == 220 or curStep == 240 or curStep == 260 or curStep == 280 or curStep == 300 or curStep == 320 or curStep == 340 or curStep == 360 or curStep == 380 or curStep == 400 or curStep == 420 or curStep == 440 or curStep == 460 or curStep == 480 or curStep == 500 or curStep == 520 or curStep == 540 or curStep == 560 or curStep == 580 or curStep == 600 or curStep == 620 or curStep == 640 or curStep == 660 or curStep == 680 or curStep == 700 or curStep == 720 or curStep == 740 or curStep == 760 or curStep == 780 or curStep == 800 or curStep == 820 or curStep == 840 or curStep == 860 or curStep == 880 or curStep == 900 or curStep == 920 or curStep == 940 or curStep == 960 or curStep == 980 or curStep == 1000 or curStep == 1020 or curStep == 1040 or curStep == 1060 or curStep == 1080 or curStep == 1100 or curStep == 1120 or curStep == 1140 or curStep == 1160 or curStep == 1180 or curStep == 1200 or curStep == 1220 or curStep == 1240 or curStep == 1260 or curStep == 1280 or curStep == 1300 or curStep == 1320 or curStep == 1340 or curStep == 1360 or curStep == 1380 or curStep == 1400 or curStep == 1420 or curStep == 1440 or curStep == 1460 or curStep == 1480 then
		doTweenAlpha('vignetteAlpha', 'vg', 1, 1, 'linear');
	end

	if curStep == 90 or curStep == 110 or curStep == 130 or curStep == 150 or curStep == 170 or curStep == 190 or curStep == 210 or curStep == 230 or curStep == 250 or curStep == 270 or curStep == 290 or curStep == 310 or curStep == 330 or curStep == 350 or curStep == 370 or curStep == 390 or curStep == 410 or curStep == 430 or curStep == 450 or curStep == 470 or curStep == 490 or curStep == 510 or curStep == 530 or curStep == 550 or curStep == 570 or curStep == 590 or curStep == 610 or curStep == 630 or curStep == 650 or curStep == 670 or curStep == 690 or curStep == 710 or curStep == 730 or curStep == 750 or curStep == 770 or curStep == 790 or curStep == 810 or curStep == 830 or curStep == 850 or curStep == 870 or curStep == 890 or curStep == 910 or curStep == 930 or curStep == 950 or curStep == 970 or curStep == 990 or curStep == 1010 or curStep == 1030 or curStep == 1050 or curStep == 1070 or curStep == 1090 or curStep == 1110 or curStep == 1130 or curStep == 1150 or curStep == 1170 or curStep == 1190 or curStep == 1210 or curStep == 1230 or curStep == 1250 or curStep == 1270 or curStep == 1290 or curStep == 1310 or curStep == 1330 or curStep == 1350 or curStep == 1370 or curStep == 1390 or curStep == 1410 or curStep == 1430 or curStep == 1450 or curStep == 1470 or curStep == 1490 then
		doTweenAlpha('vignetteAlpha', 'vg', 0, 1, 'linear');
	end

	if curStep == 528 then
		setProperty('vg.visible', false)
	end

	if curStep == 784 then
		setProperty('vg.visible', true)
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
